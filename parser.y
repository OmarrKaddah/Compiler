%{
    #include "val.h"
    #include <string.h>
    #include <stdlib.h>
    #include <stdio.h> 


    void print_val(val *v);
    void free_val(val *v);

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();
%}


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
%type <v> expression atomic function_call
%type <s> assignment_statement print_statement 

/* Operator tokens */
%token MINUS PLUS MULTIPLY DIVIDE MOD POWER
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
%left MULTIPLY DIVIDE MOD
%right NOT BIT_NOT 
%right POWER
%right INCR

%%

program:
    /* empty */
    | program statement
    | program function_definition
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
    | function_call_statement ';'
    ;

function_definition:
    type_specifier IDENTIFIER '(' parameter_list ')' block_statement
    | type_specifier IDENTIFIER '(' ')' block_statement
    ;
parameter_list:
    parameter_declaration
    | parameter_list ',' parameter_declaration
    ;
parameter_declaration:
    type_specifier IDENTIFIER
    ;
function_call_statement:
    IDENTIFIER '(' argument_list ')'                        //{
                                                                /* $$.name = $1;
                                                                $$.value = $3;
                                                            } */
    | IDENTIFIER '(' ')'
                                                            /* {
                                                                $$.name = $1;
                                                                $$.value = NULL;
                                                            }
                                                            ; */

argument_list:
    expression
    | argument_list ',' expression
    ;
assignment_statement:
    IDENTIFIER EQUAL expression
    ;

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
    FOR '(' assignment_statement ';' expression ';' STEP '=' atomic ')' block_statement 
    | FOR '(' declaration ';' expression ';' STEP '=' atomic ')' block_statement
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


                                                                          switch ($3->type) {
                                                                              case TYPE_INT:
                                                                                  printf("%d\n", $3->data.i);
                                                                                  break;
                                                                              case TYPE_FLOAT:
                                                                                  printf("%f\n", $3->data.f);
                                                                                  break;
                                                                              case TYPE_STRING:
                                                                                  printf("%s\n", $3->data.s);
                                                                                  break;
                                                                              case TYPE_BOOL:
                                                                                  printf($3->data.b ? "true\n" : "false\n");
                                                                                  break;
                                                                              default:
                                                                                  yyerror("Unknown type in print statement");
                                                                          }

                                                                          // Free the allocated val structure
                                                                          free($3);
                                                                      }
                                                                      ;

expression:
    atomic
    | function_call {
        $$ = $1;
    }
    | expression PLUS expression %prec PLUS
                                                                      { 
                                                                          if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                              ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                              $$ = malloc(sizeof(val));
                                                                              if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                  $$->type = TYPE_FLOAT;
                                                                                  float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                  float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                  $$->data.f = left + right;
                                                                              } else {
                                                                                  $$->type = TYPE_INT;
                                                                                  $$->data.i = $1->data.i + $3->data.i;
                                                                              }
                                                                          } else {
                                                                              yyerror("Invalid expression: cannot perform addition between non-numerical expressions.");
                                                                          }
                                                                      }
    | expression MINUS expression %prec MINUS
                                                                       {
                                                                           if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                               ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                               $$ = malloc(sizeof(val));
                                                                               if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                   $$->type = TYPE_FLOAT;
                                                                                   float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                   float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                   $$->data.f = left - right;
                                                                               } else {
                                                                                   $$->type = TYPE_INT;
                                                                                   $$->data.i = $1->data.i - $3->data.i;
                                                                               }
                                                                           } else {
                                                                               yyerror("Invalid expression: cannot perform subtraction between non-numerical expressions.");
                                                                           }
                                                                       }
    | expression MULTIPLY expression %prec MULTIPLY
                                                                     {
                                                                         if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                             ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                             $$ = malloc(sizeof(val));
                                                                             if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                 $$->type = TYPE_FLOAT;
                                                                                 float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                 float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                 $$->data.f = left * right;
                                                                             } else {
                                                                                 $$->type = TYPE_INT;
                                                                                 $$->data.i = $1->data.i * $3->data.i;
                                                                             }
                                                                         } else {
                                                                             yyerror("Invalid expression: cannot perform multiplication between non-numerical expressions.");
                                                                         }
                                                                     }
    | expression DIVIDE expression %prec DIVIDE
                                                                     {
                                                                         if (($3->type == TYPE_INT && $3->data.i == 0) ||
                                                                             ($3->type == TYPE_FLOAT && $3->data.f == 0.0f)) {
                                                                             yyerror("Division by zero");
                                                                         } else if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                   ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                             $$ = malloc(sizeof(val));
                                                                             $$->type = TYPE_FLOAT;
                                                                             float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                             float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                             $$->data.f = left / right;
                                                                         } else {
                                                                             yyerror("Invalid expression: cannot perform division between non-numerical expressions.");
                                                                         }
                                                                     }
    | expression EQUAL_EQUAL expression %prec EQUAL_EQUAL
                                                                     {
                                                                         if ($1->type != $3->type) {
                                                                             yyerror("Invalid type for equality comparison");
                                                                             $$ = malloc(sizeof(val));
                                                                             $$->type = TYPE_BOOL;
                                                                             $$->data.b = 0;
                                                                             
                                                                             // Print the failed comparison
                                                                             printf("Comparison failed: ");
                                                                             print_val($1);
                                                                             printf(" == ");
                                                                             print_val($3);
                                                                             printf(" -> false (type mismatch)\n");
                                                                         } else {
                                                                             $$ = malloc(sizeof(val));
                                                                             $$->type = TYPE_BOOL;
                                                                             int result;
                                                                             switch ($1->type) {
                                                                                 case TYPE_INT:
                                                                                     result = ($1->data.i == $3->data.i);
                                                                                     $$->data.b = result;
                                                                                     break;
                                                                                 case TYPE_FLOAT:
                                                                                     result = ($1->data.f == $3->data.f);
                                                                                     $$->data.b = result;
                                                                                     break;
                                                                                 case TYPE_STRING:
                                                                                     result = (strcmp($1->data.s, $3->data.s) == 0);
                                                                                     $$->data.b = result;
                                                                                     break;
                                                                                 case TYPE_BOOL:
                                                                                     result = ($1->data.b == $3->data.b);
                                                                                     $$->data.b = result;
                                                                                     break;
                                                                                 default:
                                                                                     yyerror("Invalid type for equality comparison");
                                                                                     $$->data.b = 0;
                                                                                     result = 0;
                                                                             }
                                                                             
                                                                             // Print the comparison and result
                                                                             printf("Comparison: ");
                                                                             print_val($1);
                                                                             printf(" == ");
                                                                             print_val($3);
                                                                             printf(" -> %s\n", result ? "true" : "false");
                                                                         }
                                                                         
                                                                         // Free the operands
                                                                         free_val($1);
                                                                         free_val($3);
                                                                     }
    | expression NOT_EQUAL expression %prec NOT_EQUAL
                                                                      {
                                                                          if ($1->type != $3->type) {
                                                                              yyerror("Invalid type for inequality comparison");
                                                                              $$ = malloc(sizeof(val));
                                                                              $$->type = TYPE_BOOL;
                                                                              $$->data.b = 1;
                                                                          } else {
                                                                              $$ = malloc(sizeof(val));
                                                                              $$->type = TYPE_BOOL;
                                                                              switch ($1->type) {
                                                                                  case TYPE_INT:
                                                                                      $$->data.b = ($1->data.i != $3->data.i);
                                                                                      break;
                                                                                  case TYPE_FLOAT:
                                                                                      $$->data.b = ($1->data.f != $3->data.f);
                                                                                      break;
                                                                                  case TYPE_STRING:
                                                                                      $$->data.b = (strcmp($1->data.s, $3->data.s) != 0);
                                                                                      break;
                                                                                  case TYPE_BOOL:
                                                                                      $$->data.b = ($1->data.b != $3->data.b);
                                                                                      break;
                                                                                  default:
                                                                                      yyerror("Invalid type for inequality comparison");
                                                                                      $$->data.b = 1;
                                                                              }
                                                                          }
                                                                      }
    | expression AND expression %prec AND
                                                                      {
                                                                          if ($1->type != TYPE_BOOL || $3->type != TYPE_BOOL) {
                                                                              yyerror("Logical AND requires boolean operands");
                                                                              $$ = malloc(sizeof(val));
                                                                              $$->type = TYPE_BOOL;
                                                                              $$->data.b = 0;
                                                                          } else {
                                                                              $$ = malloc(sizeof(val));
                                                                              $$->type = TYPE_BOOL;
                                                                              $$->data.b = $1->data.b && $3->data.b;
                                                                          }
                                                                      }
    | expression OR expression %prec OR
                                                                        {
                                                                            if ($1->type != TYPE_BOOL || $3->type != TYPE_BOOL) {
                                                                                yyerror("Logical OR requires boolean operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            } else {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = $1->data.b || $3->data.b;
                                                                            }
                                                                        }
    | expression LESS expression %prec LESS
                                                                        {
                                                                            if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                $$->data.b = (left < right);
                                                                            } else {
                                                                                yyerror("Comparison operator '<' requires numeric operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            }
                                                                        }
    | expression LESS_EQUAL expression %prec LESS_EQUAL
                                                                        {
                                                                            if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                $$->data.b = (left <= right);
                                                                            } else {
                                                                                yyerror("Comparison operator '<=' requires numeric operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            }
                                                                        }
    | expression GREATER expression %prec GREATER
                                                                        {
                                                                            if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                $$->data.b = (left > right);
                                                                            } else {
                                                                                yyerror("Comparison operator '>' requires numeric operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            }
                                                                        }
    | expression GREATER_EQUAL expression %prec GREATER_EQUAL
                                                                        {
                                                                            if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                                ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                $$->data.b = (left >= right);
                                                                            } else {
                                                                                yyerror("Comparison operator '>=' requires numeric operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            }
                                                                        }
    | expression BIT_AND expression %prec BIT_AND
                                                                        {
                                                                            if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = $1->data.i & $3->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise AND requires integer operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = 0;
                                                                            }
                                                                        }
    | expression BIT_OR expression %prec BIT_OR
                                                                        {
                                                                            if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = $1->data.i | $3->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise OR requires integer operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = 0;
                                                                            }
                                                                        }
    | expression BIT_XOR expression %prec BIT_XOR
                                                                        {
                                                                            if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = $1->data.i ^ $3->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise XOR requires integer operands");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = 0;
                                                                            }
                                                                        }
    | NOT expression %prec NOT
                                                                        {
                                                                            if ($2->type != TYPE_BOOL) {
                                                                                yyerror("Logical NOT requires boolean operand");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = 0;
                                                                            } else {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_BOOL;
                                                                                $$->data.b = !$2->data.b;
                                                                            }
                                                                        }
    | BIT_NOT expression %prec BIT_NOT
                                                                        {
                                                                            if ($2->type != TYPE_INT) {
                                                                                yyerror("Bitwise NOT requires integer operand");
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = 0;
                                                                            } else {
                                                                                $$ = malloc(sizeof(val));
                                                                                $$->type = TYPE_INT;
                                                                                $$->data.i = ~$2->data.i;
                                                                            }
                                                                        }
    | INCR expression %prec INCR
                                                                        {
                                                                            if ($2->type != TYPE_INT && $2->type != TYPE_FLOAT) {
                                                                                yyerror("Increment requires numeric operand");
                                                                                YYERROR;
                                                                            }
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = $2->type;
                                                                            if ($2->type == TYPE_INT) {
                                                                                $$->data.i = ++($2->data.i);
                                                                            } else {
                                                                                $$->data.f = ++($2->data.f);
                                                                            }
                                                                        }
    | expression INCR %prec INCR
                                                                        {
                                                                            if ($1->type != TYPE_INT && $1->type != TYPE_FLOAT) {
                                                                                yyerror("Increment requires numeric operand");
                                                                                YYERROR;
                                                                            }
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = $1->type;
                                                                            if ($1->type == TYPE_INT) {
                                                                                $$->data.i = $1->data.i++;
                                                                            } else {
                                                                                $$->data.f = $1->data.f++;
                                                                            }
                                                                        }
                                                                            | expression MOD expression %prec MOD
        {
            if ($3->type == TYPE_INT && $3->data.i == 0) {
                yyerror("Modulus by zero");
            } else if ($1->type == TYPE_INT && $3->type == TYPE_INT) {
                $$ = malloc(sizeof(val));
                $$->type = TYPE_INT;
                $$->data.i = $1->data.i % $3->data.i;
            } else {
                yyerror("Modulus requires integer operands");
                $$ = malloc(sizeof(val));
                $$->type = TYPE_INT;
                $$->data.i = 0;
            }
        }
    | expression POWER expression %prec POWER
        {
            if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                $$ = malloc(sizeof(val));
                if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                    $$->type = TYPE_FLOAT;
                    float base = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                    float exponent = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                    $$->data.f = powf(base, exponent);
                } else {
                    $$->type = TYPE_INT;
                    // Simple integer power (won't handle negative exponents well)
                    int result = 1;
                    for (int i = 0; i < $3->data.i; i++) {
                        result *= $1->data.i;
                    }
                    $$->data.i = result;
                }
            } else {
                yyerror("Power operation requires numeric operands");
                $$ = malloc(sizeof(val));
                $$->type = TYPE_INT;
                $$->data.i = 0;
            }
        }
    | '(' expression ')'
                                                                        {
                                                                            $$ = $2;
                                                                        }
                                                                    ;
function_call:
     IDENTIFIER '(' argument_list ')'                                    {
                                                                            // Here you would implement function call logic
                                                                            // For now, just return the first argument as an example
                                                                            // $$ = $3;
                                                                        }
     | IDENTIFIER '(' ')'                                               {
                                                                            // $$ = malloc(sizeof(val));
                                                                            // $$->type = TYPE_INT;
                                                                            // $$->data.i = 0; // Default return for no-arg functions
                                                                        }
                                                                        ;
atomic:
    INT
                                                                        {
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
    | STRING
                                                                        {
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = TYPE_STRING;
                                                                            $$->data.s = $1;
                                                                        }
    | BOOL
                                                                        {
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = TYPE_BOOL;
                                                                            $$->data.b = $1;
                                                                        }
    | IDENTIFIER
                                                                        {
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = TYPE_STRING;
                                                                            $$->data.s = $1;
                                                                        }
                                                                    ;

%%
/* Helper function implementations */
void print_val(val *v) {
    if (v == NULL) {
        printf("NULL");
        return;
    }
    
    switch (v->type) {
        case TYPE_INT:
            printf("%d", v->data.i);
            break;
        case TYPE_FLOAT:
            printf("%f", v->data.f);
            break;
        case TYPE_STRING:
            printf("%s", v->data.s);
            break;
        case TYPE_BOOL:
            printf("%s", v->data.b ? "true" : "false");
            break;
        default:
            printf("unknown");
    }
}

void free_val(val *v) {
    if (v == NULL) return;
    
    if (v->type == TYPE_STRING && v->data.s != NULL) {
        free(v->data.s);
    }
    free(v);
}

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}


int main() {
    return yyparse();
}