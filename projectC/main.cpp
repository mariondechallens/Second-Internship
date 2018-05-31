#include <iostream> // inclut la bibliotheque iostream
#include <cmath> // biblio de math
#include "math.h"

using namespace std; // indique l espace de nom utilisé

// prototype avec valeurs par defaut
int nombreDeSecondes(int heures, int minutes  = 0 , int secondes = 0);

int main() // un pg possede tjrs une fonction main ie code principal
{
    bfor();
    cout << nombreDeSecondes(1,0,20) << endl;
    cout << func();
    return 0;

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

