#include "Duree.h"
#include <cmath>
#include <iostream>
#include <string>

using namespace std;

Duree::Duree(int heures, int minutes, int secondes) : m_heures(heures), m_minutes(minutes), m_secondes(secondes)
{
    if (m_secondes >= 60)
    {
        m_minutes += m_secondes/60;
        m_secondes = m_secondes%60;

    }
    if (m_minutes >= 60)
    {
        m_heures += m_minutes/60;
        m_minutes = m_minutes%60;

    }
}

void Duree::afficherTemps() const
{
    cout << "Heures: " << m_heures << ", minutes: " << m_minutes << ", secondes: " << m_secondes << endl;
}

bool Duree::estEgal(Duree const& b) const

{

    return (m_heures == b.m_heures && m_minutes == b.m_minutes && m_secondes == b.m_secondes);     //Teste si a.m_heure == b.m_heure etc.

}

bool operator==(Duree const& a, Duree const& b)
{
    return a.estEgal(b);

}

bool operator!=(Duree const& a, Duree const& b)
{
    return !(a==b); //On utilise l'opérateur == qu'on a défini précédemment !
}

bool operator<(Duree const& a, Duree const& b)

{

    return a.estPlusPetitQue(b);

}

bool Duree::estPlusPetitQue(Duree const& b) const
{
    if (m_heures < b.m_heures)   // Si les heures sont différentes
        return true;
    else if (m_heures == b.m_heures && m_minutes < b.m_minutes) //Si elles sont égales, on compare les minutes
        return true;
    else if (m_heures == b.m_heures && m_minutes == b.m_minutes && m_secondes < b.m_secondes) // Et si elles sont aussi égales, on compare les secondes
        return true;
    else              //Si tout est égal, alors l'objet n'est pas plus petit que b
        return false;
}
