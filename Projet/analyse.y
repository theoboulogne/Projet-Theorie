%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h> 
  #include <string>
  #include <iostream>
  extern FILE* yyin;
  extern int yylex ();
  int yyerror(char *s);
  using namespace std;

  string output = "-1"; // on initialise a la valeur d'erreur
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
    FILE* file;
    if (argc == 2) {
        file = fopen(argv[1], "r");
        if (file != NULL)   yyin = file; // now flex reads from file
    }

    yyparse();

    if (argc == 2)  fclose(file);
    if (file == yyin) return stoi(output); 
    return -1;// val d'erreur : -1
}