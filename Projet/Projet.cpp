#include <SFML/Graphics.hpp>
#include <fstream>
#include <string>
#include <iostream>
#include <stdlib.h>
#include <cstdlib>
#include "Analyses/test/test.tab.h"
#include "Analyses/defaut/defaut.tab.h"
using namespace std;

#ifndef YY_TYPEDEF_YY_BUFFER_STATE
#define YY_TYPEDEF_YY_BUFFER_STATE
typedef struct yy_buffer_state* YY_BUFFER_STATE;
#endif

struct yy_buffer_state;
extern YY_BUFFER_STATE test_scan_string(const char* yy_str);
extern FILE* defautin;

void analyseString(string INPUT) {
    test_scan_string(INPUT.c_str());
    testparse();
}

void analyseFile(string NOM) {
    FILE* file;
    fopen_s(&file, NOM.c_str(), "r");
    if (file != NULL)   defautin = file;
    defautparse();
}

int main()
{
        // * Analyse FlexBison Test :

    //createanalyse("test");
    //cout << "Valeur : " << analyse("5+1;", "test")  << endl;

    analyseFile("test.txt");
    analyseString("5+5;");

    cout << "fin tesst" << endl;

        // * SFML Test :

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