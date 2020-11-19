#include <SFML/Graphics.hpp>
#include <fstream>
#include <string>
#include <iostream>
#include <stdlib.h>
#include <cstdlib>
using namespace std;


/**
 * \brief Fonction d'analyse utilisant Flex&Bison
 * \param INPUT Chaine de caractère comprenant soit le lien vers un fichier .txt à lire soit un texte à analyser directement
 * \return Renvoi le résultat de la lecture, si = -1 alors il y a une erreur
 */

int analyse(string INPUT)
{
    ifstream file("analyse"); // Lecture des commandes de compilation, similaire au MakeFile
    string strtmp; // On utilise 2 variables tampon pour executer la dernière ligne à part et ainsi rajouter les arguments
    string str = "";
    while (getline(file, strtmp))
    {
        if (str!="") system(str.c_str()); // On execute les différentes commandes 
        str = strtmp;
    }
    return system((str + " " + INPUT).c_str()); // et on renvoi la valeur de sortie de l'analyse
}

int main()
{

    cout << "Valeur : " << analyse("5+1;")  << endl;

    sf::RenderWindow window(sf::VideoMode(200, 200), "SFML works!");
    sf::CircleShape shape(100.f);
    shape.setFillColor(sf::Color::Green);

    while (window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if (event.type == sf::Event::Closed)
                window.close();
        }

        window.clear();
        window.draw(shape);
        window.display();
    }

    return 0;
}