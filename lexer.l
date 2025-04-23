/* Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "parser.tab.h"
%}

/* Regex Rules */
%%
[0-9]+      {yylval.i = atoi(yytext); return RAKAM;}
[+/*()]     {return yytext[0];}
-           {return SALEB;}
[=]         {return EQUAL;}
[<>=]       {return yytext[0];}
[!]+        {return NOT;}
[&]+        {return AND;}
[|]+        {return OR;}
[;]         {return SEMICOLON;}
[.]+        {return DOT;}
[?]+        {return QUESTION;}
[0-9]+[.][0-9]+ {yylval.f = atof(yytext); return RAKAM;}
[0-9]+[eE][+-]?[0-9]+ {yylval.f = atof(yytext); return RAKAM;}
[0-9]+[eE][+-]?[0-9]+[.][0-9]+ {yylval.f = atof(yytext); return RAKAM;}


[ \t\n]+    { /* Ignore whitespace */ }
%%

/* Subroutines */
int yywrap(void) {
    return 1;
}