#include <iostream>
#include<string>
#include "Personnage.h"
#include "Arme.h"
#include "Magicien.h"
#include "Guerrier.h"

using namespace std;

int main()
{
    // Perso
    Personnage david("David","Baton",12);
    Guerrier goliath;
    Magicien marion("Marion","Pipette",13);

    david.afficherEtat();
    goliath.afficherEtat();
    marion.afficherEtat();

    //Combat
    goliath.frapperCommeUnSourdAvecUnMarteau(marion);
    marion.bouleDeFeu(david);
    marion.bouleDeGlace(goliath);

    cout << endl;
    cout << "Combien de manas va couter l'attaque magique de David?" << endl;
    int mana;
    cin >> mana;
    cout << "Combien de degats produira-t-elle?" << endl;
    int deg;
    cin >> deg;

    david.attaqueMagique(goliath,mana,deg);
    cout << endl;
    //temps mort
    david.afficherEtat();
    goliath.afficherEtat();
    marion.afficherEtat();


    return 0;
}

