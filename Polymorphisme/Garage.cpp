#include "Garage.h"
#include<string>
#include<iostream>
#include <vector>

using namespace std;

void Vehicule::affiche() const

{

    cout << "Ceci est un vehicule coutant " << m_prix << " euros, datant de " << m_annee << "." << endl;

}


void Voiture::affiche() const

{
    Vehicule::affiche();
    cout << "Plus precisement, une voiture comptant " << m_portes << " portes." << endl;

}


void Moto::affiche() const

{
    Vehicule::affiche();
    cout << "Plus precisement, une moto a la vitesse maximale de "<< m_vitesse << " km/h." << endl;

}

void Camion::affiche() const

{
    Vehicule::affiche();
    cout << "Plus precisement, un camion pouvant transporter " << m_poids << " kg de cargaison." << endl;

}

Vehicule::Vehicule(int prix, int annee) : m_prix(prix), m_annee(annee)
{

}

Vehicule::~Vehicule()
 {

 }

 Voiture::Voiture(int prix, int portes,int annee) : Vehicule(prix,annee), m_portes(portes)
{

}

Voiture::~Voiture()
 {

 }

 Moto::Moto(int prix, double vitesse,int annee) : Vehicule(prix,annee), m_vitesse(vitesse)

{

}

Moto::~Moto()
{

}


 Camion::Camion(int prix, int poids,int annee) : Vehicule(prix,annee), m_poids(poids)
{

}

Camion::~Camion()
{

}

int Vehicule::getDate()
{
    return m_annee;
}

void Garage::ajouterVehicule(Vehicule* VehiculeAjoute)
{
    m_liste.push_back(VehiculeAjoute);
}

void Garage::retirerVehicule(int indiceVehicule)
{ // retire l'element dincie indiceVehicule
    m_liste.erase(m_liste.begin() + indiceVehicule);
}

Garage::Garage()
{
}


void Garage::afficherInfos()
{
    for (unsigned int i(0); i < m_liste.size(); i++)
    {
        m_liste[i]->affiche();
    }
}

void Garage::nbrRoues() const
{
    for (unsigned int i(0); i < m_liste.size(); i++)
    {
        cout << m_liste[i]->nbrRoues() << endl;
    }
}

int Camion::nbrRoues() const
{
    return 4;
}

int Voiture::nbrRoues() const
{
    return 4;
}

int Moto::nbrRoues() const
{
    return 2;
}


