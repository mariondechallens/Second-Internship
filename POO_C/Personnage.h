#ifndef PERSONNAGE_H_INCLUDED
#define PERSONNAGE_H_INCLUDED
#include<string>
#include<iostream>
#include "Arme.h"

class Personnage
{   // methodes
    public:

    // constructeur
    Personnage(std::string nomPerso = "John", std::string nomArme = "Epee", int degatsArme = 10);
    Personnage(Personnage const& personnageACopier); // contructeur de copie
    ~Personnage(); //destructeur

    void recevoirDegats(int nbDegats);
    void attaquer(Personnage &cible);
    void boirePotionDeVie(int quantitePotion);
    void changerArme(std::string nomNouvelleArme, int degatsNouvelleArme);
    bool estVivant() const; // methode constante
    void afficherEtat() const;
    std::string getName() const;
    void attaqueMagique(Personnage &cible, int nbMana, int nbDegats);
    Personnage& operator=(Personnage const& personnageACopier);
    void perdreMana(int nbMana);
    void gelerMana(Personnage &cible, int nbMana);

    // attributs de la classe
    protected:

    int m_vie;
    int m_mana;
    std::string m_nom;
    Arme *m_arme; // Arme de la classe Arme avec pointeur

};




#endif // PERSONNAGE_H_INCLUDED
