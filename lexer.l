/* Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parser.tab.h"
%}

/* Regex Rules */
%%                      
#.*                                             { /* Ignore comments */ }
#[^#]*#                                         { /* Ignore comments */ }
([1-9][0-9]*|0)                                 {yylval.i = atoi(yytext); return INT;}
([1-9][0-9]*|0)\.[0-9]+                         {yylval.f = atof(yytext); return FLOAT; }
"false"                                         { yylval.i = 0; return BOOL; }
"true"                                          { yylval.i = 1; return BOOL; }
\"([^\"]|\\.)*\"                                {
                                                    char *content = strdup(yytext + 1);
                                                    content[strlen(content) - 1] = '\0';//ghayarna " lee \0
                                                    char *decoded = (char *)malloc(strlen(content) + 1);
                                                    int decoded_index = 0;
                                                    for (int i = 0; i < strlen(content); i++) {
                                                        if (content[i] == '\\' && i + 1 < strlen(content)) {
                                                            switch (content[i + 1]) {
                                                                case 'n': decoded[decoded_index++] = '\n'; i++; break;
                                                                case 't': decoded[decoded_index++] = '\t'; i++; break;
                                                                
                                                                case '0': decoded[decoded_index++] = '\0'; i++; break;
                                                                case '\\': decoded[decoded_index++] = '\\'; i++; break;
                                                                case '\"': decoded[decoded_index++] = '\"'; i++; break;
                                                                case '\'': decoded[decoded_index++] = '\''; i++; break; //lel commas 
                                                                default:
                                                                    fprintf(stderr, "Unknown escape sequence: \\%c\n", content[i + 1]);
                                                                    exit(1);
                                                            }
                                                        }
                                                        else {
                                                            decoded[decoded_index++] = content[i];
                                                        }
                                                    }
                                                    decoded[decoded_index] = '\0';
                                                    yylval.s = decoded;
                                                    return STRING;
                                                }
                                                
//brackets
"("                                             { return L_PAREN; }    
")"                                             { return R_PAREN; }
"["                                             { return L_BRACKET; }  
"]"                                             { return R_BRACKET; }

//operators
"-"                                             {return MINUS;}
"+"                                             {return PLUS;}
"*"                                             {return MULTIPLY;}
"/"                                             {return DIVIDE;}
"&&"                                            {return AND;}
"||"                                            {return OR;}
"!"                                             {return NOT;}
"="                                             {return EQUAL;}
"=="                                            {return EQUAL_EQUAL;}
"!="                                            {return NOT_EQUAL;}
"<"                                             { return LESS; }
"<="                                            { return LESS_EQUAL; }
">"                                             { return GREATER; }
">="                                            { return GREATER_EQUAL; }

//bitwise operators
"&"                                             { return BIT_AND; }
"|"                                             { return BIT_OR; }
"^"                                             { return BIT_XOR; }
"~"                                             { return BIT_NOT; }

//other operators
"+="                                            { return PLUS_EQUAL; }
"-="                                            { return MINUS_EQUAL; }
"*="                                            { return TIMES_EQUAL; }
"/="                                            { return DIVIDE_EQUAL; }
"++"                                            { return INCR; }
";"                                             { return SEMI; }
":"                                             { return COLON; }
"."                                             { return DOT; }

//conditions
"law"                                           {return IF;}//if
"aw"                                            {return ELSE;}//else
"madam"                                         {return WHILE;}//while
"e3mel madam"                                   {return DO WHILE;}//do while
"le7ad"                                         {return FOR;}//for
"ekhtar"                                        {return SWITCH;}//switch
"7ala"                                          {return CASE;}//case
"thabet"                                        {return CONST;}//const
"ekhla3"                                        {return BREAK;}//break
"kamel"                                         {return CONTINUE;}//continue
"raga3"                                         {return RETURN;}//return
"etba3"                                         {return PRINT;}//print
"rakam"                                         {return INT;}//int
"kasr"                                          {return FLOAT;}//float
"7arf"                                          {return CHAR;}//char
"kalam"                                         {return STRING;}//string
"bool"                                          {return BOOL;}//bool

[a-zA-Z_][a-zA-Z0-9_]*                          { yylval.s = strdup(yytext); return IDENTIFIER; }
[ \t\n]+                                        { /* Ignore whitespace */ }
%%

/* Subroutines */
int yywrap(void) {
    return 1;
}