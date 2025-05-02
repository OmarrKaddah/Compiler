%{
    #include "val.h"

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();
%}

/* Value type union */
%union {
    int i;
    float f;
    char* s;
    int b; 
    val *v;
 
}

/* Token declarations */
%token <i> INT
%token <f> FLOAT
%token <s> STRING IDENTIFIER
%token <b> BOOL
%type <v> expression
%type <s> assignment_statement
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
    /* empty */
    | program statement
    ;

statement:
    assignment_statement ';'
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



assignment_statement:
    IDENTIFIER EQUAL expression ;

block_statement:
    '{' statement_list '}'
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

if_statement:
    IF '(' expression ')' block_statement
    | IF '(' expression ')' block_statement ELSE block_statement

    ;

while_statement:
    WHILE '(' expression ')' block_statement
    ;

do_while_statement:
    DO block_statement WHILE '(' expression ')' ';'
    ;

for_statement:
    FOR '(' expression ';' expression ';' expression ')' block_statement
    ;

switch_statement:
    SWITCH '(' expression ')' '{' case_list '}'
    ;

case_list:
    /* empty */
    | case_list case_statement
    ;

case_statement:
    CASE expression ':' statement ';'
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
    PRINT '(' expression ')' ';' {
        if ($3->type == TYPE_INT) {
            printf("PRINT: %d\n", $3->data.i);
        } else if ($3->type == TYPE_FLOAT) {
            printf("PRINT: %f\n", $3->data.f);
        } else if ($3->type == TYPE_STRING) {
            printf("PRINT: %s\n", $3->data.s);
        } else if ($3->type == TYPE_BOOL) {
            printf("PRINT: %s\n", $3->data.b ? "true" : "false");
        } else {
            yyerror("Unknown type in print statement");
        }
    }
;

expression:

     expression PLUS expression                                            {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f + $3->data.f;
                                                                                            printf("PRINT : %f\n", $$->data.f);
                                                                                        }
                                                                                        else if ($1->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f + $3->data.i;
                                                                                        }
                                                                                        else if ($3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.i + $3->data.f;
                                                                                        }
                                                                                        else {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_INT;
                                                                                            $$->data.i = $1->data.i + $3->data.i;
                                                                                        }
                                                                                    }
                                                                                    else {
                                                                                        yyerror("Invalid expression: cannot perform an addition operation between non-numerical expressions.");
                                                                                    } }
    | expression MINUS expression                                           {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f - $3->data.f;
                                                                                        }
                                                                                        else if ($1->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f - $3->data.i;
                                                                                        }
                                                                                        else if ($3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.i - $3->data.f;
                                                                                        }
                                                                                        else {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_INT;
                                                                                            $$->data.i = $1->data.i - $3->data.i;
                                                                                        }
                                                                                    }
                                                                                    else {
                                                                                        yyerror("Invalid expression: cannot perform a subtraction operation between non-numerical expressions.");
                                                                                    } }
    | expression MULTIPLY expression                                         {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f * $3->data.f;
                                                                                        }
                                                                                        else if ($1->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f * $3->data.i;
                                                                                        }
                                                                                        else if ($3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.i * $3->data.f;
                                                                                        }
                                                                                        else {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_INT;
                                                                                            $$->data.i = $1->data.i *$3->data.i;
                                                                                        }
                                                                                    }
                                                                                    else {
                                                                                        yyerror("Invalid expression: cannot perform an multiplication operation between non-numerical expressions.");
                                                                                    } }
    | expression DIVIDE expression {
        if ($3-> data.f== 0.0 || $3->data.i == 0) {
            yyerror("Division by zero");
            printf("Division by zero");
            $$ = 0;
        } else {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f / $3->data.f;
                                                                                            printf("PRINT : %f\n", $$->data.f);
                                                                                        }
                                                                                        else if ($1->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f / $3->data.i;
                                                                                        }
                                                                                        else if ($3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.i / $3->data.f;
                                                                                        }
                                                                                        else {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_INT;
                                                                                            $$->data.i = $1->data.i / $3->data.i;
                                                                                        }
                                                                                    }
                                                                                    else {
                                                                                        yyerror("Invalid expression: cannot perform an division operation between non-numerical expressions.");
                                                                                    } }
    }  


    | '(' expression ')' { $$ = $2; }


    | expression AND expression {}
    | expression OR expression //{ $$ = $1 || $3; }
    | expression EQUAL_EQUAL expression// { $$ = $1 == $3; }
    | expression NOT_EQUAL expression //{ $$ = $1 != $3; }
    | expression LESS expression //{ $$ = $1 < $3; }
    | expression LESS_EQUAL expression// { $$ = $1 <= $3; }
    | expression GREATER expression //{ $$ = $1 > $3; }
    | expression GREATER_EQUAL expression// { $$ = $1 >= $3; }
    | expression BIT_AND expression //{ $$ = $1 & $3; }
    | expression BIT_OR expression //{ $$ = $1 | $3; }
    | expression BIT_XOR expression //{ $$ = $1 ^ $3; }
    | NOT expression //{ $$ = !$2; }
    | BIT_NOT expression //{ $$ = ~$2; }
    | expression EQUAL expression //{ $$ = $3;  }
    | expression PLUS_EQUAL expression //{ $$ = $1 + $3;}
    | expression MINUS_EQUAL expression //{ $$ = $1 - $3; }
    | expression TIMES_EQUAL expression //{ $$ = $1 * $3; }
    | expression DIVIDE_EQUAL expression   
    /* {
        if ($3 == 0) {
            yyerror("Division by zero in assignment");
            $$ = $1;
        } else {
            $$ = $1 / $3;
        }
    } */
    /* | INCR expression //{ $$ = ++$2; }
    | expression INCR //{ $$ = $1++; } */
    | INT                                                                   {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = $1;
                                                                            }
    | FLOAT 

                                                                            {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_FLOAT;
                                                                                $$->data.f = $1;
                                                                            }

    | STRING                                                                {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_STRING;
                                                                                $$->data.s = $1;
                                                                            }


    | BOOL                                                                  {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.i = $1;
                                                                            }


    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}