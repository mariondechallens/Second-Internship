#include "math.h"
#include <iostream>
#include <cmath>

using namespace std;

int func( int nb)
{
    nb+=5;
    return nb;
}


int bfor()
{
    for (int k(0); k < 50 ; k+=5)
    {
        cout << k << endl;
    }
    return(0);
}


// fonction qui ne revoie rien
void ech(double& a, double& b) // echange la valeur de a et b
{
    double temporaire(a); // ref à a
    a = b;
    b = temporaire;
}
