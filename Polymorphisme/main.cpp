#include <iostream>
#include "Garage.h"
#include <vector>

using namespace std;

void presenter(Vehicule const& v)
{
    v.affiche();
}
int main()
{
    Garage liste;
    liste.ajouterVehicule(new Moto(2000,212.5,2002));
    liste.ajouterVehicule(new Voiture(2800,3,2003));
    liste.ajouterVehicule(new Camion(20000,200,2004));

    liste.afficherInfos();
    cout << "Il y a "<< Vehicule::nombreVehicules() << " vehicules crees."<< endl;
    cout << "Il y a "<< Garage::nbrVehiculesGarage() << " vehicules dans le garage."<< endl;
    cout << endl;

    liste.retirerVehicule(1);
    cout << "Il y a "<< Vehicule::nombreVehicules() << " vehicules crees."<< endl;
    cout << "Il y a "<< Garage::nbrVehiculesGarage() << " vehicules dans le garage."<< endl;


    liste.ajouterVehicule(new Moto);


    cout << endl;
    liste.afficherInfos();

    cout << endl;
    liste.nbrRoues();

    Voiture vv;
    cout << "Voiture: " << vv.nbrRoues() << endl;

    Moto* point(0); // pointeur vers une moto
    point = new Moto(500,5);
    cout << "Moto: " << point->nbrRoues() << endl;

    Vehicule::maMethode(); // methode statique
    cout << endl;
    cout << "Il y a "<< Vehicule::nombreVehicules() << " vehicules crees."<< endl;
    cout << "Il y a "<< Garage::nbrVehiculesGarage() << " vehicules dans le garage."<< endl;



    return 0;
}
