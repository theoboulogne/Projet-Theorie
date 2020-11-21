%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h> 
  #include <string.h>
  #include <string>
  #include <iostream>
  extern FILE* yyin;
  extern int testlex();
  int testerror(const char *s);
%}

%define api.prefix {test}

%union
{
    char* str;
    int val;
}

%token <val> NUMM
%type <val> expr
%type <val> ligne

%%

ligne:              { }
| ligne expr ';'   { printf("test = %d\n", $2); }


expr: NUMM           { $$ = $1; }
| expr '+' expr     { $$ = $1 + $3; }
| expr '-' expr     { $$ = $1 - $3; }   		
| expr '*' expr     { $$ = $1 * $3; }		
| expr '/' expr     { $$ = $1 / $3; }    

%%

int testerror(const char *s) {
    printf("%s\n", s);
    return 0;
}







/*
int main(int argc, char* argv[]) {
    
    if(argc == 2) {
        if(strstr(argv[1],".txt")) {
            FILE* file;
            file = fopen(argv[1], "r");
            if (file != NULL)   yyin = file;// fclose(file) pas nécessaire à la fin car à la sortie du main le fichier sera fermé automatiquement.
        }
        else yy_scan_string(argv[1]);
    }
    yyparse();

    return stoi(output);
    */

    /*
    Possibilitées pour l'output : https://docs.microsoft.com/en-us/windows/win32/ipc/interprocess-communications
    - https://www.codegrepper.com/code-examples/cpp/c%2B%2B+string+to+vector+int
    - écrire fichier
    - écrire variable environnement
    - utiliser un registry value
    - utiliser le ctrl+C ctrl+V
    - data copy WMCOPYDATA https://docs.microsoft.com/en-us/windows/win32/dataxchg/data-copy
    */

    /*debut fichier

    extern struct yy_buffer_state yy_buffer_state_def;
    typedef struct yy_buffer_state_def* YY_BUFFER_STATE;
    #define yyconst const
    extern YY_BUFFER_STATE yy_scan_string (yyconst char* yy_str);
    using namespace std;

    */
//}