#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "val.h"
#include "parameter.h"
#include <stdbool.h>

#define TABLE_SIZE 101

typedef enum
{
    SYM_FUNCTION,
    SYM_VARIABLE,

    SYM_CONSTANT
} SymbolType;

typedef struct Symbol
{
    char *name;
    val *value;
    SymbolType sym_type;
    struct Symbol *next;
    int param_count;          // For functions, the number of parameters
    int is_used;              // Flag to indicate if the symbol has been used
    struct Parameter *params; // For functions, the list of parameters
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

// In symbol_table.h
Symbol *insert_symbol(SymbolTable *table,
                      const char *name,
                      val *value,
                      SymbolType sym_type,
                      int param_count,    // number of parameters (0 if none)
                      Parameter *params); // head of linked list (NULL if none)

// Lookup a symbol, searching from current scope outward
Symbol *lookup_symbol(SymbolTable *table, const char *name);

// Free a symbol table and its symbols (but not parents)
void free_symbol_table(SymbolTable *table);

void free_val(val *v);

// Check if a symbol exists in the current scope
bool is_symbol_in_current_scope(SymbolTable *table, const char *name);

Parameter *create_param(const char *name, val *value);

Parameter *append_param(Parameter *head, Parameter *p2);

void print_symbol_table(SymbolTable *table);

// Add this with the other function declarations
void print_val(val *v);

#endif