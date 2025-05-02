
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     FLOAT = 259,
     STRING = 260,
     IDENTIFIER = 261,
     BOOL = 262,
     MINUS = 263,
     PLUS = 264,
     MULTIPLY = 265,
     DIVIDE = 266,
     AND = 267,
     OR = 268,
     NOT = 269,
     EQUAL = 270,
     EQUAL_EQUAL = 271,
     NOT_EQUAL = 272,
     LESS = 273,
     LESS_EQUAL = 274,
     GREATER = 275,
     GREATER_EQUAL = 276,
     BIT_AND = 277,
     BIT_OR = 278,
     BIT_XOR = 279,
     BIT_NOT = 280,
     PLUS_EQUAL = 281,
     MINUS_EQUAL = 282,
     TIMES_EQUAL = 283,
     DIVIDE_EQUAL = 284,
     INCR = 285,
     IF = 286,
     ELSE = 287,
     WHILE = 288,
     DO = 289,
     FOR = 290,
     SWITCH = 291,
     CASE = 292,
     CONST = 293,
     BREAK = 294,
     CONTINUE = 295,
     RETURN = 296,
     PRINT = 297,
     STEP = 298,
     INT_TYPE = 299,
     FLOAT_TYPE = 300,
     STRING_TYPE = 301,
     BOOL_TYPE = 302
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 17 "parser.y"

    int i;
    float f;
    char* s;
    int b; 
    val *v;



/* Line 1676 of yacc.c  */
#line 109 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


