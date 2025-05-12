



%{
    #include "val.h"
    #include <string.h>
    #include <stdlib.h>
    #include <stdio.h> 
    #include "symbol_table.h"

    /* track current line number */
    extern int yylineno;
    extern char *yytext;

    SymbolTable* current_scope = NULL;
    SymbolTable* global_scope = NULL;

    void print_val(val *v);
    void free_val(val *v);

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();
%}

/* --- Enable verbose, “unexpected X, expecting Y…” messages --- */
%define parse.error verbose
%error-verbose

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
%type <i> type_specifier
%type <v> argument_list


/* Operator tokens */
%token MINUS PLUS MULTIPLY DIVIDE MOD POWER
%token AND OR NOT
%token EQUAL EQUAL_EQUAL NOT_EQUAL
%token LESS LESS_EQUAL GREATER GREATER_EQUAL
%token BIT_AND BIT_OR BIT_XOR BIT_NOT
%token PLUS_EQUAL MINUS_EQUAL TIMES_EQUAL DIVIDE_EQUAL
%token INCR
%token IF ELSE WHILE DO FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT STEP
%token T_INT T_FLOAT T_STRING T_BOOL

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
    /* syntax‐error recovery: skip bad statement up to next ';' */
    | error ';'                { yyerror("Skipping invalid statement"); yyerrok; }
    ;

function_definition:
    type_specifier IDENTIFIER '(' parameter_list ')'               {
                                                                        // Create function symbol
                                                                        val* func_val = malloc(sizeof(val));
                                                                        func_val->type = $1;
                                                                        insert_symbol(current_scope, $2, func_val, SYM_FUNCTION);
                                                                        
                                                                        // Enter function scope
                                                                        SymbolTable* func_scope = create_symbol_table(current_scope);
                                                                        current_scope = func_scope;
                                                                    }
     block_statement                                                 {
                                                                            // Exit function scope
                                                                            current_scope = current_scope->parent;
                                                                        }

    | type_specifier IDENTIFIER '(' ')'                              {
                                                                        // Similar handling for no-parameter functions
                                                                        val* func_val = malloc(sizeof(val));
                                                                        func_val->type = $1;
                                                                        insert_symbol(current_scope, $2, func_val, SYM_FUNCTION);
                                                                        
                                                                        SymbolTable* func_scope = create_symbol_table(current_scope);
                                                                        current_scope = func_scope;
                                                                    }
     block_statement                                             {
                                                                            current_scope = current_scope->parent;
                                                                        }                                                   
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
    expression        { $$ = $1; }
  | argument_list ',' expression { $$ = $3; }
  ;
assignment_statement:
    IDENTIFIER EQUAL expression
                                            {
                                            // Lookup variable
                                            Symbol* sym = lookup_symbol(current_scope, $1);
                                            if (!sym) {
                                                yyerror("Undefined variable");
                                                YYERROR;
                                            }
                                            
                                            // Check if constant
                                            if (sym->sym_type == SYM_CONSTANT) {
                                                yyerror("Cannot assign to constant");
                                                YYERROR;
                                            }
                                            
                                            // Type checking
                                            if (sym->value->type != $3->type) {
                                                yyerror("Type mismatch in assignment");
                                                YYERROR;
                                            }
                                            
                                            // Update value
                                            switch(sym->value->type) {
                                                case TYPE_INT: sym->value->data.i = $3->data.i; break;
                                                case TYPE_FLOAT: sym->value->data.f = $3->data.f; break;
                                                case TYPE_STRING: 
                                                    free(sym->value->data.s);
                                                    sym->value->data.s = strdup($3->data.s);
                                                    break;
                                                case TYPE_BOOL: sym->value->data.b = $3->data.b; break;
                                            }
                                            free_val($3);
                                        }
    ;

block_statement:
     '{' 
                                                    {
                                                        SymbolTable* new_scope = create_symbol_table(current_scope);
                                                        current_scope = new_scope;
                                                    }
     statement_list 
     '}'
                                                    {SymbolTable* parent_scope = current_scope->parent;
                                                    free(current_scope);
                                                    current_scope = parent_scope;
                                                    }
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
                                                              {
                                                                if(is_symbol_in_current_scope(current_scope, $2)) {
                                                                    yyerror("Variable already declared in this scope");
                                                                    YYERROR;
                                                                } else {
                                                                    val* v = malloc(sizeof(val));
                                                                    v->type = $1;
                                                                    switch($1) {
                                                                        case TYPE_INT: v->data.i = 0; break;
                                                                        case TYPE_FLOAT: v->data.f = 0.0f; break;
                                                                        case TYPE_STRING: v->data.s = strdup(""); break;
                                                                        case TYPE_BOOL: v->data.b = 0; break;
                                                                    }
                                                                    
                                                                    insert_symbol(current_scope, $2, v,SYM_VARIABLE);
                                                                }
                                                              }
    | type_specifier IDENTIFIER EQUAL expression
                                                                {
                                                                    // Type checking
                                                                    if ($1 != $4->type) {
                                                                        yyerror("Type mismatch in initialization");
                                                                        YYERROR;
                                                                    }
                                                                    
                                                                    // Insert symbol
                                                                    if (is_symbol_in_current_scope(current_scope, $2)) {
                                                                        yyerror("Variable already declared");
                                                                        YYERROR;
                                                                    }
                                                                    insert_symbol(current_scope, $2, $4,SYM_VARIABLE);
                                                                }
    | CONST type_specifier IDENTIFIER EQUAL expression
                                                                {
                                                                    if ($2 != $5->type) {
                                                                        yyerror("Type mismatch in constant initialization");
                                                                        YYERROR;
                                                                    }
                                                                    if (is_symbol_in_current_scope(current_scope, $3)) {
                                                                        yyerror("Constant already declared");
                                                                        YYERROR;
                                                                    }
                                                                    insert_symbol(current_scope, $3, $5, SYM_CONSTANT);
                                                                }

    ;

type_specifier:
    T_INT    { $$ = TYPE_INT; }
  | T_FLOAT  { $$ = TYPE_FLOAT; }
  | T_STRING { $$ = TYPE_STRING; }
  | T_BOOL   { $$ = TYPE_BOOL; }
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


                                                                         { switch ($3->type) {
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
     IDENTIFIER '(' argument_list ')'                                   
                                                                        {
                                                                            // Lookup function
                                                                            Symbol* func = lookup_symbol(current_scope, $1);
                                                                            if (!func || func->sym_type != SYM_FUNCTION) {
                                                                                yyerror("Undefined function");
                                                                                YYERROR;
                                                                            }
                                                                            // For now just return first argument
                                                                            $$ = $3;
                                                                        }
     | IDENTIFIER '(' ')'                                               
                                                                        {
                                                                            Symbol* func = lookup_symbol(current_scope, $1);
                                                                            if (!func || func->sym_type != SYM_FUNCTION) {
                                                                                yyerror("Undefined function");
                                                                                YYERROR;
                                                                            }
                                                                            // Return default value
                                                                            $$ = malloc(sizeof(val));
                                                                            $$->type = func->value->type;
                                                                            switch($$->type) {
                                                                                case TYPE_INT: $$->data.i = 0; break;
                                                                                case TYPE_FLOAT: $$->data.f = 0.0f; break;
                                                                                case TYPE_STRING: $$->data.s = strdup(""); break;
                                                                                case TYPE_BOOL: $$->data.b = 0; break;
                                                                            }
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
                                                                            Symbol* sym = lookup_symbol(current_scope, $1);
                                                                            if (!sym) {
                                                                                yyerror("Undefined variable");
                                                                                YYERROR;
                                                                            }
                                                                            // Create a copy of the value
                                                                            $$ = malloc(sizeof(val));
                                                                            memcpy($$, sym->value, sizeof(val));
                                                                            if ($$->type == TYPE_STRING) {
                                                                                $$->data.s = strdup(sym->value->data.s);
                                                                            }
                                                                        }
                                                                
                                                                   
                                                                    ;


%%
/* track line numbers in your lexer (lexer.l):
     \n   { ++yylineno; return '\n'; }
*/
int yylineno = 1;

void yyerror(const char* s) {
    extern char *yytext;
    fprintf(stderr,
            "Syntax error at line %d: %s near ‘%s’\n",
            yylineno, s, yytext);
}
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



int main() {
    global_scope = create_symbol_table(NULL);
    current_scope = global_scope;
    
    // Add built-in functions
    val* print_val = malloc(sizeof(val));
    print_val->type = TYPE_INT; // Dummy type
    insert_symbol(global_scope, "print", print_val, SYM_FUNCTION);
    
    int result = yyparse();
    
    // Clean up global scope
    free_symbol_table(global_scope);
    return result;
}

