/* Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>

    #include "parser.tab.h"
%}

/* Regex Rules */
%%
[0-9]+                   {yylval.i = atoi(yytext); return RAKAM;}
[()]                     {return yytext[0];}
-                        {return MINUS;}
+                        {return PLUS;}
*                        {return MULTIPLY;}
/                        {return DIVIDE;}
&&                       {return AND;}
||                       {return OR;}
!                        {return NOT;}
=                        {return EQUAL;}
==                       {return EQUAL_EQUAL;}
!=                       {return NOT_EQUAL;}
"law"                    {return IF;}//if
"aw"                     {return ELSE;}//else
"madam"                  {return WHILE;}//while
"e3mel madam"            {return DO WHILE;}//do while
"le7ad"                  {return FOR;}//for
"ekhtar"                 {return SWITCH;}//switch
"7ala"                   {return CASE;}//case
"thabet"                 {return CONST;}//const
"ekhla3"                 {return BREAK;}//break
"kamel"                  {return CONTINUE;}//continue
"raga3"                  {return RETURN;}//return
"etba3"                  {return PRINT;}//print
"rakam"                  {return INT;}//int
"kasr"                   {return FLOAT;}//float
"7arf"                   {return CHAR;}//char
"kalam"                  {return STRING;}//string
"bool"                   {return BOOL;}//bool






""

[ \t\n]+    { /* Ignore whitespace */ }
%%

/* Subroutines */
int yywrap(void) {
    return 1;
}