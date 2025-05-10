#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "val.h"

#define TABLE_SIZE 100

typedef struct Symbol {
    char* name;       
    val* value;       
    struct Symbol* next; 
} Symbol;

typedef struct SymbolTable {
    Symbol* table[TABLE_SIZE];
} SymbolTable;


SymbolTable* create_symbol_table();
unsigned int hash(const char* name);
void insert_symbol(SymbolTable* table, const char* name, val* value);
val* lookup_symbol(SymbolTable* table, const char* name);
void free_symbol_table(SymbolTable* table);

#endif
