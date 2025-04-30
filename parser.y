%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();
%}

/* Value type union */
%union {
    int i;
    float f;
    char* s;
}

/* Token declarations */
%token <i> INT BOOL
%token <f> FLOAT
%token <s> STRING IDENTIFIER
%token MINUS PLUS MULTIPLY DIVIDE
%token AND OR NOT
%token EQUAL EQUAL_EQUAL NOT_EQUAL
%token LESS LESS_EQUAL GREATER GREATER_EQUAL
%token BIT_AND BIT_OR BIT_XOR BIT_NOT
%token PLUS_EQUAL MINUS_EQUAL TIMES_EQUAL DIVIDE_EQUAL
%token INCR
%token IF ELSE WHILE DO_WHILE FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT
%token INT_TYPE FLOAT_TYPE STRING_TYPE BOOL_TYPE

/* Operator precedence */
%left OR
%left AND
%left BIT_OR
%left BIT_XOR
%left BIT_AND
%left EQUAL_EQUAL NOT_EQUAL
%left LESS LESS_EQUAL GREATER GREATER_EQUAL
%left PLUS MINUS
%left MULTIPLY DIVIDE
%right NOT BIT_NOT
%right INCR

%%

program:
    /* empty */
    | program statement
    ;

statement:
    expression ';'
    | declaration ';'
    | if_statement
    | while_statement
    | do_while_statement
    | for_statement
    | switch_statement
    | return_statement
    | break_statement
    | continue_statement
    | print_statement
    | block_statement
    ;

block_statement:
    '{' statement_list '}'
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

if_statement:
    IF '(' expression ')' statement
    | IF '(' expression ')' statement ELSE statement
    ;

while_statement:
    WHILE '(' expression ')' statement
    ;

do_while_statement:
    DO_WHILE '(' expression ')' ';'
    ;

for_statement:
    FOR '(' expression ';' expression ';' expression ')' statement
    ;

switch_statement:
    SWITCH '(' expression ')' '{' case_list '}'
    ;

case_list:
    /* empty */
    | case_list case_statement
    ;

case_statement:
    CASE expression ':' statement
    ;

declaration:
    type_specifier IDENTIFIER
    | type_specifier IDENTIFIER EQUAL expression
    ;

type_specifier:
    INT_TYPE
    | FLOAT_TYPE
    | STRING_TYPE
    | BOOL_TYPE
    ;

return_statement:
    RETURN ';'
    | RETURN expression ';'
    ;

break_statement:
    BREAK ';'
    ;

continue_statement:
    CONTINUE ';'
    ;

print_statement:
    PRINT '(' expression ')' ';'
    ;

expression:
    INT
    | FLOAT
    | STRING
    | BOOL
    | IDENTIFIER
    | '(' expression ')'
    | expression PLUS expression
    | expression MINUS expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression AND expression
    | expression OR expression
    | expression EQUAL_EQUAL expression
    | expression NOT_EQUAL expression
    | expression LESS expression
    | expression LESS_EQUAL expression
    | expression GREATER expression
    | expression GREATER_EQUAL expression
    | expression BIT_AND expression
    | expression BIT_OR expression
    | expression BIT_XOR expression
    | NOT expression
    | BIT_NOT expression
    | expression EQUAL expression
    | expression PLUS_EQUAL expression
    | expression MINUS_EQUAL expression
    | expression TIMES_EQUAL expression
    | expression DIVIDE_EQUAL expression
    | INCR expression
    | expression INCR
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}