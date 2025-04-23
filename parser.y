/* Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char* s);
    int yylex(void);
    extern FILE* yyin;
%}

%union {
    int i;
}
%token MINUS
%token <i> INTEGER
%type <i> S E T F

/* Production Rules */
%%
S : E           { printf("Result: %d\n", $1); }
  ;

E : E '+' T     {$$ = $1 + $3; }
  | E MINUS T   {$$ = $1 - $3; }
  | T           {$$ = $1; }
  ;

T : T '*' F     {$$ = $1 * $3; }
  | T '/' F     {if ($3 == 0) { yyerror("Division by zero!"); } else { $$ = $1 / $3; }}
  | F           {$$ = $1; }
  ;

F : '(' E ')'   {$$ = $2; }
  | MINUS F     {$$ = -$2; }
  | INTEGER     {$$ = $1; }
%%

/* Subroutines */
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
    exit(1);
}

int main(int argc, char** argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error opening file: %s\n", argv[1]);
            return 1;
        }
    } else {
        yyin = stdin;
    }

    yyparse();
    fclose(yyin);
    return 0;
}