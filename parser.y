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
%type <v> expression atomic
%type <s> assignment_statement
%token MINUS PLUS MULTIPLY DIVIDE
%token AND OR NOT
%token EQUAL EQUAL_EQUAL NOT_EQUAL
%token LESS LESS_EQUAL GREATER GREATER_EQUAL
%token BIT_AND BIT_OR BIT_XOR BIT_NOT
%token PLUS_EQUAL MINUS_EQUAL TIMES_EQUAL DIVIDE_EQUAL
%token INCR
%token IF ELSE WHILE DO FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT STEP
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
    FOR '(' assignment_statement ';' expression ';' STEP '=' atomic  ')' block_statement 
    | FOR '(' declaration ';' expression ';' STEP '=' atomic   ')' block_statement
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
    | CONST type_specifier IDENTIFIER EQUAL expression
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
    //  //printf("PRINT: %d\n", $3);
    }
;

expression:
   atomic
   |

     expression PLUS atomic                                            {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f + $3->data.f;
                                                                                            //printf("PRINT : %f\n", $$->data.f);
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
    | expression MINUS atomic                                           {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
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
    | expression MULTIPLY atomic                                         {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
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
    | expression DIVIDE atomic {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {  if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        if ($1->type == TYPE_FLOAT && $3->type == TYPE_FLOAT) {
                                                                                            $$ = malloc(sizeof(val));
                                                                                            $$->type = TYPE_FLOAT;
                                                                                            $$->data.f = $1->data.f / $3->data.f;
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
    
    | expression EQUAL_EQUAL atomic {
                                                                                    if ($1->type != $3->type) {
                                                                                        yyerror("Invalid type");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;

                                                                                    } else {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        switch ($1->type) {
                                                                                            case TYPE_INT:
                                                                                                $$->data.b = ($1->data.i == $3->data.i);
                                                                                                ////printf("PRINT : %b\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_FLOAT:
                                                                                                $$->data.b = ($1->data.f == $3->data.f);
                                                                                               // //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_STRING:
                                                                                                $$->data.b = (strcmp($1->data.s, $3->data.s) == 0);
                                                                                                ////printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_BOOL:
                                                                                                $$->data.b = ($1->data.b == $3->data.b);
                                                                                               // //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            default:
                                                                                                yyerror("Invalid type for equality comparison");
                                                                                                $$->data.b = 0;
                                                                                               // //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    }
                                                                                }
    | expression NOT_EQUAL atomic {
                                                                                    if ($1->type != $3->type) {
                                                                                        yyerror("Invalid type");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 1;  
                                                                                    } else {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        switch ($1->type) {
                                                                                            case TYPE_INT:
                                                                                                $$->data.b = ($1->data.i != $3->data.i);
                                                                                                //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_FLOAT:
                                                                                                $$->data.b = ($1->data.f != $3->data.f);
                                                                                                //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_STRING:
                                                                                                $$->data.b = (strcmp($1->data.s, $3->data.s) != 0);
                                                                                                //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            case TYPE_BOOL:
                                                                                                $$->data.b = ($1->data.b != $3->data.b);
                                                                                                //printf("PRINT : %f\n", $$->data.b);
                                                                                                break;
                                                                                            default:
                                                                                                yyerror("Invalid type for inequality comparison");
                                                                                                $$->data.b = 1;
                                                                                                //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    }
                                                                                }
    | expression AND atomic {
                                                                                    if ($1->type != TYPE_BOOL || $3->type != TYPE_BOOL) {
                                                                                        yyerror("Logical AND operation requires boolean operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    } else {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = $1->data.b && $3->data.b;
                                                                                        //printf("PRINT : %f\n", $$->data.b);
                                                                                    }
                                                                                }
    | expression OR atomic {
                                                                                    if ($1->type != TYPE_BOOL || $3->type != TYPE_BOOL) {
                                                                                        yyerror("Logical OR operation requires boolean operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0; 
                                                                                    } else {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = $1->data.b || $3->data.b;
                                                                                        //printf("PRINT : %f\n", $$->data.b);
                                                                                    }
                                                                                }
    | NOT expression {
                                                                                    if ($2->type != TYPE_BOOL) {
                                                                                        yyerror("Logical NOT operation requires boolean operand");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    } else {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = !$2->data.b;
                                                                                        //printf("PRINT : %f\n", $$->data.b);
                                                                                    }
                                                                                }
    | expression LESS atomic {
                                                                                    if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                            float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            $$->data.b = (left < right);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        } else {
                                                                                            $$->data.b = ($1->data.i < $3->data.i);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    } else {
                                                                                        yyerror("Comparison operator '<' requires numeric operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    }
                                                                                }
    | expression LESS_EQUAL atomic {
                                                                                    if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                            float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            $$->data.b = (left <= right);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        } else {
                                                                                            $$->data.b = ($1->data.i <= $3->data.i);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    } else {
                                                                                        yyerror("Comparison operator '<=' requires numeric operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    }
                                                                                }
    | expression GREATER atomic {
                                                                                    if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                            float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            $$->data.b = (left > right);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        } else {
                                                                                            $$->data.b = ($1->data.i > $3->data.i);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    } else {
                                                                                        yyerror("Comparison operator '>' requires numeric operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    }
                                                                                }
    | expression GREATER_EQUAL atomic {
                                                                                    if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                            float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            $$->data.b = (left >= right);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        } else {
                                                                                            $$->data.b = ($1->data.i >= $3->data.i);
                                                                                            //printf("PRINT : %f\n", $$->data.b);
                                                                                        }
                                                                                    } else {
                                                                                        yyerror("Comparison operator '>=' requires numeric operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_BOOL;
                                                                                        $$->data.b = 0;
                                                                                    }
                                                                                }
    | INCR expression {
                                                                                    if ($2->type != TYPE_INT && $2->type != TYPE_FLOAT) {
                                                                                        yyerror("Increment operator requires numeric variable");
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    $$ = malloc(sizeof(val));
                                                                                    $$->type = $2->type;
                                                                                    
                                                                                    if ($2->type == TYPE_INT) {
                                                                                        $$->data.i = ++($2->data.i);
                                                                                        //printf("PRINT : %f\n", $$->data.i);  
                                                                                    } else {
                                                                                        $$->data.f = ++($2->data.f); 
                                                                                        //printf("PRINT : %f\n", $$->data.f);
                                                                                    }
                                                                                }
    | expression INCR {
                                                                                    if ($1->type != TYPE_INT && $1->type != TYPE_FLOAT) {
                                                                                        yyerror("Increment operator requires numeric variable");
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    $$ = malloc(sizeof(val));
                                                                                    $$->type = $1->type;
                                                                                    
                                                                                    if ($1->type == TYPE_INT) {
                                                                                        $$->data.i = $1->data.i++;  
                                                                                        //printf("PRINT : %f\n", $$->data.i);
                                                                                    } else {
                                                                                        $$->data.f = $1->data.f++;  
                                                                                        //printf("PRINT : %f\n", $$->data.f);
                                                                                    }
                                                                                }
    | expression BIT_AND expression {
                                                                                    if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = $1->data.i & $3->data.i;
                                                                                        //printf("PRINT : %f\n", $$->data.i);
                                                                                    } else {
                                                                                        yyerror("Bitwise AND requires integer operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = 0;
                                                                                    }
                                                                                }

    | expression BIT_OR expression {
                                                                                    if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = $1->data.i | $3->data.i;
                                                                                  //      //printf("PRINT : %f\n", $$->data.i);
                                                                                    } else {
                                                                                        yyerror("Bitwise OR requires integer operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = 0;
                                                                                    }
                                                                                }

    | expression BIT_XOR expression {
                                                                                    if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = $1->data.i ^ $3->data.i;
                                                                                        //printf("PRINT : %f\n", $$->data.i);
                                                                                    } else {
                                                                                        yyerror("Bitwise XOR requires integer operands");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = 0;
                                                                                    }
                                                                                }

    | BIT_NOT expression {
                                                                                    if ($2->type == TYPE_INT) {
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = ~$2->data.i;
                                                                                        //printf("PRINT : %f\n", $$->data.i);
                                                                                    } else {
                                                                                        yyerror("Bitwise NOT requires integer operand");
                                                                                        $$ = malloc(sizeof(val));
                                                                                        $$->type = TYPE_INT;
                                                                                        $$->data.i = 0;
                                                                                    }
                                                                                }
                                                                                
    /* Plus-Equal (+=) */
    /* | IDENTIFIER PLUS_EQUAL expression {
                                                                                    val *var = lookup_variable($1);  // Get the variable from symbol table
                                                                                    if (!var) {
                                                                                        yyerror("Undefined variable '%s'", $1);
                                                                                        free($1);
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    if ((var->type == TYPE_INT || var->type == TYPE_FLOAT) &&
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        
                                                                                        if (var->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                            var->data.i += $3->data.i;
                                                                                        } else {
                                                                                            // Promote to float if needed
                                                                                            if (var->type == TYPE_INT) {
                                                                                                var->data.f = (float)var->data.i;
                                                                                                var->type = TYPE_FLOAT;
                                                                                            }
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            var->data.f += right;
                                                                                        }
                                                                                        
                                                                                        $$ = var;  // Return the modified variable
                                                                                    } else {
                                                                                        yyerror("Invalid types for '+=' operation");
                                                                                        $$ = var;  // Return original value on error
                                                                                    }
                                                                                    free($1);  // Free the identifier string
                                                                                } */

/* Minus-Equal (-=) */
    /* | IDENTIFIER MINUS_EQUAL expression {
                                                                                    val *var = lookup_variable($1);
                                                                                    if (!var) {
                                                                                        yyerror("Undefined variable '%s'", $1);
                                                                                        free($1);
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    if ((var->type == TYPE_INT || var->type == TYPE_FLOAT) &&
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        
                                                                                        if (var->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                            var->data.i -= $3->data.i;
                                                                                        } else {
                                                                                            if (var->type == TYPE_INT) {
                                                                                                var->data.f = (float)var->data.i;
                                                                                                var->type = TYPE_FLOAT;
                                                                                            }
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            var->data.f -= right;
                                                                                        }
                                                                                        
                                                                                        $$ = var;
                                                                                    } else {
                                                                                        yyerror("Invalid types for '-=' operation");
                                                                                        $$ = var;
                                                                                    }
                                                                                    free($1);
                                                                                } */

/* Times-Equal (*=) */
    /* | IDENTIFIER TIMES_EQUAL expression {
                                                                                    val *var = lookup_variable($1);
                                                                                    if (!var) {
                                                                                        yyerror("Undefined variable '%s'", $1);
                                                                                        free($1);
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    if ((var->type == TYPE_INT || var->type == TYPE_FLOAT) &&
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        
                                                                                        if (var->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                            var->data.i *= $3->data.i;
                                                                                        } else {
                                                                                            if (var->type == TYPE_INT) {
                                                                                                var->data.f = (float)var->data.i;
                                                                                                var->type = TYPE_FLOAT;
                                                                                            }
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            var->data.f *= right;
                                                                                        }
                                                                                        
                                                                                        $$ = var;
                                                                                    } else {
                                                                                        yyerror("Invalid types for '*=' operation");
                                                                                        $$ = var;
                                                                                    }
                                                                                    free($1);
                                                                                } */

/* Divide-Equal (/=) */
    /* | IDENTIFIER DIVIDE_EQUAL expression {
                                                                                    val *var = lookup_variable($1);
                                                                                    if (!var) {
                                                                                        yyerror("Undefined variable '%s'", $1);
                                                                                        free($1);
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    // Check for division by zero
                                                                                    if (($3->type == TYPE_INT && $3->data.i == 0) ||
                                                                                        ($3->type == TYPE_FLOAT && $3->data.f == 0.0f)) {
                                                                                        yyerror("Division by zero");
                                                                                        $$ = var;
                                                                                        free($1);
                                                                                        YYERROR;
                                                                                    }
                                                                                    
                                                                                    if ((var->type == TYPE_INT || var->type == TYPE_FLOAT) &&
                                                                                        ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                        
                                                                                        if (var->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                            var->data.i /= $3->data.i;
                                                                                        } else {
                                                                                            if (var->type == TYPE_INT) {
                                                                                                var->data.f = (float)var->data.i;
                                                                                                var->type = TYPE_FLOAT;
                                                                                            }
                                                                                            float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                            var->data.f /= right;
                                                                                        }
                                                                                        
                                                                                        $$ = var;
                                                                                    } else {
                                                                                        yyerror("Invalid types for '/=' operation");
                                                                                        $$ = var;
                                                                                    }
                                                                                    free($1);
                                                                                } */
                                                                                
;

    //| '(' expression ')' { $$ = $2; };


    /* | expression AND expression //{ $$ = $1 && $3; }                                  1
    | expression OR expression //{ $$ = $1 || $3; }                                       1
    | expression EQUAL_EQUAL expression// { $$ = $1 == $3; }                              1
    | expression NOT_EQUAL expression //{ $$ = $1 != $3; }                                1
    | expression LESS expression //{ $$ = $1 < $3; }                                        1                                       
    | expression LESS_EQUAL expression// { $$ = $1 <= $3; }                                 1
    | expression GREATER expression //{ $$ = $1 > $3; }                                     1
    | expression GREATER_EQUAL expression// { $$ = $1 >= $3; }                              1
    | expression BIT_AND expression //{ $$ = $1 & $3; }                                     1
    | expression BIT_OR expression //{ $$ = $1 | $3; }                                      1
    | expression BIT_XOR expression //{ $$ = $1 ^ $3; }                                     1
    | NOT expression //{ $$ = !$2; }                                                         1
    | BIT_NOT expression //{ $$ = ~$2; }                                                    1
    | expression PLUS_EQUAL expression //{ $$ = $1 + $3;}                                      1
    | expression MINUS_EQUAL expression //{ $$ = $1 - $3; }                                     1
    | expression TIMES_EQUAL expression //{ $$ = $1 * $3; }                                     1
    | expression DIVIDE_EQUAL expression                                                         1*/                                                   
    /* {
        if ($3 == 0) {
            yyerror("Division by zero in assignment");
            $$ = $1;
        } else {
            $$ = $1 / $3;
        }
    } */
    /* | INCR expression //{ $$ = ++$2; }                                                    1
    | expression INCR //{ $$ = $1++; }                                                     1*/
atomic:
      INT                                                                   {
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
    | IDENTIFIER                                                            {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_STRING;
                                                                                $$->data.s = $1;
                                                                            }
    | '(' expression ')'                                                    {
                                                                                $$ = $2;
                                                                            }


    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}