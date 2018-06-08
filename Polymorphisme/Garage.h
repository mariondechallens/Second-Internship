#ifndef GARAGE_H_INCLUDED
#define GARAGE_H_INCLUDED
#include <vector>

class Vehicule //classe abstraite, ne crée pas d'objets
{

    public:

    Vehicule(int prix = 100, int annee = 2000);
    virtual void affiche() const;  //Affiche une description du Vehicule
    virtual ~Vehicule();
    int getDate();
    virtual int nbrRoues() const = 0; // ne renvoie rien pour Vehicule virtuelle pure
    static void maMethode();
    static int nombreVehicules();

    protected:

    int m_prix;  //Chaque véhicule a un prix
    int m_annee; // annee de fabrication
    static int compteur; //attribut statique
};


class Voiture : public Vehicule //Une Voiture EST UN Vehicule

{

    public:

    Voiture(int prix = 200, int portes = 5,int annee = 2000);
    virtual void affiche() const;
    virtual ~Voiture();
    virtual int nbrRoues() const;

    private:

    int m_portes;  //Le nombre de portes de la voiture

};


class Moto : public Vehicule  //Une Moto EST UN Vehicule

{

    public:

    Moto(int prix = 150, double vitesse = 200,int annee = 2000);
    virtual void affiche() const;
    virtual ~Moto();
    virtual int nbrRoues() const;



    private:

    double m_vitesse;  //La vitesse maximale de la moto

};

class Camion : public Vehicule  //Une Moto EST UN Vehicule

{

    public:

    Camion(int prix = 500, int poids = 200,int annee = 2000);
    virtual void affiche() const;
    virtual ~Camion();
    int nbrRoues() const;



    private:

    int m_poids;  //La vitesse maximale de la moto

};

class Garage
{

    public:
    Garage();
    void ajouterVehicule(Vehicule* VehiculeAjoute);
    void retirerVehicule(int indiceVehicule);
    void afficherInfos();
    void nbrRoues() const;
    static int nbrVehiculesGarage();

    private:

    static int vehiculeGarage;
    std::vector<Vehicule*> m_liste;  //La vitesse maximale de la moto

};

int taille (Garage liste);

#endif // GARAGE_H_INCLUDED
