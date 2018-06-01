#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include "mystere.h"
#include<fstream>

using namespace std;

int main()
{
    string rep("o");
    unsigned int essai(2); // trois essais
    unsigned int score(0);
    ifstream monDico("C:/Users/Marion/Documents/Stage/dico.txt");
    do
    {
        // piocher dans un dictionnaire

        if (monDico)
        {
            string mot;
            getline(monDico,mot);
            string motC(mot); // pas modifie

            // melange des lettres du mot

            mot = melange(mot);
            // Trouver le mot

            cout << "Quel est le mot? " << mot << endl;
            string mot2;
            cin >> mot2;
            while ((mot2!=motC) & (essai > 0))
            {
                cout << "Ce n'est pas le bon mot, recommence!" << endl;
                cout << "Quel est le mot? " << mot << endl;
                string mot3;
                cin >> mot3;
                mot2 = mot3;
                essai -= 1;
                cout << "Il reste " << essai << " tentative(s)." << endl;
            }
            if ( essai > 0)
            {
                cout << "Bravo, vous avez trouve le mot!" << endl;
                score += 1;
            }
            else
            {
                cout << "Rate! Le mot etait " << motC << endl;
            }

            essai = 2;
            cout << "Nouvelle Partie? (o/n)" << endl;
            string rep2;
            cin >> rep2;
            rep = rep2;
        }
    }
    while (rep == "o");
    cout << "Vous avez reussi " << score << " partie(s)." << endl;

    return 0;
}
