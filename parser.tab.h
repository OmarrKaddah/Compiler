/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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
     INT_TYPE = 298,
     FLOAT_TYPE = 299,
     STRING_TYPE = 300,
     BOOL_TYPE = 301
   };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define STRING 260
#define IDENTIFIER 261
#define BOOL 262
#define MINUS 263
#define PLUS 264
#define MULTIPLY 265
#define DIVIDE 266
#define AND 267
#define OR 268
#define NOT 269
#define EQUAL 270
#define EQUAL_EQUAL 271
#define NOT_EQUAL 272
#define LESS 273
#define LESS_EQUAL 274
#define GREATER 275
#define GREATER_EQUAL 276
#define BIT_AND 277
#define BIT_OR 278
#define BIT_XOR 279
#define BIT_NOT 280
#define PLUS_EQUAL 281
#define MINUS_EQUAL 282
#define TIMES_EQUAL 283
#define DIVIDE_EQUAL 284
#define INCR 285
#define IF 286
#define ELSE 287
#define WHILE 288
#define DO 289
#define FOR 290
#define SWITCH 291
#define CASE 292
#define CONST 293
#define BREAK 294
#define CONTINUE 295
#define RETURN 296
#define PRINT 297
#define INT_TYPE 298
#define FLOAT_TYPE 299
#define STRING_TYPE 300
#define BOOL_TYPE 301




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 10 "parser.y"
{
    int i;
    float f;
    char* s;
    int b; 
    val *v;
 
}
/* Line 1529 of yacc.c.  */
#line 150 "parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

