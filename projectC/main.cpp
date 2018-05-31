#include <iostream> // inclut la bibliotheque iostream
#include <cmath> // biblio de math
#include<vector>
#include<fstream>
// #include "math.h"

using namespace std; // indique l espace de nom utilisé


int main() // un pg possede tjrs une fonction main ie code principal
{   // flux pour ecrire dans le fichier
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

    return 0;

}

