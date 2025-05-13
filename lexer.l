%option yylineno
/* Definitions */
%{
    #include "val.h"
    #include "parser.tab.h"

   
    #include "symbol_table.h"
%}

/* Regex Rules */
%%                      
#.*                                             { /* Ignore comments */ }
#[^#]*#                                         { /* Ignore comments */ }
([1-9][0-9]*|0)                                 { yylval.i = atoi(yytext); return INT; }
([1-9][0-9]*|0)\.[0-9]+                         { yylval.f = atof(yytext); return FLOAT; }
"false"                                         { yylval.i = 0; return BOOL; }
"true"                                          { yylval.i = 1; return BOOL; }
\"([^\\\"]|\\.)*\"                              { // Fixed regex for strings
    char *content = strdup(yytext + 1);
    content[strlen(content) - 1] = '\0';
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
                case '\'': decoded[decoded_index++] = '\''; i++; break;
                default:
                    fprintf(stderr, "Unknown escape sequence: \\%c\n", content[i + 1]);
                    exit(1);
            }
        } else {
            decoded[decoded_index++] = content[i];
        }
    }
    decoded[decoded_index] = '\0';
    yylval.s = decoded;
    return STRING;
}

"rakam"                                         { return T_INT; }
"kasr"                                          { return T_FLOAT; }
"kalam"                                         { return T_STRING; }
"bool"                                          { return T_BOOL; }
"faragh"                                        { return T_VOID; }
                                                

"("                                             { return '('; }    
")"                                             { return ')'; }
"["                                             { return '['; }  
"]"                                             { return ']'; }
"{"                                             { return '{'; }    
"}"                                             { return '}'; }

"ba2y"                                          { return MOD; }//remainder
"**"                                            { return POWER; }
"-"                                             { return MINUS; }
"+"                                             { return PLUS; }
"*"                                             { return MULTIPLY; }
"/"                                             { return DIVIDE; }
"&&"                                            { return AND; }
"||"                                            { return OR; }
"!"                                             { return NOT; }
"="                                             { return EQUAL; }
"=="                                            { return EQUAL_EQUAL; }
"!="                                            { return NOT_EQUAL; }
"<"                                             { return LESS; }
"<="                                            { return LESS_EQUAL; }
">"                                             { return GREATER; }
">="                                            { return GREATER_EQUAL; }


"&"                                             { return BIT_AND; }
"|"                                             { return BIT_OR; }
"^"                                             { return BIT_XOR; }
"~"                                             { return BIT_NOT; }


"+="                                            { return PLUS_EQUAL; }
"-="                                            { return MINUS_EQUAL; }
"*="                                            { return TIMES_EQUAL; }
"/="                                            { return DIVIDE_EQUAL; }
"++"                                            { return INCR; }
";"                                             { return ';'; }
":"                                             { return ':'; }
"."                                             { return '.'; }
","                                             { return ','; }


"law"                                           { return IF; } // if
"aw"                                            { return ELSE; } // else
"madam"                                         { return WHILE; } // while
"e3mel"                                         { return DO; } // Fixed multi-word keyword
"le7ad"                                         { return FOR; } // for
"khatwa"                                        { return STEP; } // STEP
"ekhtar"                                        { return SWITCH; } // switch
"7ala"                                          { return CASE; } // case
"thabet"                                        { return CONST; } // const
"ekhla3"                                        { return BREAK; } // break
"kamel"                                         { return CONTINUE; } // continue
"raga3"                                         { return RETURN; } // return
"etba3"                                         { return PRINT; } // print

[a-zA-Z_][a-zA-Z0-9_]*                          { yylval.s = strdup(yytext); return IDENTIFIER; }
[ \t]+                                          { /* Ignore whitespace */ }

.                                               { 
    fprintf(stderr, "Unrecognized token: %s\n", yytext); 
    exit(1); 
}
%% // Add this to separate rules from subroutines

/* Subroutines */
int yywrap(void) {
    return 1;
}