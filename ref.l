/* Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "ref.tab.h"
%}

/* Regex Rules */
%%
[0-9]+      {yylval.i = atoi(yytext); return INTEGER;}
[+/*()]     {return yytext[0];}
-           {return MINUS;}
[ \t\n]+    { /* Ignore whitespace */ }
%%

/* Subroutines */
int yywrap(void) {
    return 1;
}