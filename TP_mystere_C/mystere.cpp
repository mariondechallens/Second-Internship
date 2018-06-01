#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cmath>
#include "mystere.h"

using namespace std;

std::string melange(std::string mot)
{
    int nbAleatoire(0);
    srand(time(0));

    string motmel;
    motmel=mot;
    while (mot.size()> 0)
    {
        for (unsigned int i(0); i< motmel.size(); i++)
        {
            nbAleatoire = rand() % mot.size();
            motmel[i] = mot[nbAleatoire];
            mot.erase(nbAleatoire,1);
        }

    }
    return(motmel);
}
