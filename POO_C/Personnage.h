#ifndef PERSONNAGE_H_INCLUDED
#define PERSONNAGE_H_INCLUDED
#include<string>
#include<iostream>
#include "Arme.h"

class Personnage
{   // methodes
    public:

    Personnage();
    Personnage(std::string nomPerso);// constructeur
    Personnage(std::string nomPerso, std::string nomArme, int degatsArme);
    Personnage(std::string nomArme, int degatsArme);
    ~Personnage(); //destructeur
    void recevoirDegats(int nbDegats);
    void attaquer(Personnage &cible);
    void boirePotionDeVie(int quantitePotion);
    void changerArme(std::string nomNouvelleArme, int degatsNouvelleArme);
    bool estVivant() const; // methode constante
    void afficherEtat() const;
    std::string getName() const;
    void attaqueMagique(Personnage &cible, int nbMana, int nbDegats);

    // attributs de la classe
    private:

    int m_vie;
    int m_mana;
    std::string m_nom;
    Arme m_arme; // Arme de la classe Arme

};




#endif // PERSONNAGE_H_INCLUDED
