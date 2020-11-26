%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h> 
  #include <cstring>
  #include <string>
  #include <iostream>
  #include <vector>
  #include <map>
  #include <stack>
  #include <queue>
  using namespace std;
  extern FILE* yyin;
  extern int defautlex();
  int defauterror(const char *s);


  class instruction {
  public:
      instruction(const int& c, const int& v, const string& n) { code = c; val = v; str = n; };
      int code;         // le code de l'instruction machine
      int val;     // éventuellement une valeur si besoin
      string str;      // ou une référence pour la table des données 
  };

  vector<instruction> instructions;    // zone de code 
  map<string, int> variables;   // table de symboles // zone de data
  void add_instruction(const int& c, const int& v = -1, const string& n = "") {
      instructions.push_back(instruction(c, v, n));
  };
  int runProgram();

%}

%define api.prefix {defaut}

%union
{
    char str[128];
    int val;
}

%token <val> NUM
%token <str> VAR

%token MOVE
%token TURN
%token <val> DIR
%token TURNBACK
%token <val> CARRY
%token USE
%token <val> TAKE
%token <val> PUSH

%token EQ
%token INF
%token SUP
%token AND
%token OR


%token DO
%token TIME

%token OPEN
%token CLOSE

%token ENDL

%left PLUS MINUS
%left MULT DIV

%%
ligne:                      { }
     | ligne commande ENDL  { } 
     | ligne commande       { runProgram(); }
     | ligne expr ENDL      {}
     | ligne expr           { runProgram(); }

commande :
      | MOVE                    {add_instruction(MOVE);}
      | TURN DIR                {add_instruction(TURN, $2);}
      | TURNBACK                {add_instruction(TURNBACK);}
      | CARRY                   {add_instruction(CARRY, $1);}
      | TAKE                    {add_instruction(TAKE, $1);}
      | PUSH                    {add_instruction(PUSH, $1);}
      | USE                     {add_instruction(USE);}
      | VAR EQ expr             {add_instruction(EQ, 0, $1);}
      | commande ENDL commande  {}
      | OPEN                    {add_instruction(OPEN);}
      | CLOSE                   {add_instruction(CLOSE);}
      | DO commande expr TIME   { add_instruction(DO); }
      |      /*  ne pas oublier les lignes vides */

//Gestion des calculs + conditions
expr:  NUM              { add_instruction(NUM, $1);}
     | VAR              { add_instruction(VAR, 0, $1); }
     | OPEN expr CLOSE  { }
     | expr PLUS expr   { add_instruction(PLUS); }
     | expr MINUS expr  { add_instruction(MINUS); }
     | expr MULT expr   { add_instruction(MULT); }
     | expr DIV expr    { add_instruction(DIV); }
%%

int defauterror(const char *s) {
    printf("%s\n", s);
    return 0;
}

int runProgram() {
    stack<int> Pile;
    queue<instruction> Executer;
    bool open = false, parenthese, erreur;
    int i, nb;
    for (int i_ins = 0; (unsigned int)i_ins < instructions.size(); i_ins++) {
        
        /*
        cout << endl << "Instruction : " << endl;
        cout << "    Code : " << instructions[i_ins].code << endl;
        cout << "    Val : " << instructions[i_ins].val << endl;
        cout << "    Str : " << instructions[i_ins].str << endl << endl;
        */
        
        switch (instructions[i_ins].code) {
        case NUM:
            Pile.push(instructions[i_ins].val);
            cout << "on empile " << instructions[i_ins].val << endl;
            break;
        case VAR:
            try {
                Pile.push(variables.at(instructions[i_ins].str));
                cout << "On empile " << instructions[i_ins].str << '(' << instructions[i_ins].val << ')' << endl;
            }
            catch (...) {
                cout << "ERROR : Variable utilisée mais jamais initialisée : " << instructions[i_ins].str << endl;
                throw; // car le problème ne peut être géré!
            }
            break;
        case EQ:
            // Mettre le résultat dans la table de données.
            // Ici on utilise les [] pour créer la variable si elle n'existe pas
            // ailleurs on utilisra le .at()
            variables[instructions[i_ins].str] = Pile.top();
            Pile.pop();
            cout << "On stocke " << variables[instructions[i_ins].str] << " dans " << instructions[i_ins].str << endl;
            break;
        case PLUS:
            i = Pile.top();    // Rrécupérer la tête de pile;
            Pile.pop();
            cout << "Opérateur + : " << endl;
            cout << "- on dépile " << i << endl;
            i += Pile.top();
            cout << "- on dépile " << Pile.top() << endl;
            Pile.pop();
            Pile.push(i);
            cout << "- on empile " << i << endl;
            break;
        case MINUS:
            i = Pile.top();    // Rrécupérer la tête de pile;
            Pile.pop();
            cout << "Opérateur + : " << endl;
            cout << "- on dépile " << i << endl;
            nb = Pile.top();
            cout << "- on dépile " << Pile.top() << endl;
            Pile.pop();
            Pile.push(nb-i);
            cout << "- on empile " << nb-i << endl;
            break;
        case MULT:
            i = Pile.top();    // Rrécupérer la tête de pile;
            Pile.pop();
            cout << "Opérateur + : " << endl;
            cout << "- on dépile " << i << endl;
            i *= Pile.top();
            cout << "- on dépile " << Pile.top() << endl;
            Pile.pop();
            Pile.push(i);
            cout << "- on empile " << i << endl;
            break;
        case DIV:
            i = Pile.top();    // Rrécupérer la tête de pile;
            Pile.pop();
            cout << "Opérateur + : " << endl;
            cout << "- on dépile " << i << endl;
            nb = Pile.top();
            cout << "- on dépile " << Pile.top() << endl;
            Pile.pop();
            Pile.push(nb/i);
            cout << "- on empile " << nb/i << endl;
            break;
        case DO:
            nb = Pile.top();
            Pile.pop();
            parenthese = false;
            erreur = true;

            i = i_ins - 2;
            if(i >= 0) if (instructions[i].code == CLOSE) {
                parenthese = true;
                while (i > 0 && instructions[i].code != OPEN) i--;
            }
            if (i >= 0) if (instructions[i].code == OPEN) {
                i++;
                for (int k = 0; k < nb; k++) {
                    int j = i;
                    while (instructions[j].code != CLOSE) {
                        Executer.push(instructions[j]);
                        j++;
                    }
                }
                erreur = false;
            }

            if (!parenthese) {
                if (i_ins >= 2) { // on vérifie le dépassement de capacité
                    for (int k = 0; k < nb - 1; k++) { // -1 car l'élément est comptabilisé une fois par defaut
                        Executer.push(instructions[i_ins - 2]);
                    }
                    erreur = false;
                }
            }

            if(erreur){
                cout << "Il manque des éléments pour exécuter la boucle" << endl;
                throw;
            }
            cout << "Faire" << endl;
            break;
        case OPEN:
            open = true;
            break;
        case CLOSE:
            open = false;
            break;
        case MOVE:
        case TURN:
        case TURNBACK:
        case CARRY:
        case USE:
        case TAKE:
        case PUSH:
            if (!open) Executer.push(instructions[i_ins]);
            break;
        default:
            cout << "Error" << endl;
        }
    }

    cout << endl << "Execution : " << endl << endl;
    while (Executer.size() > 0) {
        instruction tmp = Executer.front();
        Executer.pop();

        /*
        cout << endl << "Executer : " << endl;
        cout << "    Code : " << tmp.code << endl;
        cout << "    Val : " << tmp.val << endl;
        cout << "    Str : " << tmp.str << endl << endl;
        */

        switch (tmp.code) {
        case MOVE:
            cout << "On avance !" << endl;
            break;
        case TURN:
            if (tmp.val == 4) cout << "On tourne à gauche !" << endl;
            else if (tmp.val == 6) cout << "On tourne à droite !" << endl;
            else {
                cout << "ERROR : Direction pour tourner manquante." << endl;
                throw; // car le problème ne peut être géré!
            }
            break;
        case TURNBACK:
            cout << "On se retourne !" << endl;
            break;
        case CARRY:
            if (tmp.val) {
                cout << "On porte !" << endl;
            }
            else {
                cout << "On pose !" << endl;
            }
            break;
        case USE:
            cout << "On utilise !" << endl;
            break;
        case TAKE:
            if (tmp.val) {
                cout << "On attrape !" << endl;
            }
            else {
                cout << "On lache !" << endl;
            }
            break;
        case PUSH:
            if (tmp.val == 8) {
                cout << "On pousse !" << endl;
            }
            else if (tmp.val == 2) {
                cout << "On tire !" << endl;
            }
            break;
        default:
            cout << "Erreur !" << endl;
        }
    }
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