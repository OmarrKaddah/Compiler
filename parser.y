%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(const char* s);
%}

/* Token Types */
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
%token IF ELSE WHILE DO FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT
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
    program statement
    | /* empty */
    ;

statement:
    expression ';'
    | if_statement
    | while_statement
    | do_while_statement
    | for_statement
    | switch_statement
    | declaration_statement
    | return_statement
    | break_statement
    | continue_statement
    | print_statement
    ;

if_statement:
    IF '(' expression ')' statement
    | IF '(' expression ')' statement ELSE statement
    ;

while_statement:
    WHILE '(' expression ')' statement
    ;

do_while_statement:
    DO statement WHILE '(' expression ')' ';'
    ;

for_statement:
    FOR '(' expression ';' expression ';' expression ')' statement
    ;

switch_statement:
    SWITCH '(' expression ')' '{' case_list '}'
    ;

case_list:
    case_list case_statement
    | /* empty */
    ;

case_statement:
    CASE INT ':' statement
    ;

declaration_statement:
    type_specifier expression ';'
    ;

type_specifier:
    INT
    | FLOAT
    | STRING
    | BOOL
    ;

return_statement:
    RETURN expression ';'
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
    expression PLUS expression
    | expression MINUS expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression AND expression
    | expression OR expression
    | expression EQUAL_EQUAL expression
    | expression NOT_EQUAL expression
    | NOT expression
    | '(' expression ')'
    | INT
    ;
%%

/* Subroutines */
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
