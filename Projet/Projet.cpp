#include <SFML/Graphics.hpp>
#include <fstream>
#include <string>
#include <iostream>
#include <stdlib.h>
#include <cstdlib>
using namespace std;


/**
 * \brief Fonction de lecture du fichier analyse.txt dans FlexBison 
 * \return Renvoi le résultat de la lecture, si = -1 alors il y a une erreur
 */

int analyse()
{
    ifstream file("analyse"); // Lecture des commandes de compilation
    string str;
    int value = -1;
    while (getline(file, str)) value = system(str.c_str()); // On execute les différentes commandes et on enregistre la dernière valeur retournée (valeur de sortie de l'analyse)
    return value;
}

int main()
{

    cout << "Valeur : " << analyse()  << endl;

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