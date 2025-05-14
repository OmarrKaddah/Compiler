%{
    #include "val.h"
    #include <string.h>
    #include <stdlib.h>
    #include <stdio.h> 
    #include "symbol_table.h"
    #include "quadruples.h"



    #define MAX_NESTED_LOOPS 16
    char* loop_variable_stack[MAX_NESTED_LOOPS];
    int loop_var_top = -1;
    char* current_switch_place   = NULL;  // the “scrutinee” variable/place
    char* current_switch_endLabel = NULL; // label to jump to after the switch
    char * do_while_label = NULL;
    char * for_loop_end_label = NULL;
    char * for_loop_false_label = NULL;
    char *cmpTemp   = NULL;
    char *caseLabel = NULL;
    char *skipLabel = NULL;
    char* break_label_stack[MAX_NESTED_LOOPS];
    char* continue_label_stack[MAX_NESTED_LOOPS];



        // counters for temps & labels
    static int _temp_cnt = 0;
    static char *new_temp();
    static int  _label_cnt = 0;

    

    /* return a new label name, e.g. "L1", "L2", ... */
    static char *new_label();

     val* create_default_value(Type type);
    void print_val(val *v);
    void free_val(val *v);
    const char *type_to_string(Type t);
    /* track current line number */
    extern int yylineno;
    extern char *yytext;

    SymbolTable* current_scope = NULL;
    SymbolTable* global_scope = NULL;
    SymbolTable* parent_scope = NULL;
    Parameter *current_params = NULL; // Global tracker for parameters
    Symbol *last_symbol_inserted=NULL;
    static Symbol *current_function = NULL;
    static Type current_switch_type;

    void print_val(val *v);
    void free_val(val *v);

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();
%}
%code requires {
  #include "symbol_table.h"   /* pulls in parameter.h */
}


/* --- Enable verbose, “unexpected X, expecting Y…” messages --- */
/* %define parse.error verbose
%error-verbose */

%union {
    int i;
    float f;
    char* s;
    int b; 
    val *v;
    Parameter *p;
    char  *place; 
}

/* Token declarations */
%token <i> INT
%token <f> FLOAT
%token <s> STRING IDENTIFIER
%token <b> BOOL
%type <v> expression atomic function_call do_while_statement for_statement switch_statement
%type <s> assignment_statement print_statement 
%type <i> type_specifier
%type <p> argument_list
%type <p> parameter_list parameter_declaration

/* Operator tokens */
%token MINUS PLUS MULTIPLY DIVIDE MOD POWER
%token AND OR NOT
%token EQUAL EQUAL_EQUAL NOT_EQUAL
%token LESS LESS_EQUAL GREATER GREATER_EQUAL
%token BIT_AND BIT_OR BIT_XOR BIT_NOT
%token PLUS_EQUAL MINUS_EQUAL TIMES_EQUAL DIVIDE_EQUAL
%token INCR
%token IF IFELSE WHILE DO FOR SWITCH CASE CONST BREAK CONTINUE RETURN PRINT STEP
%token T_INT T_FLOAT T_STRING T_BOOL T_VOID

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
    | do_while_statement';'
    | for_statement
    | switch_statement
    | return_statement';'
    | break_statement';'
    | continue_statement';'
    | print_statement';'  
    | block_statement
    | function_call_statement ';'
    ;

function_definition:
    type_specifier IDENTIFIER '(' parameter_list ')' 
                                                                    {
                                                                        val *func_val = malloc(sizeof(val));
                                                                        func_val->type = $1;

                                                                        // Count parameters
                                                                        int param_count = 0;
                                                                        Parameter *p = $4;
                                                                        while (p) { param_count++; p = p->next; }

                                                                        printf("parameter count %d ---",param_count);
                                                                        // Insert function with parameters
                                                                        last_symbol_inserted = insert_symbol(current_scope, $2, func_val, SYM_FUNCTION, param_count, $4);
                                                                        current_function     = last_symbol_inserted;
                                                                        current_params = $4; // Store for block_statement
                                                                        add_quad("LABEL", $2, "", "");
                                                                    }
    block_statement                                                 
                                                                    { 
                                                                        current_params = NULL; 
                                                                        current_function = NULL;  
                                                                         add_quad("END", $2, "", "");
                                                                    
                                                                    } // Reset
    

    | type_specifier IDENTIFIER '(' ')'                              {
                                                                        // Similar handling for no-parameter functions
                                                                        val* func_val = malloc(sizeof(val));
                                                                        func_val->type = $1;
                                                                        last_symbol_inserted=insert_symbol(current_scope, $2, func_val, SYM_FUNCTION,0,NULL);
                                                                        current_function = last_symbol_inserted;
                                                                         add_quad("LABEL", $2, "", "");
                                                                    }
     block_statement                                          
                                                                   {   add_quad("END", $2, "", "");
                                                                     current_function = NULL;   }                                                   
    ;
parameter_declaration:
    type_specifier IDENTIFIER
                                                {
                                                    val *v = malloc(sizeof(val));
                                                    v->type = $1;
                                                    switch ($1) { // Initialize default value
                                                        case TYPE_INT: v->data.i = 0; break;
                                                        case TYPE_FLOAT: v->data.f = 0.0f; break;
                                                        case TYPE_STRING: v->data.s = strdup(""); break;
                                                        case TYPE_BOOL: v->data.b = 0; break;
                                                    }
                                                    v->place=$2;

                                                    $$ = create_param($2, v);
                                                }
    ;

parameter_list:
    parameter_declaration                  { $$ = $1; }
    | parameter_list ',' parameter_declaration { $$ = append_param($1, $3); }
    ;
function_call_statement:
    IDENTIFIER '(' argument_list ')'                        
                                                            {
                                                                
                                                                Symbol* func = lookup_symbol(current_scope, $1);
                                                                if (!func || func->sym_type != SYM_FUNCTION) {
                                                                    yyerror("Undefined function");
                                                                    YYERROR;
                                                                }

                                                                // Mark the function as used
                                                                func->is_used = true;

                                                                // Count arguments
                                                                int arg_count = 0;
                                                                Parameter *arg = $3;
                                                                while (arg) { arg_count++; arg = arg->next; }

                                                                // Validate parameter count
                                                                if (arg_count != func->param_count) {
                                                                    yyerror("Argument count mismatch");
                                                                    YYERROR;
                                                                }

                                                                // Reverse argument list to match parameter order
                                                                Parameter *reversed_args = NULL;
                                                                Parameter *current = $3;
                                                                while (current) {
                                                                    printf("\nhii\n");
                                                                   
                                                                    Parameter *next = current->next;
                                                                    current->next = reversed_args;
                                                                    reversed_args = current;
                                                                    current = next;
                                                                }
                                                                

                                                                // Type checking and argument processing
                                                                Parameter *param = func->params;
                                                                Parameter *arg_iter = reversed_args;
                                                                while (param && arg_iter) {
                                                                    // Handle implicit type conversions
                                                                    if (param->value->type == TYPE_INT && arg_iter->value->type == TYPE_FLOAT) {
                                                                        arg_iter->value->type = TYPE_INT;
                                                                        arg_iter->value->data.i = (int)arg_iter->value->data.f;
                                                                    }
                                                                    else if (param->value->type == TYPE_FLOAT && arg_iter->value->type == TYPE_INT) {
                                                                        arg_iter->value->type = TYPE_FLOAT;
                                                                        arg_iter->value->data.f = (float)arg_iter->value->data.i;
                                                                    }
                                                                    else if (param->value->type != arg_iter->value->type) {
                                                                        yyerror("Argument type mismatch");
                                                                        YYERROR;
                                                                    }
                                                                     add_quad("PARAM", arg_iter->value->place, "", param->value->place ? param->name : "");
                                                                    // Copy argument value to parameter
                                                                    switch (param->value->type) {
                                                                        case TYPE_INT:
                                                                            param->value->data.i = arg_iter->value->data.i;
                                                                            break;
                                                                        case TYPE_FLOAT:
                                                                            param->value->data.f = arg_iter->value->data.f;
                                                                            break;
                                                                        case TYPE_STRING:
                                                                            free(param->value->data.s);
                                                                            param->value->data.s = strdup(arg_iter->value->data.s);
                                                                            break;
                                                                        case TYPE_BOOL:
                                                                            param->value->data.b = arg_iter->value->data.b;
                                                                            break;
                                                                    }
                                                                    
                                                                    param = param->next;
                                                                    arg_iter = arg_iter->next;
                                                                }

                                                                // Free arguments (values and nodes)
                                                                while (reversed_args) {
                                                                    Parameter *tmp = reversed_args;
                                                                    reversed_args = reversed_args->next;
                                                                    free_val(tmp->value);
                                                                    free(tmp);
                                                                }
                                                            
                                                                add_quad("JUMP",$1,"",""); 
                                                                // TODO: Here you would normally execute the function body
                                                                // For now, we'll just print that the function was called
                                                                printf("Called function: %s\n", $1);
                                                            } 
    | IDENTIFIER '(' ')' 
                                                            {
                                                                Symbol* func = lookup_symbol(current_scope, $1);
                                                                if (!func || func->sym_type != SYM_FUNCTION) {
                                                                    yyerror("Undefined function");
                                                                    YYERROR;
                                                                }

                                                                // Mark the function as used
                                                                func->is_used = true;

                                                                if (func->param_count != 0) {
                                                                    yyerror("Function expects parameters");
                                                                    YYERROR;
                                                                }

                                                                // TODO: Here you would normally execute the function body
                                                                // For now, we'll just print that the function was called
                                                                printf("Called function: %s\n", $1);
                                                            }
;

argument_list:
    expression        
                                                            {  printf("Called function: %s\n", $1);
                                                                 Parameter *p = malloc(sizeof(Parameter));
                                                                p->name = new_temp(); // Arguments don't have names
                                                                p->value = $1;
                                                                p->next = NULL;
                                                                
                                                                $$ = p;     
                                                            }
  | argument_list ',' expression 
                                                            { 
                                                                Parameter *p = malloc(sizeof(Parameter));
                                                                p->name = new_temp();
                                                                p->value = $3;
                                                                p->next = $1;  // Build list in reverse order
                                                                $$ = p; 
                                                            }
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
                                            if (loop_var_top + 1 < MAX_NESTED_LOOPS && loop_variable_stack[loop_var_top] == NULL) {
                                                loop_var_top++;
                                                loop_variable_stack[loop_var_top] = strdup($1);  // push variable name
                                            }

                                            add_quad("ASSIGN",$3->place,"",$1);
                                            free_val($3);
                                        }
    ;

block_statement:
    '{' 
                                                            {
                                                                // Create new scope
                                                                SymbolTable* new_scope = create_symbol_table(current_scope);
                                                                  current_scope = new_scope;

                                                                // Add parameters to the new scope
                                                                if (current_params) {
                                                                    Parameter *param = current_params;
                                                                    while (param) {
                                                                        val *v = malloc(sizeof(val));
                                                                        v->type = param->value->type;
                                                                        v->place=param->name;
                                                                        //add_quad("ASSIGN",param->value->place,"",v->place);
                                                                        // Copy data based on type
                                                                        switch (v->type) {
                                                                            case TYPE_INT:    v->data.i = param->value->data.i; break;
                                                                            case TYPE_FLOAT:  v->data.f = param->value->data.f; break;
                                                                            case TYPE_STRING: v->data.s = strdup(param->value->data.s); break;
                                                                            case TYPE_BOOL:   v->data.b = param->value->data.b; break;
                                                                        }
                                                                        insert_symbol(current_scope, param->name, v, SYM_VARIABLE, 0, NULL);
                                                                        param = param->next;
                                                                    }
                                                                }

                                                                // Open SYMTAB_FILE and print the symbol table
                                                                // SYMTAB_FILE = fopen("symbols.txt", "a");
                                                                // if (SYMTAB_FILE) {
                                                                //     print_symbol_table(current_scope);
                                                                //     fclose(SYMTAB_FILE);
                                                                // } else {
                                                                //     fprintf(stderr, "Error: Could not open symbols.txt for writing\n");
                                                                // }
                                                            }
    statement_list 
    '}' 
                                                        {
                                                             SYMTAB_FILE = fopen("symbols.txt", "a");
                                                                if (SYMTAB_FILE) {
                                                                    print_symbol_table(current_scope);
                                                                    fclose(SYMTAB_FILE);
                                                                } else {
                                                                    fprintf(stderr, "Error: Could not open symbols.txt for writing\n");
                                                                }
                                                            // Cleanup scope
                                                             // Cleanup scope
                                                             SymbolTable *old_scope = current_scope;
        current_scope = old_scope->parent; // Key fix: restore parent scope
        free_symbol_table(old_scope); }
    ;

statement_list:
    /* empty */
    | statement_list statement
    ;

if_statement:
    IF '(' expression ')' 
                                                            {if ($3->type != TYPE_BOOL) { yyerror("Condition in if statement must be boolean"); YYERROR; }
                                                                $3->falseLabel = new_label();
                                                                add_quad("JMP_FALSE", $3->place, "", $3->falseLabel);
                                                                 }
        block_statement
                                                            {
                                                                add_quad("JMP", "", "", $3->falseLabel);
                                                                add_quad("LABEL", $3->falseLabel, "", "");
                                                                free_val($3);
                                                                
                                                            }
    | IFELSE '(' expression ')' 
    
                                                            { if ($3->type != TYPE_BOOL) { yyerror("Condition in if statement must be boolean"); YYERROR; }
                                                                $3->falseLabel = new_label();
                                                                $3->endLabel   = new_label();
                                                                add_quad("JMP_FALSE", $3->place, "", $3->falseLabel);
}
    block_statement 
                                                            {
                                                                add_quad("JMP", "", "", $3->endLabel);
                                                                add_quad("LABEL", $3->falseLabel, "", "");
                                                               
                                                            }
    block_statement
                                                            {
                                                                add_quad("LABEL", $3->endLabel, "", "");
                                                                free_val($3);

                                                             }
    ;



while_statement:
    WHILE '(' expression ')' 
                                                            {
                                                                if ($3->type != TYPE_BOOL) {
                                                                    yyerror("Condition in while statement must be boolean");
                                                                    YYERROR;
                                                                }

                                                                $3->falseLabel = new_label();  // Loop condition
                                                                $3->endLabel   = new_label();  // Loop exit

                                                                // Push break/continue labels (no loop var needed)
                                                                if (loop_var_top + 1 < MAX_NESTED_LOOPS) {
                                                                    loop_var_top++;
                                                                    break_label_stack[loop_var_top] = $3->endLabel;
                                                                    continue_label_stack[loop_var_top] = $3->falseLabel;
                                                                } else {
                                                                    yyerror("Too many nested loops");
                                                                    YYERROR;
                                                                }

                                                                add_quad("LABEL", $3->falseLabel, "", "");
                                                                add_quad("JMP_FALSE", $3->place, "", $3->endLabel);
                                                            }
    block_statement
                                                            {
                                                                add_quad("JMP", "", "", $3->falseLabel);
                                                                add_quad("LABEL", $3->endLabel, "", "");

                                                                break_label_stack[loop_var_top] = NULL;
                                                                continue_label_stack[loop_var_top] = NULL;
                                                                loop_var_top--;

                                                                free_val($3);
                                                            }
;




do_while_statement:
    DO
                                                            {
                                                                if (loop_var_top + 1 >= MAX_NESTED_LOOPS) {
                                                                    yyerror("Too many nested loops");
                                                                    YYERROR;
                                                                }

                                                                // Reserve a label for the loop start
                                                                do_while_label = new_label();

                                                                // Push break/continue labels for this loop
                                                                loop_var_top++;
                                                                break_label_stack[loop_var_top] = new_label();           // Exit after loop
                                                                continue_label_stack[loop_var_top] = do_while_label;     // Start of loop condition check

                                                                // Emit start label
                                                                add_quad("LABEL", do_while_label, "", "");
                                                            }
    block_statement

    WHILE '(' expression ')'
                                                            {
                                                                if ($6->type != TYPE_BOOL) {
                                                                    yyerror("Condition in do-while statement must be boolean");
                                                                    YYERROR;
                                                                }

                                                                if ($6->data.b)
                                                                    printf("Condition is true\n");
                                                                else
                                                                    printf("Condition is false\n");

                                                                // Jump to start if condition is true
                                                                add_quad("JMP_TRUE", $6->place, "", do_while_label);

                                                                // Emit loop exit label
                                                                add_quad("LABEL", break_label_stack[loop_var_top], "", "");

                                                                // Cleanup
                                                                free_val($6);
                                                                break_label_stack[loop_var_top] = NULL;
                                                                continue_label_stack[loop_var_top] = NULL;
                                                                loop_var_top--;
                                                            }
;




for_statement:
    FOR '(' assignment_statement ';' expression ';' STEP EQUAL atomic ')'
                                                            {
                                                                if ($5->type != TYPE_BOOL) {
                                                                    yyerror("Condition in for statement must be boolean");
                                                                    YYERROR;
                                                                }
                                                                if ($9->type != TYPE_INT) {
                                                                    yyerror("Step value must be int");
                                                                    YYERROR;
                                                                }

                                                                /* CHANGED: reserve three fresh labels */
                                                                char *for_begin_lbl   = new_label();
                                                                char *for_continue_lbl= new_label();
                                                                char *for_exit_lbl    = new_label();

                                                                /* CHANGED: push them onto the stacks */
                                                                if (loop_var_top+1 >= MAX_NESTED_LOOPS) {
                                                                    yyerror("Too many nested loops");
                                                                    YYERROR;
                                                                }
                                                                loop_var_top++;
                                                                loop_variable_stack[loop_var_top]       = strdup(last_symbol_inserted->name);
                                                                break_label_stack[loop_var_top]        = for_exit_lbl;        /* CHANGED */
                                                                continue_label_stack[loop_var_top]     = for_continue_lbl;    /* CHANGED */

                                                                /* CHANGED: emit the loop‐start label before the body */
                                                                add_quad("LABEL", for_begin_lbl, "", "");

                                                                /* Save the parsed pieces to temporaries */
                                                                /* (you already have code here to copy $3, $5, etc. into temps) */

                                                                /* Your existing code will now emit the body quads... */
                                                            }
    block_statement
                                                {
                                                    /* CHANGED: after the body, emit the continue target */
                                                    add_quad("LABEL", for_continue_lbl, "", "");  
                                                    /* CHANGED: evaluate and perform the step (you probably already do this) */
                                                    /* e.g. add_quad("ADD", loop_variable_stack[loop_var_top], stepTemp, loop_variable_stack[loop_var_top]); */
                                                    /* CHANGED: test condition and loop back */
                                                    add_quad("IF_TRUE", cmpTemp, "", for_begin_lbl);
                                                    /* CHANGED: emit the loop‐exit label */
                                                    add_quad("LABEL", for_exit_lbl, "", "");

                                                    /* CHANGED: clean up the stacks */
                                                    free(loop_variable_stack[loop_var_top]);
                                                    loop_variable_stack[loop_var_top]   = NULL;
                                                    free(break_label_stack[loop_var_top]);
                                                    free(continue_label_stack[loop_var_top]);
                                                    break_label_stack[loop_var_top]     = NULL;
                                                    continue_label_stack[loop_var_top]  = NULL;
                                                    loop_var_top--;
                                                }
;





switch_statement:
    SWITCH '(' expression ')' 
                                                            {
                                                                if ($3->type != TYPE_INT && $3->type != TYPE_STRING) {
                                                                    yyerror("Switch expression must be int or string");
                                                                    YYERROR;
                                                                }
                                                                current_switch_type   = $3->type;
                                                                current_switch_place  = strdup($3->place);
                                                                current_switch_endLabel = new_label();
                                                                free_val($3);
                                                            }
  '{'
    case_list
  '}'
                                                            {
                                                                add_quad("LABEL", current_switch_endLabel, "", "");
                                                                free(current_switch_place);
                                                                current_switch_place = NULL;
                                                                current_switch_endLabel = NULL;
                                                            }
  ;

case_list:
    /* no cases */
  | case_list case_statement
  ;

case_statement:
    CASE expression ':' 
                                                            {
                                                                if ($2->type != current_switch_type) {
                                                                    yyerror("Case expression type mismatch");
                                                                    YYERROR;
                                                                }

                                                                /* Compute compare + conditional jump into the case body */
                                                                cmpTemp   = new_temp();
                                                                caseLabel = new_label();
                                                                skipLabel = new_label();

                                                                add_quad("CMP",    current_switch_place, $2->place, cmpTemp);
                                                                add_quad("JMP_TRUE",  cmpTemp, "",  caseLabel);
                                                                add_quad("JMP",   "",    "",   skipLabel);

                                                                /* Mark the start of the case body */
                                                                add_quad("LABEL",     caseLabel,           "",          "");
                                                            }
    block_statement
                                                            {
                                                                /* After body, jump to end-of-switch; then emit skip label */
                                                                add_quad("JMP","", "", current_switch_endLabel);
                                                                add_quad("LABEL",skipLabel, "",  "");

                                                                free_val($2);
                                                            }
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
                                                                    printf("Declaring variable: %s\n", $2);
                                                                    printf("in scope level: %d",current_scope->scope_level);
                                                                    last_symbol_inserted=insert_symbol(current_scope, $2, v,SYM_VARIABLE,0,NULL);
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
                                                                    printf("Declaring variable: %s\n", $2);
                                                                    printf("in scope level: %d",current_scope->scope_level);
                                                                    add_quad("ASSIGN",$4->place,"",$2);

                                                                    last_symbol_inserted=insert_symbol(current_scope, $2, $4,SYM_VARIABLE,0,NULL);
                                                                    print_symbol_table(current_scope);
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
                                                                    last_symbol_inserted=insert_symbol(current_scope, $3, $5, SYM_CONSTANT,0,NULL);
                                                                }

    ;

type_specifier:
    T_INT    { $$ = TYPE_INT; }
  | T_FLOAT  { $$ = TYPE_FLOAT; }
  | T_STRING { $$ = TYPE_STRING; }
  | T_BOOL   { $$ = TYPE_BOOL; }
  | T_VOID   { $$ = TYPE_VOID; }
  ;


return_statement:
  RETURN expression 
                                                            {
                                                                if (!current_function) {
                                                                yyerror("‘return’ not inside any function");
                                                                YYERROR;
                                                                }
                                                                /* mismatch between return-expr type vs. function’s declared type */
                                                                if ($2->type != current_function->value->type) {
                                                                    char msg[128];
                                                                    snprintf(msg, sizeof msg,
                                                                            "Return type mismatch in '%s': expected %s but got %s",
                                                                            current_function->name,
                                                                            type_to_string(current_function->value->type),
                                                                            type_to_string($2->type));
                                                                    yyerror(msg);
                                                                    YYERROR;
                                                               
                                                                }
                                                                free_val($2);  /* if you don’t store it anywhere */
                                                            }
| RETURN 
                                                            {
                                                                if (!current_function) {
                                                                yyerror("‘return’ not inside any function");
                                                                YYERROR;
                                                                }
                                                                /* you don’t have a TYPE_VOID, so disallow bare `return;` */
                                                                if (current_function->value->type != TYPE_VOID) {
                                                                char msg[128];
                                                                snprintf(msg, sizeof msg,
                                                                        "Return type mismatch in '%s': expected %s but got void",
                                                                        current_function->name,
                                                                        type_to_string(current_function->value->type)
                                                                        );
                                                                yyerror(msg);
                                                                YYERROR;   
                                                                }
                                                            }
;


break_statement:
BREAK
    {
        if (loop_var_top < 0 || break_label_stack[loop_var_top] == NULL) {
            yyerror("Break used outside loop");
            YYERROR;
        }
        add_quad("BRK", "", "", break_label_stack[loop_var_top]);
    }
    ;

continue_statement:
    CONTINUE
    {
        if (loop_var_top < 0 || continue_label_stack[loop_var_top] == NULL) {
            yyerror("Continue used outside loop");
            YYERROR;
        }
        add_quad("CONT", "", "", continue_label_stack[loop_var_top]);
    }
;


print_statement:
    PRINT '(' expression ')'                                             


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
                                                                            add_quad("CALL","print","",""); // Call the print function
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
                                                                        // Type checking
                                                                        if (($1->type == TYPE_INT || $1->type == TYPE_FLOAT) && 
                                                                            ($3->type == TYPE_INT || $3->type == TYPE_FLOAT)) {
                                                                            
                                                                            $$ = malloc(sizeof(val));

                                                                            // Constant Folding: If both operands are constants, compute at compile-time
                                                                            if ($1->is_constant && $3->is_constant) {
                                                                                $$->is_constant = true;
                                                                                
                                                                                if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                    // Float result
                                                                                    $$->type = TYPE_FLOAT;
                                                                                    float left = ($1->type == TYPE_FLOAT) ? $1->data.f : (float)$1->data.i;
                                                                                    float right = ($3->type == TYPE_FLOAT) ? $3->data.f : (float)$3->data.i;
                                                                                    $$->data.f = left + right;
                                                                                    
                                                                                    // Store the result as a string (e.g., "5.0")
                                                                                    char result_str[32];
                                                                                    snprintf(result_str, sizeof(result_str), "%f", $$->data.f);
                                                                                    $$->place = strdup(result_str);
                                                                                } else {
                                                                                    // Integer result
                                                                                    $$->type = TYPE_INT;
                                                                                    $$->data.i = $1->data.i + $3->data.i;
                                                                                    
                                                                                    // Store the result as a string (e.g., "5")
                                                                                    char result_str[32];
                                                                                    snprintf(result_str, sizeof(result_str), "%d", $$->data.i);
                                                                                    $$->place = strdup(result_str);
                                                                                }
                                                                            } 
                                                                            // Non-constant: Generate temporaries and ADD quadruple
                                                                            else {
                                                                                $$->is_constant = false;
                                                                                $$->place = new_temp();  // e.g., "t1"

                                                                                // Determine result type (int or float)
                                                                                if ($1->type == TYPE_FLOAT || $3->type == TYPE_FLOAT) {
                                                                                    $$->type = TYPE_FLOAT;
                                                                                } else {
                                                                                    $$->type = TYPE_INT;
                                                                                }

                                                                                // Generate ADD quadruple
                                                                                add_quad("ADD", $1->place, $3->place, $$->place);
                                                                            }
                                                                        } else {
                                                                            yyerror("Cannot add non-numeric types");
                                                                            YYERROR;
                                                                        }

                                                                        // Free child expressions if not needed anymore
                                                                        free_val($1);
                                                                        free_val($3);
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
                                                                                   $$->place=new_temp();
                                                                                   add_quad("SUB", $1->place, $3->place, $$->place);
                                                                               } else {
                                                                                   $$->type = TYPE_INT;
                                                                                   $$->data.i = $1->data.i - $3->data.i;
                                                                                   $$->place=new_temp();
                                                                                     add_quad("SUB", $1->place, $3->place, $$->place);
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
                                                                                 $$->place=new_temp();
                                                                                add_quad("MUL", $1->place, $3->place, $$->place);
                                                                             } else {
                                                                                 $$->type = TYPE_INT;
                                                                                 $$->data.i = $1->data.i * $3->data.i;
                                                                                $$->place=new_temp();
                                                                                add_quad("MUL", $1->place, $3->place, $$->place);
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
                                                                             $$->place=new_temp();
                                                                            add_quad("DIV", $1->place, $3->place, $$->place);
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
                                                                                     $$->place=new_temp();
                                                                                     add_quad("CMP", $1->place, $3->place, $$->place);
                                                                                     break;
                                                                                 case TYPE_FLOAT:
                                                                                     result = ($1->data.f == $3->data.f);
                                                                                     $$->data.b = result;
                                                                                     $$->place=new_temp();
                                                                                    add_quad("CMP", $1->place, $3->place, $$->place);
                                                                                     break;
                                                                                 case TYPE_STRING:
                                                                                     result = (strcmp($1->data.s, $3->data.s) == 0);
                                                                                     $$->data.b = result;
                                                                                         $$->place=new_temp();
                                                                                    add_quad("CMP", $1->place, $3->place, $$->place);
                                                                                     break;
                                                                                 case TYPE_BOOL:
                                                                                     result = ($1->data.b == $3->data.b);
                                                                                     $$->data.b = result;
                                                                                         $$->place=new_temp();
                                                                                    add_quad("CMP", $1->place, $3->place, $$->place);
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
                                                                            // Allocate comparison result
                                                                            val* cmp_res = malloc(sizeof(val));              // [quad]
                                                                            cmp_res->type = TYPE_BOOL;                       // [quad]
                                                                            switch ($1->type) {
                                                                                case TYPE_INT:
                                                                                    $$->data.b = ($1->data.i == $3->data.i);
                                                                                    break;
                                                                                case TYPE_FLOAT:
                                                                                    $$->data.b = ($1->data.f == $3->data.f);
                                                                                    break;
                                                                                case TYPE_STRING:
                                                                                    $$->data.b = (strcmp($1->data.s, $3->data.s) == 0);
                                                                                    break;
                                                                                case TYPE_BOOL:
                                                                                    $$->data.b = ($1->data.b == $3->data.b);
                                                                                    break;
                                                                            }

                                                                            $$->place=new_temp();

                                                                            

                                                                            add_quad("NOT_EQUAL", $1->place, $3->place, $$->place);                // [quad]
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

                                                                              $$->place=new_temp();

                                                                                add_quad("AND", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("OR", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("LESS_THAN",$1->place,$3->place,$$->place);
                                                               
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
                                                                                $$->place=new_temp();
                                                                                add_quad("LESS_EQUAL", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("GREATER", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("GREATER_EQUAL", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("BIT_AND", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("BIT_OR", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("BIT_XOR", $1->place, $3->place, $$->place);
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
                                                                                $$->place =new_temp();

                                                                                add_quad("NOT", $2->place, NULL, $$->place);

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
                                                                                $$->place=new_temp();
                                                                                add_quad("BIT_NOT", $2->place, NULL, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("INCR", $2->place, NULL, $$->place);
                                                                            } else {
                                                                                $$->data.f = ++($2->data.f);
                                                                                $$->place=new_temp();
                                                                                add_quad("INCR", $2->place, NULL, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("INCR", $1->place, NULL, $$->place);
                                                                            } else {
                                                                                $$->data.f = $1->data.f++;
                                                                                add_quad("INCR", $1->place, NULL, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("MOD", $1->place, $3->place, $$->place);
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
                                                                                $$->place=new_temp();
                                                                                add_quad("POWER", $1->place, $3->place, $$->place);
                                                                            } else {
                                                                                $$->type = TYPE_INT;
                                                                                // Simple integer power (won't handle negative exponents well)
                                                                                int result = 1;
                                                                                for (int i = 0; i < $3->data.i; i++) {
                                                                                    result *= $1->data.i;
                                                                                }
                                                                                $$->data.i = result;
                                                                                $$->place=new_temp();
                                                                                add_quad("POWER", $1->place, $3->place, $$->place);
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
                                                                    Symbol* func = lookup_symbol(current_scope, $1);
                                                                    if (!func || func->sym_type != SYM_FUNCTION) {
                                                                        yyerror("Undefined function");
                                                                        YYERROR;
                                                                    }

                                                                    // Count arguments
                                                                    int arg_count = 0;
                                                                    Parameter *arg = $3;
                                                                    while (arg) { arg_count++; arg = arg->next; }

                                                                    // Validate parameter count
                                                                    if (arg_count != func->param_count) {
                                                                        yyerror("Argument count mismatch");
                                                                        YYERROR;
                                                                    }

                                                                    // Reverse argument list to match parameter order
                                                                    Parameter *reversed_args = NULL;
                                                                    Parameter *current = $3;
                                                                    while (current) {
                                                                        Parameter *next = current->next;
                                                                        current->next = reversed_args;
                                                                        reversed_args = current;
                                                                        current = next;
                                                                    }

                                                                    // Type checking
                                                                    Parameter *param = func->params;
                                                                    Parameter *arg_iter = reversed_args;
                                                                    while (param && arg_iter) {
                                                                        if(param->value->type==TYPE_INT && arg_iter->value->type==TYPE_FLOAT){
                                                                            arg_iter->value->type=TYPE_INT;
                                                                            arg_iter->value->data.i=(int)arg_iter->value->data.f;

                                                                        }
                                                                        else if(param->value->type==TYPE_FLOAT && arg_iter->value->type==TYPE_INT){
                                                                            arg_iter->value->type=TYPE_FLOAT;
                                                                            arg_iter->value->data.f=(float)arg_iter->value->data.i;
                                                                        }else if (param->value->type != arg_iter->value->type) {
                                                                            yyerror("Argument type mismatch");
                                                                            YYERROR;
                                                                        }

                                                                        switch (param->value->type) {
                                                                            case TYPE_INT:
                                                                                param->value->data.i = arg_iter->value->data.i;
                                                                                break;
                                                                            case TYPE_FLOAT:
                                                                                param->value->data.f = arg_iter->value->data.f;
                                                                                break;
                                                                            case TYPE_STRING:
                                                                                free(param->value->data.s);
                                                                                param->value->data.s = strdup(arg_iter->value->data.s);
                                                                                break;
                                                                            case TYPE_BOOL:
                                                                                param->value->data.b = arg_iter->value->data.b;
                                                                                break;
                                                                        }

                                                                        param = param->next;
                                                                        arg_iter = arg_iter->next;
                                                                    }

                                                                    // Free arguments (values and nodes)
                                                                    while (reversed_args) {
                                                                        Parameter *tmp = reversed_args;
                                                                        reversed_args = reversed_args->next;
                                                                        free_val(tmp->value);
                                                                        free(tmp);
                                                                    }

                                                                    // Return default value (temporary)
                                                                    //TODO: Implement actual function call
                                                                    $$ = create_default_value(func->value->type);
                                                                }
    | IDENTIFIER '(' ')'                                               
                                                                {
                                                                    Symbol* func = lookup_symbol(current_scope, $1);
                                                                    if (!func || func->sym_type != SYM_FUNCTION) {
                                                                        yyerror("Undefined function");
                                                                        YYERROR;
                                                                    }

                                                                    if (func->param_count != 0) {
                                                                        yyerror("Function expects parameters");
                                                                        YYERROR;
                                                                    }
                                                                    //TODO: Implement actual function call
                                                                    $$ = create_default_value(func->value->type);
                                                                }
    ;
atomic:
    INT
                                                                        {
                                                                            
                                                                            

                                                                            $$ = create_default_value(TYPE_INT);
                                                                            
                                                                            $$->data.i = $1;
                                                                            $$->is_constant = true;
                                                                            $$->place = strdup(yytext);
                                                                        }
    | FLOAT
                                                                        {
                                                                            $$ =create_default_value(TYPE_FLOAT);
                                                                            
                                                                            $$->data.f = $1;
                                                                            $$->is_constant = true;
                                                                            $$->place = strdup(yytext);
                                                                            
                                                                        }
    | STRING
                                                                        {
                                                                            $$ = create_default_value(TYPE_STRING);
                                                                            $$->data.s = strdup($1);
                                                                            $$->is_constant = true;
                                                                            $$->place = strdup(yytext);
                                                                            
                                                                        }
    | BOOL
                                                                        {
                                                                            $$ = create_default_value(TYPE_BOOL);
                                                                            $$->data.b = $1;
                                                                            $$->is_constant = true;
                                                                            $$->place = strdup(yytext);

                                                                            
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
                                                                            else if ($$->type == TYPE_BOOL) {
                                                                                $$->data.b = sym->value->data.b;
                                                                            } else if ($$->type == TYPE_INT) {
                                                                                $$->data.i = sym->value->data.i;
                                                                            } else if ($$->type == TYPE_FLOAT) {
                                                                                $$->data.f = sym->value->data.f;
                                                                            }
                                                                            $$->place = strdup($1);
                                                                            $$->is_constant = false;
                                                                        }
                                                                
                                                                   
                                                                    ;


%%
/* track line numbers in your lexer (lexer.l):
     \n   { ++yylineno; return '\n'; }
*/

void syntaxError(int line, const char *msg, const char *token) {
    fprintf(stderr,
            "Syntax error at line %d: %s near '%s'\n",
            line, msg, token);
    exit(EXIT_FAILURE);
}

void semanticError(int line, const char *msg) {
    fprintf(stderr, "Semantic error at line %d: %s\n", line, msg);
}

void yyerror(const char* msg) {
    extern char *yytext;
    /* Bison will pass “syntax error, unexpected …” for parse errors */
    if (strncmp(msg, "syntax error", 12) == 0) {
        syntaxError(yylineno, msg, yytext);
    } else {
        semanticError(yylineno, msg);
    }
}

val* create_default_value(Type type) {
    val *v = malloc(sizeof(val));
    v->type = type;
    v->is_constant = false; 
    switch (type) {
        case TYPE_INT:    v->data.i = 0; break;
        case TYPE_FLOAT:  v->data.f = 0.0f; break;
        case TYPE_STRING: v->data.s = strdup(""); break;
        case TYPE_BOOL:   v->data.b = 0; break;
    }
    v->place = new_temp();
    return v;
}

const char *type_to_string(Type t) {
  switch(t) {
    case TYPE_INT:    return "int";
    case TYPE_FLOAT:  return "float";
    case TYPE_STRING: return "string";
    case TYPE_BOOL:   return "bool";
    case TYPE_VOID:   return "void";
    default:          return "unknown";
  }
}

static char *new_temp() {
    static char buf[32];
    snprintf(buf, sizeof buf, "t%d", ++_temp_cnt);
    return strdup(buf);
}

static char *new_label() {
  static int _lbl = 0;
  char buf[16];
  snprintf(buf,sizeof buf,"L%d",++_label_cnt);
  return strdup(buf);
}



int main() {
    global_scope = create_symbol_table(NULL);
    parent_scope = global_scope;
    current_scope = global_scope;
    Symbol *last_symbol_inserted=NULL;
    Parameter *parameter_head=NULL ;
    SYMTAB_FILE = fopen("symbols.txt", "w");
    
    
    
    
    int result = yyparse();
    if (SYMTAB_FILE) {
    print_symbol_table(global_scope); 
    fclose(SYMTAB_FILE);
    }

    print_quads();
    // Clean up global scope
    free_symbol_table(global_scope);
    return result;
}

