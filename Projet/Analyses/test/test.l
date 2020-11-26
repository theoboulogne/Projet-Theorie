%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <iostream>
  #include "test.tab.h"
  using namespace std;
%}

%option prefix = "test"
%option noyywrap

%%

[0-9]+(\.[0-9]*)?([Ee][0-9]+)? { testlval.val = atof(testtext); return NUMM; }
';'     { return ';'; }
'\r'       {}
" "    {}
.      {  return testtext[0]; }

%%

