#include<string>
#include<iostream>
#include "Guerrier.h"
#include "Personnage.h"

using namespace std;

void Guerrier::afficherEtat() const
{
    cout << "Je suis un guerrier !" << endl;
    Personnage::afficherEtat();
}

void Guerrier::frapperCommeUnSourdAvecUnMarteau(Personnage &cible)
{
    cout << m_nom << " frappe comme un sourd " << cible.getName() << endl;
    cible.recevoirDegats(60);
}

Guerrier::Guerrier(string nomPerso, string nomArme, int degatsArme) : Personnage(nomPerso,nomArme,degatsArme)
{

}
