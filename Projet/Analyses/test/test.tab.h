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

#ifndef YY_TEST_TEST_TAB_H_INCLUDED
# define YY_TEST_TEST_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef TESTDEBUG
# if defined YYDEBUG
#if YYDEBUG
#   define TESTDEBUG 1
#  else
#   define TESTDEBUG 0
#  endif
# else /* ! defined YYDEBUG */
#  define TESTDEBUG 0
# endif /* ! defined YYDEBUG */
#endif  /* ! defined TESTDEBUG */
#if TESTDEBUG
extern int testdebug;
#endif

/* Token kinds.  */
#ifndef TESTTOKENTYPE
# define TESTTOKENTYPE
  enum testtokentype
  {
    TESTEMPTY = -2,
    TESTEOF = 0,                   /* "end of file"  */
    TESTerror = 256,               /* error  */
    TESTUNDEF = 257,               /* "invalid token"  */
    NUMM = 258                     /* NUMM  */
  };
  typedef enum testtokentype testtoken_kind_t;
#endif

/* Value type.  */
#if ! defined TESTSTYPE && ! defined TESTSTYPE_IS_DECLARED
union TESTSTYPE
{
#line 16 "test.y"

    char* str;
    int val;

#line 80 "test.tab.h"

};
typedef union TESTSTYPE TESTSTYPE;
# define TESTSTYPE_IS_TRIVIAL 1
# define TESTSTYPE_IS_DECLARED 1
#endif


extern TESTSTYPE testlval;

int testparse (void);

#endif /* !YY_TEST_TEST_TAB_H_INCLUDED  */
