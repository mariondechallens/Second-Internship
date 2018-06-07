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

    liste.retirerVehicule(1);
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


    return 0;
}
