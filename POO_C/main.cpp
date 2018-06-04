#include <iostream>
#include<string>
#include "Personnage.h"
#include "Arme.h"

using namespace std;

int main()
{
    // Perso
    Personnage david("David"), goliath("Goliath","Sabre", 15), marion("Marion", "scalpel",5);

    //Combat
    goliath.attaquer(david);
    david.boirePotionDeVie(15);
    goliath.attaquer(marion);
    david.attaquer(goliath);
    goliath.changerArme("Mega hache",40);
    goliath.attaquer(david);
    marion.attaquer(goliath);
    marion.changerArme("Triple scalpel",15);

    cout << endl;
    cout << "Combien de mana va couter l'attaque magique de David?" << endl;
    int mana;
    cin >> mana;
    cout << "Combien de degats produira-t-elle?" << endl;
    int deg;
    cin >> deg;

    david.attaqueMagique(goliath,mana,deg);
    cout << endl;
    //temps mort
    cout << david.getName() << endl;
    david.afficherEtat();
    cout << goliath.getName() << endl;
    goliath.afficherEtat();
    cout << marion.getName() << endl;
    marion.afficherEtat();


    return 0;
}

