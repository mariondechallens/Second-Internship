#ifndef DUREE_H_INCLUDED
#define DUREE_H_INCLUDED

class Duree
{
    public:

    Duree(int heures = 0, int minutes = 0, int secondes = 0);
    void afficherTemps() const;
    bool estEgal(Duree const& b) const;

    bool estPlusPetitQue(Duree const& b) const;


    private:

    int m_heures;
    int m_minutes;
    int m_secondes;
};

bool operator==(Duree const& a, Duree const& b); // comparaison ==
bool operator!=(Duree const& a, Duree const& b);
bool operator<(Duree const& a, Duree const& b);

#endif // DUREE_H_INCLUDED
