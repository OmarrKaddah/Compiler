
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 5 "parser.y"

    #include "val.h"
    #include <string.h>
    #include <stdlib.h>
    #include <stdio.h> 
    #include "symbol_table.h"



    SymbolTable* current_scope = NULL;
    SymbolTable* global_scope = NULL;
    Parameter *current_params = NULL; // Global tracker for parameters
    Symbol *last_symbol_inserted=NULL;

    void print_val(val *v);
    void free_val(val *v);

    extern int yylex();
    void yyerror(const char* s);
    int yyparse();


/* Line 189 of yacc.c  */
#line 96 "parser.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


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
     MOD = 267,
     POWER = 268,
     AND = 269,
     OR = 270,
     NOT = 271,
     EQUAL = 272,
     EQUAL_EQUAL = 273,
     NOT_EQUAL = 274,
     LESS = 275,
     LESS_EQUAL = 276,
     GREATER = 277,
     GREATER_EQUAL = 278,
     BIT_AND = 279,
     BIT_OR = 280,
     BIT_XOR = 281,
     BIT_NOT = 282,
     PLUS_EQUAL = 283,
     MINUS_EQUAL = 284,
     TIMES_EQUAL = 285,
     DIVIDE_EQUAL = 286,
     INCR = 287,
     IF = 288,
     ELSE = 289,
     WHILE = 290,
     DO = 291,
     FOR = 292,
     SWITCH = 293,
     CASE = 294,
     CONST = 295,
     BREAK = 296,
     CONTINUE = 297,
     RETURN = 298,
     PRINT = 299,
     STEP = 300,
     T_INT = 301,
     T_FLOAT = 302,
     T_STRING = 303,
     T_BOOL = 304
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 28 "parser.y"

    int i;
    float f;
    char* s;
    int b; 
    val *v;
    Parameter *p;



/* Line 214 of yacc.c  */
#line 192 "parser.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 204 "parser.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  2
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   704

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  58
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  30
/* YYNRULES -- Number of rules.  */
#define YYNRULES  86
/* YYNRULES -- Number of states.  */
#define YYNSTATES  186

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   304

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      51,    52,     2,     2,    53,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    57,    50,
       2,    56,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    54,     2,    55,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     7,    10,    13,    16,    18,    20,
      22,    24,    26,    28,    30,    32,    34,    36,    39,    40,
      48,    49,    56,    59,    61,    65,    70,    74,    76,    80,
      84,    85,    90,    91,    94,   100,   108,   114,   122,   134,
     146,   154,   155,   158,   164,   167,   172,   178,   180,   182,
     184,   186,   189,   193,   196,   199,   205,   207,   209,   213,
     217,   221,   225,   229,   233,   237,   241,   245,   249,   253,
     257,   261,   265,   269,   272,   275,   278,   281,   285,   289,
     293,   298,   302,   304,   306,   308,   310
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      59,     0,    -1,    -1,    59,    60,    -1,    59,    61,    -1,
      68,    50,    -1,    79,    50,    -1,    72,    -1,    73,    -1,
      74,    -1,    75,    -1,    76,    -1,    81,    -1,    82,    -1,
      83,    -1,    84,    -1,    69,    -1,    66,    50,    -1,    -1,
      80,     6,    51,    65,    52,    62,    69,    -1,    -1,    80,
       6,    51,    52,    63,    69,    -1,    80,     6,    -1,    64,
      -1,    65,    53,    64,    -1,     6,    51,    67,    52,    -1,
       6,    51,    52,    -1,    85,    -1,    67,    53,    85,    -1,
       6,    17,    85,    -1,    -1,    54,    70,    71,    55,    -1,
      -1,    71,    60,    -1,    33,    51,    85,    52,    69,    -1,
      33,    51,    85,    52,    69,    34,    69,    -1,    35,    51,
      85,    52,    69,    -1,    36,    69,    35,    51,    85,    52,
      50,    -1,    37,    51,    68,    50,    85,    50,    45,    56,
      87,    52,    69,    -1,    37,    51,    79,    50,    85,    50,
      45,    56,    87,    52,    69,    -1,    38,    51,    85,    52,
      54,    77,    55,    -1,    -1,    77,    78,    -1,    39,    85,
      57,    60,    50,    -1,    80,     6,    -1,    80,     6,    17,
      85,    -1,    40,    80,     6,    17,    85,    -1,    46,    -1,
      47,    -1,    48,    -1,    49,    -1,    43,    50,    -1,    43,
      85,    50,    -1,    41,    50,    -1,    42,    50,    -1,    44,
      51,    85,    52,    50,    -1,    87,    -1,    86,    -1,    85,
       9,    85,    -1,    85,     8,    85,    -1,    85,    10,    85,
      -1,    85,    11,    85,    -1,    85,    18,    85,    -1,    85,
      19,    85,    -1,    85,    14,    85,    -1,    85,    15,    85,
      -1,    85,    20,    85,    -1,    85,    21,    85,    -1,    85,
      22,    85,    -1,    85,    23,    85,    -1,    85,    24,    85,
      -1,    85,    25,    85,    -1,    85,    26,    85,    -1,    16,
      85,    -1,    27,    85,    -1,    32,    85,    -1,    85,    32,
      -1,    85,    12,    85,    -1,    85,    13,    85,    -1,    51,
      85,    52,    -1,     6,    51,    67,    52,    -1,     6,    51,
      52,    -1,     3,    -1,     4,    -1,     5,    -1,     7,    -1,
       6,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    75,    75,    77,    78,    82,    83,    84,    85,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    99,    98,
     115,   115,   126,   141,   142,   145,   149,   157,   158,   161,
     198,   197,   231,   233,   237,   238,   242,   246,   250,   251,
     255,   258,   260,   264,   268,   286,   301,   317,   318,   319,
     320,   325,   326,   330,   334,   338,   364,   365,   368,   386,
     404,   422,   438,   491,   520,   533,   546,   562,   578,   594,
     610,   623,   636,   649,   662,   675,   689,   703,   718,   744,
     750,   761,   780,   786,   792,   798,   804
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INT", "FLOAT", "STRING", "IDENTIFIER",
  "BOOL", "MINUS", "PLUS", "MULTIPLY", "DIVIDE", "MOD", "POWER", "AND",
  "OR", "NOT", "EQUAL", "EQUAL_EQUAL", "NOT_EQUAL", "LESS", "LESS_EQUAL",
  "GREATER", "GREATER_EQUAL", "BIT_AND", "BIT_OR", "BIT_XOR", "BIT_NOT",
  "PLUS_EQUAL", "MINUS_EQUAL", "TIMES_EQUAL", "DIVIDE_EQUAL", "INCR", "IF",
  "ELSE", "WHILE", "DO", "FOR", "SWITCH", "CASE", "CONST", "BREAK",
  "CONTINUE", "RETURN", "PRINT", "STEP", "T_INT", "T_FLOAT", "T_STRING",
  "T_BOOL", "';'", "'('", "')'", "','", "'{'", "'}'", "'='", "':'",
  "$accept", "program", "statement", "function_definition", "$@1", "$@2",
  "parameter_declaration", "parameter_list", "function_call_statement",
  "argument_list", "assignment_statement", "block_statement", "$@3",
  "statement_list", "if_statement", "while_statement",
  "do_while_statement", "for_statement", "switch_statement", "case_list",
  "case_statement", "declaration", "type_specifier", "return_statement",
  "break_statement", "continue_statement", "print_statement", "expression",
  "function_call", "atomic", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
      59,    40,    41,    44,   123,   125,    61,    58
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    58,    59,    59,    59,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    60,    60,    62,    61,
      63,    61,    64,    65,    65,    66,    66,    67,    67,    68,
      70,    69,    71,    71,    72,    72,    73,    74,    75,    75,
      76,    77,    77,    78,    79,    79,    79,    80,    80,    80,
      80,    81,    81,    82,    83,    84,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      86,    86,    87,    87,    87,    87,    87
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     2,     2,     2,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     2,     0,     7,
       0,     6,     2,     1,     3,     4,     3,     1,     3,     3,
       0,     4,     0,     2,     5,     7,     5,     7,    11,    11,
       7,     0,     2,     5,     2,     4,     5,     1,     1,     1,
       1,     2,     3,     2,     2,     5,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     2,     2,     2,     2,     3,     3,     3,
       4,     3,     1,     1,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       2,     0,     1,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    47,    48,    49,    50,    30,     3,
       4,     0,     0,    16,     7,     8,     9,    10,    11,     0,
       0,    12,    13,    14,    15,     0,     0,     0,     0,     0,
       0,     0,     0,    53,    54,    82,    83,    84,    86,    85,
       0,     0,     0,    51,     0,     0,    57,    56,     0,    32,
      17,     5,     6,    44,    29,    26,     0,    27,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    73,    74,
      75,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    76,
      52,     0,     0,     0,     0,    25,     0,     0,     0,     0,
       0,     0,    44,     0,     0,    81,     0,    79,    59,    58,
      60,    61,    77,    78,    64,    65,    62,    63,    66,    67,
      68,    69,    70,    71,    72,     0,    31,    33,    45,    20,
      23,     0,     0,    28,    34,    36,     0,     0,     0,    41,
      46,    80,    55,     0,    18,     0,    22,     0,     0,     0,
       0,     0,    21,     0,    24,    35,    37,     0,     0,     0,
      40,    42,    19,     0,     0,     0,    86,     0,     0,     0,
       0,     0,     0,    38,    39,    43
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,    19,    20,   163,   153,   140,   141,    21,    66,
      22,    23,    59,   102,    24,    25,    26,    27,    28,   161,
     171,    29,    74,    31,    32,    33,    34,    67,    56,    57
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -92
static const yytype_int16 yypact[] =
{
     -92,    13,   -92,   -14,   -33,   -26,   -25,    -9,     7,    17,
       2,    20,   236,    42,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,    44,    46,   -92,   -92,   -92,   -92,   -92,   -92,    47,
     108,   -92,   -92,   -92,   -92,   272,   161,   272,   272,    69,
      85,   272,   109,   -92,   -92,   -92,   -92,   -92,    75,   -92,
     272,   272,   272,   -92,   272,   456,   -92,   -92,   272,   -92,
     -92,   -92,   -92,   -13,   555,   -92,   -30,   555,   306,   331,
      76,   111,    79,    91,   136,   356,   126,   198,    -1,    -1,
     112,   381,   272,   272,   272,   272,   272,   272,   272,   272,
     272,   272,   272,   272,   272,   272,   272,   272,   272,   -92,
     -92,   406,   143,   272,   -32,   -92,   272,   -25,   -25,   272,
     272,   272,   128,    92,   272,   -92,    -8,   -92,    -4,    -4,
      -1,    -1,    -1,    -1,   605,   580,   225,   225,   127,   127,
     127,   127,   672,   630,   655,   100,   -92,   -92,   555,   -92,
     -92,    16,   142,   555,   118,   -92,   431,   489,   522,   -92,
     555,   -92,   -92,   -25,   -92,    17,   -92,   -25,   103,   115,
     116,   -34,   -92,   -25,   -92,   -92,   -92,   106,   107,   272,
     -92,   -92,   -92,    29,    29,    98,   -92,   102,   117,   218,
     -25,   -25,   120,   -92,   -92,   -92
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -92,   -92,   -91,   -92,   -92,   -92,    18,   -92,   -92,    94,
     132,    -6,   -92,   -92,   -92,   -92,   -92,   -92,   -92,   -92,
     -92,   154,     1,   -92,   -92,   -92,   -92,   -11,   -92,   -84
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      39,    55,    30,    35,   103,   169,    84,    85,    86,    87,
      42,   137,    87,     2,    14,    15,    16,    17,    37,     3,
     139,   170,   105,   106,    64,    38,    68,    69,    99,    18,
      75,    99,    45,    46,    47,   176,    49,    36,   104,    78,
      79,    80,    40,    81,   151,   106,     4,   101,     5,     6,
       7,     8,    43,     9,    10,    11,    12,    13,    41,    14,
      15,    16,    17,    14,    15,    16,    17,    18,   154,   155,
      44,   118,   119,   120,   121,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,   134,   182,   177,
     178,    71,   138,    58,    60,   143,    61,    62,   146,   147,
     148,   144,   145,   150,    70,   142,    82,    83,    84,    85,
      86,    87,    88,    89,    63,    76,    90,    91,    92,    93,
      94,    95,    96,    97,    98,     9,    77,   109,    35,   110,
      99,    14,    15,    16,    17,    82,    83,    84,    85,    86,
      87,   111,   112,   114,    99,   103,   149,   162,   156,     3,
     152,   165,   157,   166,   180,   179,   142,   172,   175,    99,
     167,   168,   173,   174,    45,    46,    47,    48,    49,   181,
     185,   116,    72,   164,   183,   184,     4,    50,     5,     6,
       7,     8,     0,     9,    10,    11,    12,    13,    51,    14,
      15,    16,    17,    52,    73,     0,     0,    18,   136,     0,
       0,    45,    46,    47,    48,    49,     0,     0,     0,     0,
       0,     0,    54,    65,    50,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     3,    51,     0,     0,     0,     0,
      52,     0,     0,    82,    83,    84,    85,    86,    87,    45,
      46,    47,    48,    49,     0,    92,    93,    94,    95,    54,
     115,     4,    50,     5,     6,     7,     8,    99,     9,    10,
      11,    12,    13,    51,    14,    15,    16,    17,    52,     0,
       0,     0,    18,     0,     0,    45,    46,    47,    48,    49,
       0,     0,     0,     0,     0,     0,    53,    54,    50,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    51,
       0,     0,     0,     0,    52,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    82,    83,    84,    85,    86,    87,
      88,    89,     0,    54,    90,    91,    92,    93,    94,    95,
      96,    97,    98,     0,     0,     0,     0,     0,    99,    82,
      83,    84,    85,    86,    87,    88,    89,     0,     0,    90,
      91,    92,    93,    94,    95,    96,    97,    98,   107,     0,
       0,     0,     0,    99,    82,    83,    84,    85,    86,    87,
      88,    89,     0,     0,    90,    91,    92,    93,    94,    95,
      96,    97,    98,   108,     0,     0,     0,     0,    99,    82,
      83,    84,    85,    86,    87,    88,    89,     0,     0,    90,
      91,    92,    93,    94,    95,    96,    97,    98,   113,     0,
       0,     0,     0,    99,    82,    83,    84,    85,    86,    87,
      88,    89,     0,     0,    90,    91,    92,    93,    94,    95,
      96,    97,    98,   117,     0,     0,     0,     0,    99,    82,
      83,    84,    85,    86,    87,    88,    89,     0,     0,    90,
      91,    92,    93,    94,    95,    96,    97,    98,   135,     0,
       0,     0,     0,    99,    82,    83,    84,    85,    86,    87,
      88,    89,     0,     0,    90,    91,    92,    93,    94,    95,
      96,    97,    98,   158,     0,     0,     0,     0,    99,     0,
       0,     0,     0,     0,     0,     0,     0,    82,    83,    84,
      85,    86,    87,    88,    89,     0,   100,    90,    91,    92,
      93,    94,    95,    96,    97,    98,     0,     0,     0,     0,
       0,    99,     0,     0,     0,     0,     0,     0,     0,     0,
      82,    83,    84,    85,    86,    87,    88,    89,     0,   159,
      90,    91,    92,    93,    94,    95,    96,    97,    98,     0,
       0,     0,     0,     0,    99,     0,     0,     0,     0,     0,
       0,     0,     0,    82,    83,    84,    85,    86,    87,    88,
      89,     0,   160,    90,    91,    92,    93,    94,    95,    96,
      97,    98,     0,     0,     0,     0,     0,    99,    82,    83,
      84,    85,    86,    87,    88,     0,     0,     0,    90,    91,
      92,    93,    94,    95,    96,    97,    98,     0,     0,     0,
       0,     0,    99,    82,    83,    84,    85,    86,    87,     0,
       0,     0,     0,    90,    91,    92,    93,    94,    95,    96,
      97,    98,     0,     0,     0,     0,     0,    99,    82,    83,
      84,    85,    86,    87,     0,     0,     0,     0,    90,    91,
      92,    93,    94,    95,    96,     0,    98,     0,     0,     0,
       0,     0,    99,    82,    83,    84,    85,    86,    87,     0,
       0,     0,     0,    90,    91,    92,    93,    94,    95,    96,
      82,    83,    84,    85,    86,    87,     0,    99,     0,     0,
      90,    91,    92,    93,    94,    95,     0,     0,     0,     0,
       0,     0,     0,     0,    99
};

static const yytype_int16 yycheck[] =
{
       6,    12,     1,    17,    17,    39,    10,    11,    12,    13,
       9,   102,    13,     0,    46,    47,    48,    49,    51,     6,
      52,    55,    52,    53,    35,    51,    37,    38,    32,    54,
      41,    32,     3,     4,     5,     6,     7,    51,    51,    50,
      51,    52,    51,    54,    52,    53,    33,    58,    35,    36,
      37,    38,    50,    40,    41,    42,    43,    44,    51,    46,
      47,    48,    49,    46,    47,    48,    49,    54,    52,    53,
      50,    82,    83,    84,    85,    86,    87,    88,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,   179,   173,
     174,     6,   103,    51,    50,   106,    50,    50,   109,   110,
     111,   107,   108,   114,    35,   104,     8,     9,    10,    11,
      12,    13,    14,    15,     6,     6,    18,    19,    20,    21,
      22,    23,    24,    25,    26,    40,    51,    51,    17,    50,
      32,    46,    47,    48,    49,     8,     9,    10,    11,    12,
      13,    50,     6,    17,    32,    17,    54,   153,     6,     6,
      50,   157,    34,    50,    52,    57,   155,   163,   169,    32,
      45,    45,    56,    56,     3,     4,     5,     6,     7,    52,
      50,    77,    40,   155,   180,   181,    33,    16,    35,    36,
      37,    38,    -1,    40,    41,    42,    43,    44,    27,    46,
      47,    48,    49,    32,    40,    -1,    -1,    54,    55,    -1,
      -1,     3,     4,     5,     6,     7,    -1,    -1,    -1,    -1,
      -1,    -1,    51,    52,    16,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     6,    27,    -1,    -1,    -1,    -1,
      32,    -1,    -1,     8,     9,    10,    11,    12,    13,     3,
       4,     5,     6,     7,    -1,    20,    21,    22,    23,    51,
      52,    33,    16,    35,    36,    37,    38,    32,    40,    41,
      42,    43,    44,    27,    46,    47,    48,    49,    32,    -1,
      -1,    -1,    54,    -1,    -1,     3,     4,     5,     6,     7,
      -1,    -1,    -1,    -1,    -1,    -1,    50,    51,    16,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    27,
      -1,    -1,    -1,    -1,    32,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     8,     9,    10,    11,    12,    13,
      14,    15,    -1,    51,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    -1,    -1,    -1,    -1,    -1,    32,     8,
       9,    10,    11,    12,    13,    14,    15,    -1,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    52,    -1,
      -1,    -1,    -1,    32,     8,     9,    10,    11,    12,    13,
      14,    15,    -1,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    52,    -1,    -1,    -1,    -1,    32,     8,
       9,    10,    11,    12,    13,    14,    15,    -1,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    52,    -1,
      -1,    -1,    -1,    32,     8,     9,    10,    11,    12,    13,
      14,    15,    -1,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    52,    -1,    -1,    -1,    -1,    32,     8,
       9,    10,    11,    12,    13,    14,    15,    -1,    -1,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    52,    -1,
      -1,    -1,    -1,    32,     8,     9,    10,    11,    12,    13,
      14,    15,    -1,    -1,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    52,    -1,    -1,    -1,    -1,    32,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     8,     9,    10,
      11,    12,    13,    14,    15,    -1,    50,    18,    19,    20,
      21,    22,    23,    24,    25,    26,    -1,    -1,    -1,    -1,
      -1,    32,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
       8,     9,    10,    11,    12,    13,    14,    15,    -1,    50,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    -1,
      -1,    -1,    -1,    -1,    32,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,     8,     9,    10,    11,    12,    13,    14,
      15,    -1,    50,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    -1,    -1,    -1,    -1,    -1,    32,     8,     9,
      10,    11,    12,    13,    14,    -1,    -1,    -1,    18,    19,
      20,    21,    22,    23,    24,    25,    26,    -1,    -1,    -1,
      -1,    -1,    32,     8,     9,    10,    11,    12,    13,    -1,
      -1,    -1,    -1,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    -1,    -1,    -1,    -1,    -1,    32,     8,     9,
      10,    11,    12,    13,    -1,    -1,    -1,    -1,    18,    19,
      20,    21,    22,    23,    24,    -1,    26,    -1,    -1,    -1,
      -1,    -1,    32,     8,     9,    10,    11,    12,    13,    -1,
      -1,    -1,    -1,    18,    19,    20,    21,    22,    23,    24,
       8,     9,    10,    11,    12,    13,    -1,    32,    -1,    -1,
      18,    19,    20,    21,    22,    23,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    32
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    59,     0,     6,    33,    35,    36,    37,    38,    40,
      41,    42,    43,    44,    46,    47,    48,    49,    54,    60,
      61,    66,    68,    69,    72,    73,    74,    75,    76,    79,
      80,    81,    82,    83,    84,    17,    51,    51,    51,    69,
      51,    51,    80,    50,    50,     3,     4,     5,     6,     7,
      16,    27,    32,    50,    51,    85,    86,    87,    51,    70,
      50,    50,    50,     6,    85,    52,    67,    85,    85,    85,
      35,     6,    68,    79,    80,    85,     6,    51,    85,    85,
      85,    85,     8,     9,    10,    11,    12,    13,    14,    15,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    32,
      50,    85,    71,    17,    51,    52,    53,    52,    52,    51,
      50,    50,     6,    52,    17,    52,    67,    52,    85,    85,
      85,    85,    85,    85,    85,    85,    85,    85,    85,    85,
      85,    85,    85,    85,    85,    52,    55,    60,    85,    52,
      64,    65,    80,    85,    69,    69,    85,    85,    85,    54,
      85,    52,    50,    63,    52,    53,     6,    34,    52,    50,
      50,    77,    69,    62,    64,    69,    50,    45,    45,    39,
      55,    78,    69,    56,    56,    85,     6,    87,    87,    57,
      52,    52,    60,    69,    69,    50
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 18:

/* Line 1455 of yacc.c  */
#line 99 "parser.y"
    {
            val *func_val = malloc(sizeof(val));
            func_val->type = (yyvsp[(1) - (5)].i);

            // Count parameters
            int param_count = 0;
            Parameter *p = (yyvsp[(4) - (5)].p);
            while (p) { param_count++; p = p->next; }

            // Insert function with parameters
            last_symbol_inserted = insert_symbol(current_scope, (yyvsp[(2) - (5)].s), func_val, SYM_FUNCTION, param_count, (yyvsp[(4) - (5)].p));
            current_params = (yyvsp[(4) - (5)].p); // Store for block_statement
        ;}
    break;

  case 19:

/* Line 1455 of yacc.c  */
#line 112 "parser.y"
    { current_params = NULL; ;}
    break;

  case 20:

/* Line 1455 of yacc.c  */
#line 115 "parser.y"
    {
                                                                        // Similar handling for no-parameter functions
                                                                        val* func_val = malloc(sizeof(val));
                                                                        func_val->type = (yyvsp[(1) - (4)].i);
                                                                        last_symbol_inserted=insert_symbol(current_scope, (yyvsp[(2) - (4)].s), func_val, SYM_FUNCTION,0,NULL);
                                                                        
                                                                        
                                                                    ;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 123 "parser.y"
    {    ;}
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 127 "parser.y"
    {
            val *v = malloc(sizeof(val));
            v->type = (yyvsp[(1) - (2)].i);
            switch ((yyvsp[(1) - (2)].i)) { // Initialize default value
                case TYPE_INT: v->data.i = 0; break;
                case TYPE_FLOAT: v->data.f = 0.0f; break;
                case TYPE_STRING: v->data.s = strdup(""); break;
                case TYPE_BOOL: v->data.b = 0; break;
            }
            (yyval.p) = create_param((yyvsp[(2) - (2)].s), v);
        ;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 141 "parser.y"
    { (yyval.p) = (yyvsp[(1) - (1)].p); ;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 142 "parser.y"
    { (yyval.p) = append_param((yyvsp[(1) - (3)].p), (yyvsp[(3) - (3)].p)); ;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 157 "parser.y"
    { (yyval.v) = (yyvsp[(1) - (1)].v); ;}
    break;

  case 28:

/* Line 1455 of yacc.c  */
#line 158 "parser.y"
    { (yyval.v) = (yyvsp[(3) - (3)].v); ;}
    break;

  case 29:

/* Line 1455 of yacc.c  */
#line 162 "parser.y"
    {
                                            // Lookup variable
                                            Symbol* sym = lookup_symbol(current_scope, (yyvsp[(1) - (3)].s));
                                            if (!sym) {
                                                yyerror("Undefined variable");
                                                YYERROR;
                                            }
                                            
                                            // Check if constant
                                            if (sym->sym_type == SYM_CONSTANT) {
                                                yyerror("Cannot assign to constant");
                                                YYERROR;
                                            }
                                            
                                            // Type checking
                                            if (sym->value->type != (yyvsp[(3) - (3)].v)->type) {
                                                yyerror("Type mismatch in assignment");
                                                YYERROR;
                                            }
                                            
                                            // Update value
                                            switch(sym->value->type) {
                                                case TYPE_INT: sym->value->data.i = (yyvsp[(3) - (3)].v)->data.i; break;
                                                case TYPE_FLOAT: sym->value->data.f = (yyvsp[(3) - (3)].v)->data.f; break;
                                                case TYPE_STRING: 
                                                    free(sym->value->data.s);
                                                    sym->value->data.s = strdup((yyvsp[(3) - (3)].v)->data.s);
                                                    break;
                                                case TYPE_BOOL: sym->value->data.b = (yyvsp[(3) - (3)].v)->data.b; break;
                                            }
                                            free_val((yyvsp[(3) - (3)].v));
                                        ;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 198 "parser.y"
    {
                                                                // Create new scope
                                                                SymbolTable* new_scope = create_symbol_table(current_scope);
                                                                current_scope = new_scope;

                                                                // Add parameters to the new scope
                                                                if (current_params) {
                                                                    Parameter *param = current_params;
                                                                    while (param) {
                                                                        val *v = malloc(sizeof(val));
                                                                        v->type = param->value->type;
                                                                        // Copy data based on type
                                                                        switch (v->type) {
                                                                            case TYPE_INT:    v->data.i = param->value->data.i; break;
                                                                            case TYPE_FLOAT:  v->data.f = param->value->data.f; break;
                                                                            case TYPE_STRING: v->data.s = strdup(param->value->data.s); break;
                                                                            case TYPE_BOOL:   v->data.b = param->value->data.b; break;
                                                                        }
                                                                        insert_symbol(current_scope, param->name, v, SYM_VARIABLE,0,NULL);
                                                                        param = param->next;
                                                                    }
                                                                }
                                                            ;}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 223 "parser.y"
    {
                                                            // Cleanup scope
                                                            SymbolTable* parent_scope = current_scope->parent;
                                                            free_symbol_table(current_scope);
                                                            current_scope = parent_scope;
                                                        ;}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 269 "parser.y"
    {
                                                                if(is_symbol_in_current_scope(current_scope, (yyvsp[(2) - (2)].s))) {
                                                                    yyerror("Variable already declared in this scope");
                                                                    YYERROR;
                                                                } else {
                                                                    val* v = malloc(sizeof(val));
                                                                    v->type = (yyvsp[(1) - (2)].i);
                                                                    switch((yyvsp[(1) - (2)].i)) {
                                                                        case TYPE_INT: v->data.i = 0; break;
                                                                        case TYPE_FLOAT: v->data.f = 0.0f; break;
                                                                        case TYPE_STRING: v->data.s = strdup(""); break;
                                                                        case TYPE_BOOL: v->data.b = 0; break;
                                                                    }
                                                                    
                                                                    last_symbol_inserted=insert_symbol(current_scope, (yyvsp[(2) - (2)].s), v,SYM_VARIABLE,0,NULL);
                                                                }
                                                              ;}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 287 "parser.y"
    {
                                                                    // Type checking
                                                                    if ((yyvsp[(1) - (4)].i) != (yyvsp[(4) - (4)].v)->type) {
                                                                        yyerror("Type mismatch in initialization");
                                                                        YYERROR;
                                                                    }
                                                                    
                                                                    // Insert symbol
                                                                    if (is_symbol_in_current_scope(current_scope, (yyvsp[(2) - (4)].s))) {
                                                                        yyerror("Variable already declared");
                                                                        YYERROR;
                                                                    }
                                                                    last_symbol_inserted=insert_symbol(current_scope, (yyvsp[(2) - (4)].s), (yyvsp[(4) - (4)].v),SYM_VARIABLE,0,NULL);
                                                                ;}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 302 "parser.y"
    {
                                                                    if ((yyvsp[(2) - (5)].i) != (yyvsp[(5) - (5)].v)->type) {
                                                                        yyerror("Type mismatch in constant initialization");
                                                                        YYERROR;
                                                                    }
                                                                    if (is_symbol_in_current_scope(current_scope, (yyvsp[(3) - (5)].s))) {
                                                                        yyerror("Constant already declared");
                                                                        YYERROR;
                                                                    }
                                                                    last_symbol_inserted=insert_symbol(current_scope, (yyvsp[(3) - (5)].s), (yyvsp[(5) - (5)].v), SYM_CONSTANT,0,NULL);
                                                                ;}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 317 "parser.y"
    { (yyval.i) = TYPE_INT; ;}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 318 "parser.y"
    { (yyval.i) = TYPE_FLOAT; ;}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 319 "parser.y"
    { (yyval.i) = TYPE_STRING; ;}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 320 "parser.y"
    { (yyval.i) = TYPE_BOOL; ;}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 341 "parser.y"
    { switch ((yyvsp[(3) - (5)].v)->type) {
                                                                              case TYPE_INT:
                                                                                  printf("%d\n", (yyvsp[(3) - (5)].v)->data.i);
                                                                                  break;
                                                                              case TYPE_FLOAT:
                                                                                  printf("%f\n", (yyvsp[(3) - (5)].v)->data.f);
                                                                                  break;
                                                                              case TYPE_STRING:
                                                                                  printf("%s\n", (yyvsp[(3) - (5)].v)->data.s);
                                                                                  break;
                                                                              case TYPE_BOOL:
                                                                                  printf((yyvsp[(3) - (5)].v)->data.b ? "true\n" : "false\n");
                                                                                  break;
                                                                              default:
                                                                                  yyerror("Unknown type in print statement");
                                                                          }

                                                                          // Free the allocated val structure
                                                                          free((yyvsp[(3) - (5)].v));
                                                                      ;}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 365 "parser.y"
    {
        (yyval.v) = (yyvsp[(1) - (1)].v);
    ;}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 369 "parser.y"
    { 
                                                                          if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                              ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                              (yyval.v) = malloc(sizeof(val));
                                                                              if ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) {
                                                                                  (yyval.v)->type = TYPE_FLOAT;
                                                                                  float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                  float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                  (yyval.v)->data.f = left + right;
                                                                              } else {
                                                                                  (yyval.v)->type = TYPE_INT;
                                                                                  (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i + (yyvsp[(3) - (3)].v)->data.i;
                                                                              }
                                                                          } else {
                                                                              yyerror("Invalid expression: cannot perform addition between non-numerical expressions.");
                                                                          }
                                                                      ;}
    break;

  case 59:

/* Line 1455 of yacc.c  */
#line 387 "parser.y"
    {
                                                                           if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                               ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                               (yyval.v) = malloc(sizeof(val));
                                                                               if ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) {
                                                                                   (yyval.v)->type = TYPE_FLOAT;
                                                                                   float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                   float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                   (yyval.v)->data.f = left - right;
                                                                               } else {
                                                                                   (yyval.v)->type = TYPE_INT;
                                                                                   (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i - (yyvsp[(3) - (3)].v)->data.i;
                                                                               }
                                                                           } else {
                                                                               yyerror("Invalid expression: cannot perform subtraction between non-numerical expressions.");
                                                                           }
                                                                       ;}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 405 "parser.y"
    {
                                                                         if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                             ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                             (yyval.v) = malloc(sizeof(val));
                                                                             if ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) {
                                                                                 (yyval.v)->type = TYPE_FLOAT;
                                                                                 float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                 float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                 (yyval.v)->data.f = left * right;
                                                                             } else {
                                                                                 (yyval.v)->type = TYPE_INT;
                                                                                 (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i * (yyvsp[(3) - (3)].v)->data.i;
                                                                             }
                                                                         } else {
                                                                             yyerror("Invalid expression: cannot perform multiplication between non-numerical expressions.");
                                                                         }
                                                                     ;}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 423 "parser.y"
    {
                                                                         if (((yyvsp[(3) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->data.i == 0) ||
                                                                             ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT && (yyvsp[(3) - (3)].v)->data.f == 0.0f)) {
                                                                             yyerror("Division by zero");
                                                                         } else if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                                   ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                             (yyval.v) = malloc(sizeof(val));
                                                                             (yyval.v)->type = TYPE_FLOAT;
                                                                             float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                             float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                             (yyval.v)->data.f = left / right;
                                                                         } else {
                                                                             yyerror("Invalid expression: cannot perform division between non-numerical expressions.");
                                                                         }
                                                                     ;}
    break;

  case 62:

/* Line 1455 of yacc.c  */
#line 439 "parser.y"
    {
                                                                         if ((yyvsp[(1) - (3)].v)->type != (yyvsp[(3) - (3)].v)->type) {
                                                                             yyerror("Invalid type for equality comparison");
                                                                             (yyval.v) = malloc(sizeof(val));
                                                                             (yyval.v)->type = TYPE_BOOL;
                                                                             (yyval.v)->data.b = 0;
                                                                             
                                                                             // Print the failed comparison
                                                                             printf("Comparison failed: ");
                                                                             print_val((yyvsp[(1) - (3)].v));
                                                                             printf(" == ");
                                                                             print_val((yyvsp[(3) - (3)].v));
                                                                             printf(" -> false (type mismatch)\n");
                                                                         } else {
                                                                             (yyval.v) = malloc(sizeof(val));
                                                                             (yyval.v)->type = TYPE_BOOL;
                                                                             int result;
                                                                             switch ((yyvsp[(1) - (3)].v)->type) {
                                                                                 case TYPE_INT:
                                                                                     result = ((yyvsp[(1) - (3)].v)->data.i == (yyvsp[(3) - (3)].v)->data.i);
                                                                                     (yyval.v)->data.b = result;
                                                                                     break;
                                                                                 case TYPE_FLOAT:
                                                                                     result = ((yyvsp[(1) - (3)].v)->data.f == (yyvsp[(3) - (3)].v)->data.f);
                                                                                     (yyval.v)->data.b = result;
                                                                                     break;
                                                                                 case TYPE_STRING:
                                                                                     result = (strcmp((yyvsp[(1) - (3)].v)->data.s, (yyvsp[(3) - (3)].v)->data.s) == 0);
                                                                                     (yyval.v)->data.b = result;
                                                                                     break;
                                                                                 case TYPE_BOOL:
                                                                                     result = ((yyvsp[(1) - (3)].v)->data.b == (yyvsp[(3) - (3)].v)->data.b);
                                                                                     (yyval.v)->data.b = result;
                                                                                     break;
                                                                                 default:
                                                                                     yyerror("Invalid type for equality comparison");
                                                                                     (yyval.v)->data.b = 0;
                                                                                     result = 0;
                                                                             }
                                                                             
                                                                             // Print the comparison and result
                                                                             printf("Comparison: ");
                                                                             print_val((yyvsp[(1) - (3)].v));
                                                                             printf(" == ");
                                                                             print_val((yyvsp[(3) - (3)].v));
                                                                             printf(" -> %s\n", result ? "true" : "false");
                                                                         }
                                                                         
                                                                         // Free the operands
                                                                         free_val((yyvsp[(1) - (3)].v));
                                                                         free_val((yyvsp[(3) - (3)].v));
                                                                     ;}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 492 "parser.y"
    {
                                                                          if ((yyvsp[(1) - (3)].v)->type != (yyvsp[(3) - (3)].v)->type) {
                                                                              yyerror("Invalid type for inequality comparison");
                                                                              (yyval.v) = malloc(sizeof(val));
                                                                              (yyval.v)->type = TYPE_BOOL;
                                                                              (yyval.v)->data.b = 1;
                                                                          } else {
                                                                              (yyval.v) = malloc(sizeof(val));
                                                                              (yyval.v)->type = TYPE_BOOL;
                                                                              switch ((yyvsp[(1) - (3)].v)->type) {
                                                                                  case TYPE_INT:
                                                                                      (yyval.v)->data.b = ((yyvsp[(1) - (3)].v)->data.i != (yyvsp[(3) - (3)].v)->data.i);
                                                                                      break;
                                                                                  case TYPE_FLOAT:
                                                                                      (yyval.v)->data.b = ((yyvsp[(1) - (3)].v)->data.f != (yyvsp[(3) - (3)].v)->data.f);
                                                                                      break;
                                                                                  case TYPE_STRING:
                                                                                      (yyval.v)->data.b = (strcmp((yyvsp[(1) - (3)].v)->data.s, (yyvsp[(3) - (3)].v)->data.s) != 0);
                                                                                      break;
                                                                                  case TYPE_BOOL:
                                                                                      (yyval.v)->data.b = ((yyvsp[(1) - (3)].v)->data.b != (yyvsp[(3) - (3)].v)->data.b);
                                                                                      break;
                                                                                  default:
                                                                                      yyerror("Invalid type for inequality comparison");
                                                                                      (yyval.v)->data.b = 1;
                                                                              }
                                                                          }
                                                                      ;}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 521 "parser.y"
    {
                                                                          if ((yyvsp[(1) - (3)].v)->type != TYPE_BOOL || (yyvsp[(3) - (3)].v)->type != TYPE_BOOL) {
                                                                              yyerror("Logical AND requires boolean operands");
                                                                              (yyval.v) = malloc(sizeof(val));
                                                                              (yyval.v)->type = TYPE_BOOL;
                                                                              (yyval.v)->data.b = 0;
                                                                          } else {
                                                                              (yyval.v) = malloc(sizeof(val));
                                                                              (yyval.v)->type = TYPE_BOOL;
                                                                              (yyval.v)->data.b = (yyvsp[(1) - (3)].v)->data.b && (yyvsp[(3) - (3)].v)->data.b;
                                                                          }
                                                                      ;}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 534 "parser.y"
    {
                                                                            if ((yyvsp[(1) - (3)].v)->type != TYPE_BOOL || (yyvsp[(3) - (3)].v)->type != TYPE_BOOL) {
                                                                                yyerror("Logical OR requires boolean operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            } else {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = (yyvsp[(1) - (3)].v)->data.b || (yyvsp[(3) - (3)].v)->data.b;
                                                                            }
                                                                        ;}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 547 "parser.y"
    {
                                                                            if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                                ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                (yyval.v)->data.b = (left < right);
                                                                            } else {
                                                                                yyerror("Comparison operator '<' requires numeric operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            }
                                                                        ;}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 563 "parser.y"
    {
                                                                            if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                                ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                (yyval.v)->data.b = (left <= right);
                                                                            } else {
                                                                                yyerror("Comparison operator '<=' requires numeric operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            }
                                                                        ;}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 579 "parser.y"
    {
                                                                            if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                                ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                (yyval.v)->data.b = (left > right);
                                                                            } else {
                                                                                yyerror("Comparison operator '>' requires numeric operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            }
                                                                        ;}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 595 "parser.y"
    {
                                                                            if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                                ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                float left = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                float right = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                (yyval.v)->data.b = (left >= right);
                                                                            } else {
                                                                                yyerror("Comparison operator '>=' requires numeric operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            }
                                                                        ;}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 611 "parser.y"
    {
                                                                            if ((yyvsp[(1) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->type == TYPE_INT) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i & (yyvsp[(3) - (3)].v)->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise AND requires integer operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = 0;
                                                                            }
                                                                        ;}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 624 "parser.y"
    {
                                                                            if ((yyvsp[(1) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->type == TYPE_INT) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i | (yyvsp[(3) - (3)].v)->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise OR requires integer operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = 0;
                                                                            }
                                                                        ;}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 637 "parser.y"
    {
                                                                            if ((yyvsp[(1) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->type == TYPE_INT) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i ^ (yyvsp[(3) - (3)].v)->data.i;
                                                                            } else {
                                                                                yyerror("Bitwise XOR requires integer operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = 0;
                                                                            }
                                                                        ;}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 650 "parser.y"
    {
                                                                            if ((yyvsp[(2) - (2)].v)->type != TYPE_BOOL) {
                                                                                yyerror("Logical NOT requires boolean operand");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = 0;
                                                                            } else {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_BOOL;
                                                                                (yyval.v)->data.b = !(yyvsp[(2) - (2)].v)->data.b;
                                                                            }
                                                                        ;}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 663 "parser.y"
    {
                                                                            if ((yyvsp[(2) - (2)].v)->type != TYPE_INT) {
                                                                                yyerror("Bitwise NOT requires integer operand");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = 0;
                                                                            } else {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = ~(yyvsp[(2) - (2)].v)->data.i;
                                                                            }
                                                                        ;}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 676 "parser.y"
    {
                                                                            if ((yyvsp[(2) - (2)].v)->type != TYPE_INT && (yyvsp[(2) - (2)].v)->type != TYPE_FLOAT) {
                                                                                yyerror("Increment requires numeric operand");
                                                                                YYERROR;
                                                                            }
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = (yyvsp[(2) - (2)].v)->type;
                                                                            if ((yyvsp[(2) - (2)].v)->type == TYPE_INT) {
                                                                                (yyval.v)->data.i = ++((yyvsp[(2) - (2)].v)->data.i);
                                                                            } else {
                                                                                (yyval.v)->data.f = ++((yyvsp[(2) - (2)].v)->data.f);
                                                                            }
                                                                        ;}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 690 "parser.y"
    {
                                                                            if ((yyvsp[(1) - (2)].v)->type != TYPE_INT && (yyvsp[(1) - (2)].v)->type != TYPE_FLOAT) {
                                                                                yyerror("Increment requires numeric operand");
                                                                                YYERROR;
                                                                            }
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = (yyvsp[(1) - (2)].v)->type;
                                                                            if ((yyvsp[(1) - (2)].v)->type == TYPE_INT) {
                                                                                (yyval.v)->data.i = (yyvsp[(1) - (2)].v)->data.i++;
                                                                            } else {
                                                                                (yyval.v)->data.f = (yyvsp[(1) - (2)].v)->data.f++;
                                                                            }
                                                                        ;}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 704 "parser.y"
    {
                                                                            if ((yyvsp[(3) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->data.i == 0) {
                                                                                yyerror("Modulus by zero");
                                                                            } else if ((yyvsp[(1) - (3)].v)->type == TYPE_INT && (yyvsp[(3) - (3)].v)->type == TYPE_INT) {
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = (yyvsp[(1) - (3)].v)->data.i % (yyvsp[(3) - (3)].v)->data.i;
                                                                            } else {
                                                                                yyerror("Modulus requires integer operands");
                                                                                (yyval.v) = malloc(sizeof(val));
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                (yyval.v)->data.i = 0;
                                                                            }
                                                                        ;}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 719 "parser.y"
    {
                                                                        if (((yyvsp[(1) - (3)].v)->type == TYPE_INT || (yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) && 
                                                                            ((yyvsp[(3) - (3)].v)->type == TYPE_INT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT)) {
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            if ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT || (yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) {
                                                                                (yyval.v)->type = TYPE_FLOAT;
                                                                                float base = ((yyvsp[(1) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(1) - (3)].v)->data.f : (float)(yyvsp[(1) - (3)].v)->data.i;
                                                                                float exponent = ((yyvsp[(3) - (3)].v)->type == TYPE_FLOAT) ? (yyvsp[(3) - (3)].v)->data.f : (float)(yyvsp[(3) - (3)].v)->data.i;
                                                                                (yyval.v)->data.f = powf(base, exponent);
                                                                            } else {
                                                                                (yyval.v)->type = TYPE_INT;
                                                                                // Simple integer power (won't handle negative exponents well)
                                                                                int result = 1;
                                                                                for (int i = 0; i < (yyvsp[(3) - (3)].v)->data.i; i++) {
                                                                                    result *= (yyvsp[(1) - (3)].v)->data.i;
                                                                                }
                                                                                (yyval.v)->data.i = result;
                                                                            }
                                                                        } else {
                                                                            yyerror("Power operation requires numeric operands");
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = TYPE_INT;
                                                                            (yyval.v)->data.i = 0;
                                                                        }
                                                                    ;}
    break;

  case 79:

/* Line 1455 of yacc.c  */
#line 745 "parser.y"
    {
                                                                            (yyval.v) = (yyvsp[(2) - (3)].v);
                                                                        ;}
    break;

  case 80:

/* Line 1455 of yacc.c  */
#line 751 "parser.y"
    {
                                                                            // Lookup function
                                                                            Symbol* func = lookup_symbol(current_scope, (yyvsp[(1) - (4)].s));
                                                                            if (!func || func->sym_type != SYM_FUNCTION) {
                                                                                yyerror("Undefined function");
                                                                                YYERROR;
                                                                            }
                                                                            // For now just return first argument
                                                                            (yyval.v) = (yyvsp[(3) - (4)].v);
                                                                        ;}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 762 "parser.y"
    {
                                                                            Symbol* func = lookup_symbol(current_scope, (yyvsp[(1) - (3)].s));
                                                                            if (!func || func->sym_type != SYM_FUNCTION) {
                                                                                yyerror("Undefined function");
                                                                                YYERROR;
                                                                            }
                                                                            // Return default value
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = func->value->type;
                                                                            switch((yyval.v)->type) {
                                                                                case TYPE_INT: (yyval.v)->data.i = 0; break;
                                                                                case TYPE_FLOAT: (yyval.v)->data.f = 0.0f; break;
                                                                                case TYPE_STRING: (yyval.v)->data.s = strdup(""); break;
                                                                                case TYPE_BOOL: (yyval.v)->data.b = 0; break;
                                                                            }
                                                                        ;}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 781 "parser.y"
    {
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = TYPE_INT;
                                                                            (yyval.v)->data.i = (yyvsp[(1) - (1)].i);
                                                                        ;}
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 787 "parser.y"
    {
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = TYPE_FLOAT;
                                                                            (yyval.v)->data.f = (yyvsp[(1) - (1)].f);
                                                                        ;}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 793 "parser.y"
    {
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = TYPE_STRING;
                                                                            (yyval.v)->data.s = (yyvsp[(1) - (1)].s);
                                                                        ;}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 799 "parser.y"
    {
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            (yyval.v)->type = TYPE_BOOL;
                                                                            (yyval.v)->data.b = (yyvsp[(1) - (1)].b);
                                                                        ;}
    break;

  case 86:

/* Line 1455 of yacc.c  */
#line 805 "parser.y"
    {
                                                                            Symbol* sym = lookup_symbol(current_scope, (yyvsp[(1) - (1)].s));
                                                                            if (!sym) {
                                                                                yyerror("Undefined variable");
                                                                                YYERROR;
                                                                            }
                                                                            // Create a copy of the value
                                                                            (yyval.v) = malloc(sizeof(val));
                                                                            memcpy((yyval.v), sym->value, sizeof(val));
                                                                            if ((yyval.v)->type == TYPE_STRING) {
                                                                                (yyval.v)->data.s = strdup(sym->value->data.s);
                                                                            }
                                                                        ;}
    break;



/* Line 1455 of yacc.c  */
#line 2551 "parser.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 823 "parser.y"

/* Helper function implementations */
void print_val(val *v) {
    if (v == NULL) {
        printf("NULL");
        return;
    }
    
    switch (v->type) {
        case TYPE_INT:
            printf("%d", v->data.i);
            break;
        case TYPE_FLOAT:
            printf("%f", v->data.f);
            break;
        case TYPE_STRING:
            printf("%s", v->data.s);
            break;
        case TYPE_BOOL:
            printf("%s", v->data.b ? "true" : "false");
            break;
        default:
            printf("unknown");
    }
}



void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}


int main() {
    global_scope = create_symbol_table(NULL);
    current_scope = global_scope;
    Symbol *last_symbol_inserted=NULL;
    Parameter *parameter_head=NULL ;
    
    
    // Add built-in functions
    val* print_val = malloc(sizeof(val));
    print_val->type = TYPE_INT; // Dummy type
    last_symbol_inserted=insert_symbol(global_scope, "print", print_val, SYM_FUNCTION,0,NULL);
    
    int result = yyparse();
    
    // Clean up global scope
    free_symbol_table(global_scope);
    return result;
}


