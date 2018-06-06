#include<string>
#include "Personnage.h"

using namespace std;

void Personnage::recevoirDegats(int nbDegats)
{
    m_vie-=nbDegats;
    if (m_vie<0)
    {
        m_vie = 0;
    }
    cout << m_nom << " recoit " << nbDegats << " points de degats." << endl;
}
void Personnage::perdreMana(int nbMana)
{
    m_mana-=nbMana;
    if (m_mana<0)
    {
        m_mana = 0;
    }
    cout << m_nom << " perd " << nbMana << " manas." << endl;
}

void Personnage::attaquer(Personnage &cible)
{
    cout << m_nom << " attaque " << cible.getName() << endl;
    cible.recevoirDegats(m_arme->getDegats());
}
void Personnage::gelerMana(Personnage &cible, int nbMana)
{
    cout << m_nom << " gele " << nbMana << " manas de "<< cible.getName() << endl;

    cible.perdreMana(nbMana);
}

void Personnage::boirePotionDeVie(int quantitePotion)
{
    m_vie+=quantitePotion;
    if (m_vie > 100)
    {
        m_vie = 100;
    }
    cout << m_nom << " boit une potion de " << quantitePotion << " points de vie." << endl;
}

void Personnage::changerArme(string nomNouvelleArme, int degatsNouvelleArme)
{
    m_arme->changer(nomNouvelleArme,degatsNouvelleArme); // methode de la classe Arme
    cout << m_nom << " change d'arme." << endl;
}


bool Personnage::estVivant() const
{
    return m_vie > 0;
}



Personnage::Personnage(string nomPerso, string nomArme, int degatsArme) : m_nom(nomPerso), m_vie(100),m_mana(100), m_arme(0)  //constructeur
{
    m_arme = new Arme(nomArme,degatsArme);
}

Personnage::~Personnage()
{
    delete m_arme;
}

void Personnage::afficherEtat() const
{
    cout << "Nom: " << m_nom << endl;
    cout << "Vie: " << m_vie << endl;
    cout << "Mana: " << m_mana << endl;
    m_arme->afficher();
    cout << endl;
}

string Personnage::getName() const
{
    return m_nom;
}

void Personnage::attaqueMagique(Personnage &cible, int nbMana, int nbDegats)
{
    cout << m_nom << " fait une attaque magique qui lui coute " << nbMana << " manas." << endl;
    m_mana-=nbMana;
    if (m_mana < 0 )
    {
        m_mana=0;
    }

    cible.recevoirDegats(nbDegats);

}

Personnage::Personnage(Personnage const& personnageACopier) : m_vie(personnageACopier.m_vie), m_mana(personnageACopier.m_mana),m_arme(0)
{
    m_arme =  new Arme(*(personnageACopier.m_arme));
}

Personnage& Personnage::operator=(Personnage const& personnageACopier)
{
    if(this != &personnageACopier)
        //objet actuel pas celui de l'argument (on copie pas la meme chose)
    {
        m_vie = personnageACopier.m_vie;
        m_mana = personnageACopier.m_mana;
        delete m_arme; //supprimer l'ancienne arme!!
        m_arme =  new Arme(*(personnageACopier.m_arme));

    }
    return *this; // on retourne lobjet
}


