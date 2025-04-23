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
&&                      {return AND;}
||                      {return OR;}
!                        {return NOT;}
=                        {return EQUAL;}
==                       {return EQUAL_EQUAL;}
!=                       {return NOT_EQUAL;}
"law"                     {return LAW;}//if
"aw"                   {return AW;}//else
"madam"                  {return MADAM;}//while
"e3mel madam"            {return E3MEL_MADAM;}//do while
"le7ad"                    {return LE7AD;}//for
"ekhtar"                 {return EKHTAR;}//switch
"7ala"                   {return 7ALA;}//case
"thabet"               {return THABET;}//const
"ekhla3"                  {return EKHLA3;}//break
"kamel"                  {return KAMEL;}//continue
"raga3"                  {return RAGA3;}//return
"etba3"                  {return ETBA3;}//print
"rakam"                  {return RAKAM;}//int
"kasr"                  {return FLOAT;}//float
"7arf"                   {return 7arf;}//char
"kalam"                 {return KALAM;}//string
"bool"                   {return BOOL;}//bool






""

[ \t\n]+    { /* Ignore whitespace */ }
%%

/* Subroutines */
int yywrap(void) {
    return 1;
}