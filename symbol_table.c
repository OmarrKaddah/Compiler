#include "symbol_table.h"
#include "val.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

void insert_symbol(SymbolTable *table,
                   const char *name,
                   val *value,
                   SymbolType sym_type)
{
    if (!table || !name || !value)
    {
        fprintf(stderr, "Error: Null pointer passed to insert_symbol\n");
        return;
    }

    /* 1) Check duplicate in *this* scope */
    if (is_symbol_in_current_scope(table, name))
    {
        fprintf(stderr, "Error: '%s' already declared in this scope\n", name);
        free_val(value); /* avoid leaking the caller’s `value` */
        return;
    }

    /* 2) Allocate new Symbol node */
    Symbol *new_symbol = malloc(sizeof(Symbol));
    if (!new_symbol)
    {
        fprintf(stderr, "Error: Memory allocation failed for Symbol node\n");
        free_val(value);
        return;
    }

    /* 3) Fill in fields */
    new_symbol->sym_type = sym_type;
    new_symbol->name = strdup(name);
    if (!new_symbol->name)
    {
        fprintf(stderr, "Error: Memory allocation failed for symbol name\n");
        free(new_symbol);
        free_val(value);
        return;
    }
    new_symbol->value = value;

    /* 4) Insert at head of bucket */
    unsigned int idx = hash(name);
    new_symbol->next = table->table[idx];
    table->table[idx] = new_symbol;
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
        {
            return true;
        }
        sym = sym->next;
    }
    return false;
}