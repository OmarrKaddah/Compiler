#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "val.h"
#include <stdbool.h>

#define TABLE_SIZE 101

typedef enum
{
    SYM_FUNCTION,
    SYM_VARIABLE,
    SYM_PARAMETER,
    SYM_CONSTANT
} SymbolType;

typedef struct Symbol
{
    char *name;
    val *value;
    SymbolType sym_type;
    struct Symbol *next;
} Symbol;

typedef struct SymbolTable
{
    Symbol *table[TABLE_SIZE];  // Hash table for current scope
    struct SymbolTable *parent; // Pointer to parent/enclosing scope
    int scope_level;            // Scope level (0 for global)
} SymbolTable;

// Creates a new symbol table (root or child)
SymbolTable *create_symbol_table(SymbolTable *parent);

// Hash function for symbol names
unsigned int hash(const char *name);

// Insert a symbol into the current scope
void insert_symbol(SymbolTable *table, const char *name, val *value, SymbolType sym_type);

// Lookup a symbol, searching from current scope outward
Symbol *lookup_symbol(SymbolTable *table, const char *name);

// Free a symbol table and its symbols (but not parents)
void free_symbol_table(SymbolTable *table);

// Check if a symbol exists in the current scope
bool is_symbol_in_current_scope(SymbolTable *table, const char *name);

#endif