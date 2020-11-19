%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h> 
  #include <string.h>
  #include <string>
  #include <iostream>

  extern FILE* yyin;
  extern int yylex();
  int yyerror(char* s);

  extern struct yy_buffer_state yy_buffer_state_def;
  typedef struct yy_buffer_state_def* YY_BUFFER_STATE;
  #define yyconst const
  extern YY_BUFFER_STATE yy_scan_string (yyconst char* yy_str);
  using namespace std;

  string output = "-1"; // Variable globale correspondant à la sortie, on l'initialise avec le code ERREUR '-1'
%}

%code requires
  {
    #define YYSTYPE double
  }

%token NUM

%%

ligne:            { }
| ligne expr ';'  { output = to_string($2);  printf("= %f\n", $2); }


expr: NUM           { $$ = $1; }
| expr '+' expr     { $$ = $1 + $3; }
| expr '-' expr     { $$ = $1 - $3; }   		
| expr '*' expr     { $$ = $1 * $3; }		
| expr '/' expr     { $$ = $1 / $3; }    

%%

int yyerror(char *s) {					
    printf("%s\n", s);
    return 0;
}


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
}