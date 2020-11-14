%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <iostream>
  #include "analyse.bison.hpp"
  using namespace std;
  
%}

%%

[0-9]+(\.[0-9]*)?([Ee][0-9]+)? { yylval = atof(yytext); return NUM; }
;     { return ';'; }
" "    {}
.      {  return yytext[0]; }

%%

int yywrap() {}

