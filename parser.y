%{
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    void yyerror(const char* s);
%}

/* Tokens */
%token MINUS PLUS MULTIPLY DIVIDE
%token AND OR NOT
%token EQUAL EQUAL_EQUAL NOT_EQUAL
%token IF ELSE WHILE DO FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT
%token INT FLOAT CHAR STRING BOOL

/* Grammar Rules */
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
    | CHAR
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
