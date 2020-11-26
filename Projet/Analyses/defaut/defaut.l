%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <iostream>
  #include <string>
  #include <cstring>
  #include "defaut.tab.h"
  using namespace std;
%}

%option prefix = "defaut"
%option noyywrap

/*
- "avancer"
- "tourner"
- "retourner"
- "retourner"
- "porter" : ne prend rien en parametre, le personnage saisie un objet sur la case en face pour le transporter, le personnage peut tourner avec un objet en main.
- "poser": ne prend rien en parametre, le personnage pose l'objet qu'il a en main si la case en face est vide.
- "actionner": ne prend rien en paramètre, le personnage actionne l'élément de sa case, ou de la case devant lui.
- "attraper" : ne prend rien en parametre, le personnage saisie un objet sur la case en face pour le pousser ou le tirer, il ne peut pas tourner.
- "faire(.......) 'variable' fois": boucle for, code al'interieur des parenthese, variable = nombre d'itération.
- "tant que (.....) faire (.....)" : boucle while, condition dans la première parenthese, code dans la deuxieme.
- "si (.....) alors (.......) 'sinon(.......)' " : condition dans la premiere parenthese, code dans la deuxieme, potentiel cas contraire dans la troisieme parenthese.
*/

%%

[Ff]aire[ ]*                { return DO; }
fois                        { return TIME; }

[Aa]vancer                  { return MOVE; }
[Tt]ourner                  { return TURN; }
([ ]à[ ]gauche)|(\(gauche\))  { defautlval.val = 4; return DIR; }
([ ]à[ ]droite)|(\(droite\))  { defautlval.val = 6; return DIR; }
[Rr]etourner                { return TURNBACK; }

[Pp]orter                   { defautlval.val = 1; return CARRY; } // booleen si on porte un objet
[Pp]oser                    { defautlval.val = 0; return CARRY; }
[Uu]tiliser                 { return USE; }
[Aa]ttraper                 { defautlval.val = 1; return TAKE; } // booleen si on a un objet en main
[Ll]acher                   { defautlval.val = 0; return TAKE; }
[Pp]ousser                  { defautlval.val = 8; return PUSH; } // 8 avant, 2 arrière ( en fonction du pad numerique )
[Tt]irer                    { defautlval.val = 2; return PUSH; }


[0-9]+                      {    // s'il s'agit d'un nombre on le stocke dans le champ "valeur"
                                defautlval.val = stoi(defauttext);
                                return NUM;
                            }
[a-zA-Z_][a-zA-Z0-9_]*      {  	// s'il s'agit d'une variable, on stocke son nom dans le champ "nom"
                                strcpy_s(defautlval.str, sizeof(defauttext), defauttext);
                                return VAR; 
                            }
"+"                         {  return PLUS;  }  // la même chose que return '+'  
"-"                         {  return MINUS; }
"*"                         {  return MULT; }
"/"                         {  return DIV; }
\n                          { return ENDL; }
\r                          {}
"="                         { return EQ; }
"<"                         { return INF; }
">"                         { return SUP; }
" et "                      { return AND; }
" ou "                      { return OR; }
\(                          { return OPEN; }
\)                          { return CLOSE; }



%%

