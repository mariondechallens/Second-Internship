#include "math.h"
#include <iostream>
#include <cmath>

using namespace std;


// fonction qui ne revoie rien
void ech(double& a, double& b) // echange la valeur de a et b
{
    double temporaire(a); // ref à a
    a = b;
    b = temporaire;
}


// definition fonction
int nombreDeSecondes(int heures, int minutes, int secondes)

{

    int total = 0;


    total = heures * 60 * 60;

    total += minutes * 60;

    total += secondes;


    return total;

}

void tab( double tableau[], int taille) // tableau statique
{
    double moy(0);
    for (int k(0); k < taille ; k++ )
    {
        moy += tableau[k];
    }
    moy /= taille;
    cout << "La moyenne du tableau est: " << moy << endl;
}
void nom()
{
    cout << "Quel est ton prenom?" << endl;
    string pnom;
    cin >> pnom;
    cout << "et ton nom?" << endl;
    string nom;
    cin >> nom;
    pnom += " ";
    pnom += nom;
    cout << "Cela donne " << pnom << endl;
}
