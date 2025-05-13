#include "symbol_table.h"
#include "val.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define SYMTAB_FILE here
FILE *SYMTAB_FILE = NULL;

// Helper function to free a linked list of Parameters
static void free_params(Parameter *params)
{
    while (params != NULL)
    {
        Parameter *tmp = params;
        params = params->next;
        free(tmp->name);
        free_val(tmp->value);
        free(tmp);
    }
}

SymbolTable *create_symbol_table(SymbolTable *parent)
{
    SymbolTable *table = malloc(sizeof(SymbolTable));
    if (!table)
    {
        fprintf(stderr, "Error: Unable to allocate SymbolTable\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < TABLE_SIZE; i++)
        table->table[i] = NULL;
    table->parent = parent;
    table->scope_level = parent ? parent->scope_level + 1 : 0;
    return table;
}

unsigned int hash(const char *name)
{
    unsigned long h = 5381;
    int c;
    while ((c = *name++))
        h = ((h << 5) + h) + c;
    return (unsigned int)(h % TABLE_SIZE);
}

void free_val(val *v)
{
    if (!v)
        return;
    if (v->type == TYPE_STRING && v->data.s)
        free(v->data.s);
    free(v);
}

Symbol *insert_symbol(SymbolTable *table,
                      const char *name,
                      val *value,
                      SymbolType sym_type,
                      int param_count,
                      Parameter *params)
{
    if (!table || !name || !value)
    {
        fprintf(stderr, "Error: Null pointer passed to insert_symbol\n");
        return NULL;
    }

    /* Check duplicate in current scope */
    if (is_symbol_in_current_scope(table, name))
    {
        fprintf(stderr, "Error: '%s' already declared in this scope\n", name);
        free_val(value);
        if (sym_type == SYM_FUNCTION)
            free_params(params);
        return NULL;
    }

    /* Allocate new Symbol node */
    Symbol *new_symbol = malloc(sizeof(Symbol));
    if (!new_symbol)
    {
        fprintf(stderr, "Error: Memory allocation failed for Symbol node\n");
        free_val(value);
        if (sym_type == SYM_FUNCTION)
            free_params(params);
        return NULL;
    }

    /* Fill in fields */
    new_symbol->sym_type = sym_type;
    new_symbol->name = strdup(name);
    if (!new_symbol->name)
    {
        fprintf(stderr, "Error: Memory allocation failed for symbol name\n");
        free(new_symbol);
        free_val(value);
        if (sym_type == SYM_FUNCTION)
            free_params(params);
        return NULL;
    }
    new_symbol->value = value;
    new_symbol->param_count = (sym_type == SYM_FUNCTION) ? param_count : 0;
    new_symbol->params = (sym_type == SYM_FUNCTION) ? params : NULL;
    new_symbol->next = NULL;

    /* Insert at head of bucket */
    unsigned int idx = hash(name);
    new_symbol->next = table->table[idx];
    table->table[idx] = new_symbol;
    return new_symbol;
}

Symbol *lookup_symbol(SymbolTable *table, const char *name)
{
    if (!table || !name)
        return NULL;
    for (SymbolTable *cur = table; cur; cur = cur->parent)
    {
        unsigned int idx = hash(name);
        for (Symbol *sym = cur->table[idx]; sym; sym = sym->next)
        {
            if (strcmp(sym->name, name) == 0)
                return sym;
        }
    }
    return NULL;
}

void free_symbol_table(SymbolTable *table)
{
    if (!table)
        return;
    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Symbol *cur = table->table[i];
        while (cur)
        {
            Symbol *tmp = cur;
            cur = cur->next;
            free(tmp->name);
            if (tmp->value)
                free_val(tmp->value);
            if (tmp->sym_type == SYM_FUNCTION && tmp->params)
                free_params(tmp->params);
            free(tmp);
        }
    }
    free(table);
}

bool is_symbol_in_current_scope(SymbolTable *table, const char *name)
{
    if (!table || !name)
        return false;
    unsigned int index = hash(name);
    Symbol *sym = table->table[index];
    while (sym)
    {
        if (strcmp(sym->name, name) == 0)
            return true;
        sym = sym->next;
    }
    return false;
}

Parameter *create_param(const char *name, val *value)
{
    Parameter *p = malloc(sizeof(Parameter));
    if (!p)
        perror("malloc"), exit(1);
    p->name = strdup(name);
    p->value = value;
    p->next = NULL;
    return p;
}

Parameter *append_param(Parameter *head, Parameter *p2)
{
    if (!head)
        return p2;
    Parameter *cur = head;
    while (cur->next)
        cur = cur->next;
    cur->next = p2;
    return head;
}

void print_symbol_table(SymbolTable *table)
{
    if (!table)
    {
        fprintf(SYMTAB_FILE, "Symbol Table: (NULL)\n");
        return;
    }

    fprintf(SYMTAB_FILE, "\n=== SYMBOL TABLE (Scope Level: %d) ===\n", table->scope_level);

    for (int i = 0; i < TABLE_SIZE; i++)
    {
        Symbol *sym = table->table[i];
        while (sym)
        {
            fprintf(SYMTAB_FILE, "- %s [%s",
                    sym->name,
                    sym->sym_type == SYM_FUNCTION ? "FUNCTION" : sym->sym_type == SYM_VARIABLE ? "VARIABLE" : "CONSTANT");

            if (sym->sym_type == SYM_FUNCTION)
            {
                fprintf(SYMTAB_FILE, ", %d params", sym->param_count);
            }
            fprintf(SYMTAB_FILE, "]\n");

            fprintf(SYMTAB_FILE, "  Value: ");
            print_val_to_file(sym->value);
            fprintf(SYMTAB_FILE, "\n");

            if (sym->sym_type == SYM_FUNCTION && sym->params)
            {
                fprintf(SYMTAB_FILE, "  Parameters:\n");
                Parameter *param = sym->params;
                while (param)
                {
                    fprintf(SYMTAB_FILE, "    - %s: ", param->name);
                    print_val_to_file(param->value);
                    fprintf(SYMTAB_FILE, "\n");
                    param = param->next;
                }
            }

            sym = sym->next;
        }
    }

    if (table->parent)
    {
        fprintf(SYMTAB_FILE, "\n--- Parent Scope ---\n");
        print_symbol_table(table->parent);
    }
}

void print_val_to_file(val *v)
{
    if (!v)
    {
        fprintf(SYMTAB_FILE, "null");
        return;
    }

    switch (v->type)
    {
    case TYPE_INT:
        fprintf(SYMTAB_FILE, "%d", v->data.i);
        break;
    case TYPE_FLOAT:
        fprintf(SYMTAB_FILE, "%f", v->data.f);
        break;
    case TYPE_STRING:
        fprintf(SYMTAB_FILE, "\"%s\"", v->data.s);
        break;
    case TYPE_BOOL:
        fprintf(SYMTAB_FILE, v->data.b ? "true" : "false");
        break;
    default:
        fprintf(SYMTAB_FILE, "unknown");
        break;
    }
}

void print_val(val *v)
{
    if (!v)
    {
        printf("NULL");
        return;
    }
    switch (v->type)
    {
    case TYPE_INT:
        printf("%d", v->data.i);
        break;
    case TYPE_FLOAT:
        printf("%f", v->data.f);
        break;
    case TYPE_STRING:
        printf("\"%s\"", v->data.s);
        break;
    case TYPE_BOOL:
        printf(v->data.b ? "true" : "false");
        break;
    default:
        printf("unknown");
    }
}