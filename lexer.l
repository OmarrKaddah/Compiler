/* Definitions */
%{
    #include "val.h"
    #include "parser.tab.h"
%}

/* Regex Rules */
%%                      
#.*                                             { /* Ignore comments */ }
#[^#]*#                                         { /* Ignore comments */ }
([1-9][0-9]*|0)                                 { yylval.i = atoi(yytext); return INT; }
([1-9][0-9]*|0)\.[0-9]+                         {
    yylval.v = malloc(sizeof(val));
    yylval.v->type = TYPE_FLOAT;
    yylval.v->data.f = atof(yytext);
    return FLOAT;
}
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

"rakam"                                         { return INT_TYPE; }
"kasr"                                          { return FLOAT_TYPE; }
"kalam"                                         { return STRING_TYPE; }
"bool"                                          { return BOOL_TYPE; }
                                                

"("                                             { return '('; }    
")"                                             { return ')'; }
"["                                             { return '['; }  
"]"                                             { return ']'; }
"{"                                             { return '{'; }    
"}"                                             { return '}'; }


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


"law"                                           { return IF; } // if
"aw"                                            { return ELSE; } // else
"madam"                                         { return WHILE; } // while
"e3mel"                                         { return DO; } // Fixed multi-word keyword
"le7ad"                                         { return FOR; } // for
"ekhtar"                                        { return SWITCH; } // switch
"7ala"                                          { return CASE; } // case
"thabet"                                        { return CONST; } // const
"ekhla3"                                        { return BREAK; } // break
"kamel"                                         { return CONTINUE; } // continue
"raga3"                                         { return RETURN; } // return
"etba3"                                         { return PRINT; } // print

[a-zA-Z_][a-zA-Z0-9_]*                          { yylval.s = strdup(yytext); return IDENTIFIER; }
[ \t\n]+                                        { /* Ignore whitespace */ }
.                                               { 
    fprintf(stderr, "Unrecognized token: %s\n", yytext); 
    exit(1); 
}
%% // Add this to separate rules from subroutines

/* Subroutines */
int yywrap(void) {
    return 1;
}