#include "symbol_table.h"


SymbolTable* create_symbol_table() {
    SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable));
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->table[i] = NULL;
    }
    return table;
}


unsigned int hash(const char* name) {
    unsigned int hash = 0;
    while (*name) {
        hash = (hash << 5) + *name++;
    }
    return hash % TABLE_SIZE;
}


void insert_symbol(SymbolTable* table, const char* name, val* value) {
    unsigned int index = hash(name);
    Symbol* new_symbol = (Symbol*)malloc(sizeof(Symbol));
    new_symbol->name = strdup(name);
    new_symbol->value = value;
    new_symbol->next = table->table[index];
    table->table[index] = new_symbol;
}


val* lookup_symbol(SymbolTable* table, const char* name) {
    unsigned int index = hash(name);
    Symbol* current = table->table[index];
    while (current) {
        if (strcmp(current->name, name) == 0) {
            return current->value;
        }
        current = current->next;
    }
    return NULL; 
}
void free_symbol_table(SymbolTable* table) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        Symbol* current = table->table[i];
        while (current) {
            Symbol* temp = current;
            current = current->next;
            free(temp->name);
            free(temp->value);
            free(temp);
        }
    }
    free(table);
}
