#ifndef MAGICIEN_H_INCLUDED
#define MAGICIEN_H_INCLUDED

#include <iostream>
#include <string>
#include "Personnage.h"

class Magicien : public Personnage // herite de la classe Personnage
{
    public:
        Magicien(std::string nomPerso = "Maiev", std::string nomArme = "Ciseaux", int degatsArme = 2);
        void bouleDeFeu(Personnage &cible);
        void bouleDeGlace(Personnage &cible);
        void afficherEtat() const;

    private:
        int m_manaMage;
};


#endif // MAGICIEN_H_INCLUDED
