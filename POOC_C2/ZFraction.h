#ifndef ZFRACTION_H_INCLUDED
#define ZFRACTION_H_INCLUDED
#include<iostream>
#include<cmath>

class ZFraction
{
public:
    ZFraction(int numerateur = 0, int denominateur = 1);
    bool estEgalA(ZFraction const& b) const;
    bool estPlusPetitQue(ZFraction const& b) const;
    void simplifier();
    int numerateur() const;
    int denominateur() const;
    double nombreReel() const;
    void convertir();
    ZFraction& valeurAbs();
    ZFraction& racineCarree();
    ZFraction& puissance(int puiss);


    ZFraction& operator+=(const ZFraction& b);
    ZFraction& operator-=(const ZFraction& b);
    ZFraction& operator*=(const ZFraction& b);
    ZFraction& operator/=(const ZFraction& b);


private:
    int m_numerateur;
    int m_denominateur;
    void afficher(std::ostream &flux) const;

    friend std::ostream& operator<<( std::ostream &flux, ZFraction const& frac);
    friend bool operator==(ZFraction const& a, ZFraction const& b);
    friend bool operator<(ZFraction const& a, ZFraction const& b);
};


bool operator!=(ZFraction const& a, ZFraction const& b);
bool operator>(ZFraction const& a, ZFraction const& b);
bool operator>=(ZFraction const& a, ZFraction const& b);
bool operator<=(ZFraction const& a, ZFraction const& b);

ZFraction operator-(ZFraction const& a);
ZFraction operator+(ZFraction const& a, ZFraction const& b);
ZFraction operator-(ZFraction const& a, ZFraction const& b);
ZFraction operator*(ZFraction const& a, ZFraction const& b);
ZFraction operator/(ZFraction const& a, ZFraction const& b);

int PGCD(int a, int b);
ZFraction valeurAbs(ZFraction const& a);
ZFraction racineCarree(ZFraction const& a);
ZFraction puissance(ZFraction const& a, int puiss);


#endif // ZFRACTION_H_INCLUDED
