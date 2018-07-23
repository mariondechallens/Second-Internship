
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <iostream>



using namespace std;

int main()
{
    srand(time(NULL));
    const int a = 1;

    bool encore = true;
    int joueur = 0;
    int nbMystere = 0;
    int niv = 0;
    string partie;



    while (encore)
    {
        cout << "Combien de joueurs? 1/2" << endl;
        cin >> joueur;

        if (joueur == 1)
        {
            int b = 10;
            cout << "Quel niveau de difficulte ? 1/2/3" << endl;
            cout << "1. Entre 1 et 10" << endl;
            cout << "2. Entre 1 et 50" << endl;
            cout << "3. Entre 1 et 100" << endl;
            cin >> niv;

            switch(niv)
            {
            case 1:
                b = 10;
                break;
            case 2:
                b = 50;
                break;
            case 3:
                b = 100;
                break;
            default:
                break;
            }
            nbMystere = rand()%(b-a) +a;
        }

        if (joueur ==2)
        {
            cout << "Un joueur donne un nombre mystere: " << endl;
            cin >> nbMystere;
        }

        int nbDonne;
        int nbCoups = 1;
        cout << "Essayez de deviner le nombre" << endl;
        cin >> nbDonne;

        while (nbDonne != nbMystere)
        {
            if (nbDonne > nbMystere)
                cout << "Le nombre est plus faible." << endl;
            if (nbDonne < nbMystere)
                cout << "Le nombre est plus grand."<< endl;

            cin >> nbDonne;
            nbCoups++;
        }

        cout << "Bravo, vous avez trouve le nombre en " << nbCoups << " essai(s)!" <<endl;
        encore = false;
        cout << "Une autre partie ? o/n" << endl;
        cin >> partie;
        if (partie == "o")
            encore = true;


    }

    return 0;
}
