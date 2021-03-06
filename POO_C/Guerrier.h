#ifndef GUERRIER_H_INCLUDED
#define GUERRIER_H_INCLUDED

#include <iostream>
#include <string>
#include "Personnage.h"


//Ne pas oublier d'inclure Personnage.h pour pouvoir en h�riter !



class Guerrier : public Personnage

//Signifie : cr�er une classe Guerrier qui h�rite de la classe Personnage

{
    public:
        Guerrier(std::string nomPerso = "Gerard", std::string nomArme = "Boulet", int degatsArme = 6);
        void frapperCommeUnSourdAvecUnMarteau(Personnage &cible);
        void afficherEtat() const;


};


#endif // GUERRIER_H_INCLUDED
