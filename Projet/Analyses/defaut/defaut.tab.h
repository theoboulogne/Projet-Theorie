/* A Bison parser, made by GNU Bison 3.7.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_DEFAUT_DEFAUT_TAB_H_INCLUDED
# define YY_DEFAUT_DEFAUT_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef DEFAUTDEBUG
# if defined YYDEBUG
#if YYDEBUG
#   define DEFAUTDEBUG 1
#  else
#   define DEFAUTDEBUG 0
#  endif
# else /* ! defined YYDEBUG */
#  define DEFAUTDEBUG 0
# endif /* ! defined YYDEBUG */
#endif  /* ! defined DEFAUTDEBUG */
#if DEFAUTDEBUG
extern int defautdebug;
#endif

/* Token kinds.  */
#ifndef DEFAUTTOKENTYPE
# define DEFAUTTOKENTYPE
  enum defauttokentype
  {
    DEFAUTEMPTY = -2,
    DEFAUTEOF = 0,                 /* "end of file"  */
    DEFAUTerror = 256,             /* error  */
    DEFAUTUNDEF = 257,             /* "invalid token"  */
    MOVE = 258,                    /* MOVE  */
    TURN = 259,                    /* TURN  */
    DIR = 260,                     /* DIR  */
    TURNBACK = 261,                /* TURNBACK  */
    CARRY = 262,                   /* CARRY  */
    USE = 263,                     /* USE  */
    TAKE = 264,                    /* TAKE  */
    PUSH = 265,                    /* PUSH  */
    DO = 266,                      /* DO  */
    TIME = 267,                    /* TIME  */
    WHILE = 268,                   /* WHILE  */
    IF = 269,                      /* IF  */
    THEN = 270,                    /* THEN  */
    ELSE = 271,                    /* ELSE  */
    OPEN = 272,                    /* OPEN  */
    CLOSE = 273,                   /* CLOSE  */
    ENDL = 274,                    /* ENDL  */
    ENDF = 275,                    /* ENDF  */
    EQ = 276,                      /* EQ  */
    EQQ = 277,                     /* EQQ  */
    NOTEQ = 278,                   /* NOTEQ  */
    INF = 279,                     /* INF  */
    SUP = 280,                     /* SUP  */
    INFEQ = 281,                   /* INFEQ  */
    SUPEQ = 282,                   /* SUPEQ  */
    AND = 283,                     /* AND  */
    OR = 284,                      /* OR  */
    NUM = 285,                     /* NUM  */
    VAR = 286,                     /* VAR  */
    PLUS = 287,                    /* PLUS  */
    MINUS = 288,                   /* MINUS  */
    MULT = 289,                    /* MULT  */
    DIV = 290,                     /* DIV  */
    RESTE = 291                    /* RESTE  */
  };
  typedef enum defauttokentype defauttoken_kind_t;
#endif

/* Value type.  */
#if ! defined DEFAUTSTYPE && ! defined DEFAUTSTYPE_IS_DECLARED
union DEFAUTSTYPE
{
#line 34 "defaut.y"

    char str[128];
    int val;

#line 113 "defaut.tab.h"

};
typedef union DEFAUTSTYPE DEFAUTSTYPE;
# define DEFAUTSTYPE_IS_TRIVIAL 1
# define DEFAUTSTYPE_IS_DECLARED 1
#endif


extern DEFAUTSTYPE defautlval;

int defautparse (void);

#endif /* !YY_DEFAUT_DEFAUT_TAB_H_INCLUDED  */
