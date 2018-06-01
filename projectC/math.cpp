#include "math.h"
#include <iostream>
#include <cmath>
#include<fstream>

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

void fich()
{
    // flux pour ecrire dans le fichier
    ifstream monFlux("C:/Users/Marion/Documents/Stage/texte.txt");
    // si le fochier n existe pas il le cree
    string const nomfi("C:/Users/Marion/Documents/Stage/texte2.txt");
    ofstream monFlux2(nomfi.c_str(), ios::app); // ecrire a la fin
    if(monFlux2) // tester si tout va bien
    {
        monFlux2.seekp(10, ios::end);
        monFlux2 << "hello, j'ecris a la fin du fichier en C++!" << endl;
        monFlux2 << 5 << endl;
        int position = monFlux2.tellp();
        cout << "Curseur est au carac numero " << position << endl;
    }
    else
    {
        cout << " Attention il y a un pb!" << endl;
    }

    if (monFlux)
    {
      string line;
      while(getline(monFlux,line))
      {
          cout << line << endl;
      }
    }
    else
    {
        cout << "Erreur" << endl;
    }
    monFlux.seekg(0,ios::end);
    int tailleF;
    tailleF = monFlux.tellg();
    cout << "La taille du fichier est " << tailleF << " octets." << endl;

}

void pointeur()
{
    int *point(0);
    point = new int;

    cout << "Age: " << endl;
    cin >> *point;
    cout << "Tu as " << *point << "an(s)" << endl;
    delete point;
    point = 0;
}
