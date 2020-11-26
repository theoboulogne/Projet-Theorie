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
  extern int defautlex();
  int defauterror(const char *s);


  class instruction {
  public:
      instruction(const int& c, const int& v, const string& n) { code = c; val = v; str = n; };
      int code;         // le code de l'instruction machine
      int val;          // éventuellement une valeur si besoin
      string str;       // ou une référence pour la table des données
  };
  vector<instruction> instructions = vector<instruction>(); // Enregistrement des différentes instructions
  map<string, int> variables; // Enregistrement des variables
  void add_instruction(const int& c, const int& v = -1, const string& n = "") {instructions.push_back(instruction(c, v, n));};
  int runProgram();

%}

%define api.prefix {defaut}

%union
{
    char str[128];
    int val;
}

//Instruction executable
%token MOVE
%token TURN
%token <val> DIR
%token TURNBACK
%token <val> CARRY
%token USE
%token <val> TAKE
%token <val> PUSH
//Identifieur syntaxique ( boucle / condition )
%token DO
%token TIME
%token WHILE
%token IF
%token THEN
%token ELSE
//Parenthèses
%token OPEN
%token CLOSE
//Passage de ligne et fin de fichier
%token ENDL
%token ENDF
//Définition d'une variable
%token EQ
//Condition
%token EQQ
%token NOTEQ
%token INF
%token SUP
%token INFEQ
%token SUPEQ
%token AND
%token OR
//Expression
%token <val> NUM
%token <str> VAR
//Opérateurs de calcul
%left PLUS MINUS
%left MULT DIV RESTE

%%
ligne:                          {}
     | ligne commande commande  {}
     | ligne commande ENDF      {runProgram();}

commandes : commandetmp CLOSE         {add_instruction(CLOSE);}

commandetmp : ENDL OPEN             {add_instruction(OPEN);}
            | OPEN                  {add_instruction(OPEN);}
            | commandetmp commande
            | commandetmp commande ENDL

commande :
      | commande ENDL           {}
      | MOVE                    {add_instruction(MOVE);}
      | TURN DIR                {add_instruction(TURN, $2);}
      | TURNBACK                {add_instruction(TURNBACK);}
      | CARRY                   {add_instruction(CARRY, $1);}
      | TAKE                    {add_instruction(TAKE, $1);}
      | PUSH                    {add_instruction(PUSH, $1);}
      | USE                     {add_instruction(USE);}
      | VAR EQ expr             {add_instruction(EQ, -1, $1);}
      | DO commandes expr TIME  {add_instruction(DO, 0);} // Gestion avec parenthèse -> Lister les instructions entre OPEN et CLOSE et enregistrer le reste dans un vecteur pour calc la condition
      | DO commande expr TIME   {add_instruction(DO, 1);} // Gestion sans parenthèse -> Chercher la dernière instruction executable enregistrer le reste dans un vecteur pour calculer la condition
      | WHILE condition DO commandes                {add_instruction(WHILE, 0);} 
      | WHILE condition DO commande                 {add_instruction(WHILE, 1);}
      | IF condition THEN commandes ELSE commandes  {add_instruction(ELSE, 00);}
      | IF condition THEN commandes ELSE commande   {add_instruction(ELSE, 01);}
      | IF condition THEN commande ELSE commandes   {add_instruction(ELSE, 10);}
      | IF condition THEN commande ELSE commande    {add_instruction(ELSE, 11);}
      | IF condition THEN commandes                 {add_instruction(IF, 0);}
      | IF condition THEN commande                  {add_instruction(IF, 1);}

condition: expr                         { }
         | condition EQQ condition      { add_instruction(EQQ); }
         | condition NOTEQ condition    { add_instruction(NOTEQ); }
         | condition INF condition      { add_instruction(INF); }
         | condition SUP condition      { add_instruction(SUP); }
         | condition INFEQ condition    { add_instruction(INFEQ); }
         | condition SUPEQ condition    { add_instruction(SUPEQ); }
         | condition AND condition      { add_instruction(AND); }
         | condition OR condition       { add_instruction(OR); }
         | OPEN condition CLOSE         { }

//Gestion des calculs + conditions
expr:  NUM              { add_instruction(NUM, $1);}
     | VAR              { add_instruction(VAR, -1, $1); }
     | OPEN expr CLOSE  { }
     | expr PLUS expr   { add_instruction(PLUS); }
     | expr MINUS expr  { add_instruction(MINUS); }
     | expr MULT expr   { add_instruction(MULT); }
     | expr DIV expr    { add_instruction(DIV); }
     | expr RESTE expr  { add_instruction(RESTE); }

%%

int defauterror(const char *s) {
    printf("%s\n", s);
    return 0;
}

//************************************************************************************************


bool switchexec(const instruction& exec) {
    switch (exec.code) {
    case MOVE:
        cout << "On avance !" << endl;
        break;
    case TURN:
        if (exec.val == 4) cout << "On tourne à gauche !" << endl;
        else if (exec.val == 6) cout << "On tourne à droite !" << endl;
        else {
            cout << "Erreur : Direction pour tourner manquante." << endl;
            throw; // Argument à préciser, on gère donc l'erreur
        }
        break;
    case TURNBACK:
        cout << "On se retourne !" << endl;
        break;
    case CARRY:
        if (exec.val) {
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
        if (exec.val) {
            cout << "On attrape !" << endl;
        }
        else {
            cout << "On lache !" << endl;
        }
        break;
    case PUSH:
        if (exec.val == 8) {
            cout << "On pousse !" << endl;
        }
        else if (exec.val == 2) {
            cout << "On tire !" << endl;
        }
        break;
    default:
        cout << "Erreur : Instruction executable inconnue !" << endl;
        return true;
    }
    return false;
}

void switchcalc(stack<int>& Pile, const instruction& aCalc, int& tmp) {
    // On fournit tmp en entrée pour éviter une redéclaration successive
    switch (aCalc.code) {
    case NUM:
        Pile.push(aCalc.val);
        break;
    case VAR:
        try {
            Pile.push(variables.at(aCalc.str));
        }
        catch (...) {
            cout << "Erreur : Variable '" << aCalc.str << "'utilisée mais jamais initialisée." << endl;
            throw;
        }
        break;
    case PLUS:
        tmp = Pile.top();
        Pile.pop();
        tmp += Pile.top();
        Pile.pop();
        Pile.push(tmp);
        break;
    case MINUS:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() - tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case MULT:
        tmp = Pile.top();
        Pile.pop();
        tmp *= Pile.top();
        Pile.pop();
        Pile.push(tmp);
        break;
    case DIV:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() / tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case RESTE:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() % tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    default:
        cout << "Erreur : Caractère invalide lors d'un calcul ou d'une condition.";
    }
}

void switchcondi(stack<int>& Pile, const instruction& aCalc, int& tmp) {
    // On fournit tmp en entrée pour éviter une redéclaration successive
    switch (aCalc.code) {
    case EQQ:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() == tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case NOTEQ:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() != tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case INF:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() < tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case SUP:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() > tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case INFEQ:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() <= tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case SUPEQ:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() >= tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case AND:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() && tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    case OR:
        tmp = Pile.top();
        Pile.pop();
        tmp = Pile.top() || tmp;
        Pile.pop();
        Pile.push(tmp);
        break;
    default:
        switchcalc(Pile, aCalc, tmp);
    }
}

int condiVector(const vector<instruction>& Vecteur) {
    stack<int> Pile;
    int tmp;
    for (unsigned int i = 0; i < Vecteur.size(); i++) {
        switchcondi(Pile, Vecteur[i], tmp);
    }
    if (Pile.size() != 1) {
        cout << "Erreur : Expression invalide lors d'un calcul de condition." << endl;
        throw;
    }
    else return Pile.top();
}

//---// Changer l'input en retirant le dernier caractère avant dans la fonction principale
//Pour DO : En partant de la fin, après condition sois CLOSE sois instruction seule
//Pour les autres : Dernier == CLOSE ou instruction seule
bool boucleVector(const vector<instruction>& instruct, vector<instruction>& BoucleVec, int& j, int& k, int debut = -1) {
    if (debut == -1) debut = instruct.size() - 1;
    bool parenthese = false;
    for (int nb = 0, i = debut; i >= 0; i--) {
        if (instruct[i].code == CLOSE) {
            nb++;
            if (!parenthese) j = i;
            parenthese = true;
        }
        if (instruct[i].code == OPEN) nb--;
        if (nb == 0 && parenthese) {
            k = i;
            BoucleVec = vector<instruction>(instruct.begin() + k + 1, instruct.begin() + j);
            return true;
        }
    }
    return false;//En fin de programme, j = CLOSE, k = OPEN
}

int getPreInstructionIdx(const vector<instruction>& instruct, const int& debut) {
    for (int i = debut - 1; i >= 0; i--) if (!(instruct[i].code >= EQQ && instruct[i].code <= RESTE)) {
        return i + 1; //Si pas calculable en condition
    }
    return 0;
}

void Analyseinstruction(const vector<instruction>& instruct){
    if (instruct.size() > 0) { // Sécurité
        // Si il s'agit d'un block d'instruction type boucle ou condition :
        if (instruct[instruct.size() - 1].code >= DO && instruct[instruct.size() - 1].code <= ELSE) {
            bool erreur = true; 
            vector<instruction> ConditionVec;
            int j, k;
            //Remplacer par un switch a la fin si il y a pas besoin d'autre switch imbriqué
            if (instruct[instruct.size() - 1].code == DO) {
                vector<instruction> BoucleVec;
                // On doit obliger les parenthèse sinon ça ne marche pas sur les instructions a plusieurs caractères
                if (boucleVector(instruct, BoucleVec, j, k)) { // On continue uniquement si on a réussit à déterminer le contenu de la boucle
                    j++; // On passe au début de la condition
                    while (j < (int)(instruct.size()) - 1) {
                        ConditionVec.push_back(instruct[j]);
                        j++;
                    }
                    if (ConditionVec.size() > 0) {
                        // On réexécute l'analyse pour les instructions situées avant le for
                        Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + k));
                        for (j = 0; j < condiVector(ConditionVec); j++) Analyseinstruction(BoucleVec);
                            // On calcule juste le résultat car il s'agit d'une expression désignant le nombre d'itération
                            // On recalcule à chaque fois car la valeur d'une variable nécessaire au calcul peut etre modifiée au cours de l'execution
                        erreur = false;
                    }
                }
            }
            else if (instruct[instruct.size() - 1].code == WHILE) {
                vector<instruction> BoucleVec; 
                // On doit obliger les parenthèse sinon ça ne marche pas sur les instructions a plusieurs caractères
                if (boucleVector(instruct, BoucleVec, j, k)) {
                    // On réexécute l'analyse pour les instructions situées avant le while
                    j = getPreInstructionIdx(instruct, k);
                    Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + j));
                    // On enregistre le vecteur correspondant à la condition puis on execute notre while
                    ConditionVec = vector<instruction>(instruct.begin() + j, instruct.begin() + k);
                    while (condiVector(ConditionVec)) Analyseinstruction(BoucleVec);
                    erreur = false;
                }
            }
            else if (instruct[instruct.size() - 1].code == IF) {
                vector<instruction> BoucleVec;
                // On doit obliger les parenthèse sinon ça ne marche pas sur les instructions a plusieurs caractères
                if (boucleVector(instruct, BoucleVec, j, k)) {
                    j = getPreInstructionIdx(instruct, k);
                    // On réexécute l'analyse pour les instructions situées avant le while
                    Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + j));
                    ConditionVec = vector<instruction>(instruct.begin() + j, instruct.begin() + k);
                    if (condiVector(ConditionVec)) Analyseinstruction(BoucleVec);
                    erreur = false;
                }
            }
            else if (instruct[instruct.size() - 1].code == ELSE) {
                vector<instruction> BoucleVecElse, BoucleVecIf;
                int l, m;
                // On doit obliger les parenthèse sinon ça ne marche pas sur les instructions a plusieurs caractères
                if (boucleVector(instruct, BoucleVecElse, j, k)) {
                    if (boucleVector(instruct, BoucleVecIf, l, m, k - 1)) {
                        j = getPreInstructionIdx(instruct, m);
                        // On réexécute l'analyse pour les instructions situées avant le while
                        Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + j));
                        ConditionVec = vector<instruction>(instruct.begin() + j, instruct.begin() + m);
                        if (condiVector(ConditionVec)) Analyseinstruction(BoucleVecIf);
                        else Analyseinstruction(BoucleVecElse);
                        erreur = false;
                    }
                }
            }
            if (erreur) {
                cout << "Erreur : Instruction de block mal utilisée." << endl;
                throw;
            }
        } // Si il s'agit d'une commande simple à exécuter : on rappel la fonction une fois traité en en retirant le dernier element
        else if (instruct[instruct.size() - 1].code >= MOVE && instruct[instruct.size() - 1].code <= PUSH) {
            // On fait l'appel récursif avant d'executer le code afin d'executer dans le bon ordre
            Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + instruct.size() - 1));
            if(switchexec(instruct[instruct.size() - 1])){
                // Erreur lors de l'execution d'une commande
                throw;
            }
        }// Si il s'agit d'une assignation de variable
        else if (instruct[instruct.size() - 1].code == EQ) {
            if (instruct.size() > 1) {
                int j = getPreInstructionIdx(instruct, instruct.size() - 1);
                // On réexécute l'analyse pour les instructions situées avant l'assignation
                Analyseinstruction(vector<instruction>(instruct.begin(), instruct.begin() + j));
                variables[instruct[instruct.size() - 1].str] = condiVector(vector<instruction>(instruct.begin() + j, instruct.begin() + instruct.size() - 1));
            }
            else {
                cout << "Erreur : Assignation d'une variable incomplète." << endl;
                throw;
            }
        }
    }
}

int runProgram() {
    Analyseinstruction(instructions);
    cout << "finAnalyse" << endl;
    return 0;
}


