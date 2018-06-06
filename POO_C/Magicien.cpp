#include<string>
#include<iostream>
#include "Magicien.h"
#include "Personnage.h"
using namespace std;

Magicien::Magicien(string nomPerso, string nomArme, int degatsArme) : Personnage(nomPerso,nomArme,degatsArme), m_manaMage(200)
{

}

void Magicien::afficherEtat() const
{
    cout << "Je suis un mage avec " << m_manaMage << " manas pour mes sorts!" << endl;
    Personnage::afficherEtat();
}

void Magicien::bouleDeFeu(Personnage &cible)
{
    cout << m_nom << " envoie une boule de feu qui coute 10 manas." << endl;
    m_manaMage-=10;
    if (m_manaMage < 0 )
    {
        m_manaMage=0;
    }
    cible.recevoirDegats(5);
}

void Magicien::bouleDeGlace(Personnage &cible)
{
    cout << m_nom << " envoie une boule de glace qui coute 20 manas." << endl;
    m_manaMage-=20;
    if (m_manaMage < 0 )
    {
        m_manaMage=0;
    }
    cible.perdreMana(10);
}
