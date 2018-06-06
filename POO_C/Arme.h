#ifndef ARME_H_INCLUDED
#define ARME_H_INCLUDED
#include<iostream>
#include<string>

class Arme
{
    public:

    Arme(std::string nom = "Epee", int degats = 10);
    void changer(std::string nom, int degats);
    void afficher() const;
    int getDegats() const;

    private:

    std::string m_nom;
    int m_degats;
};



#endif // ARME_H_INCLUDED
