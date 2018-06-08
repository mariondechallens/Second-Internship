#include "ZFraction.h"
#include<cmath>
#include<string>
#include<iostream>

using namespace std;
//constructeur

ZFraction::ZFraction (int numerateur, int denominateur) : m_numerateur(numerateur), m_denominateur(denominateur)
{
    simplifier();
    convertir();

}

void ZFraction::simplifier()
{
    int pgcd;
    pgcd = PGCD(m_numerateur,m_denominateur);
    if (pgcd != 1)
    {
        m_numerateur = m_numerateur/pgcd;
        m_denominateur = m_denominateur/pgcd;
    }
}



bool operator==(ZFraction const& a, ZFraction const& b)
{
    return(a.m_numerateur == b.m_numerateur && a.m_denominateur == b.m_denominateur);
}

bool operator!=(ZFraction const& a, ZFraction const& b)
{
    return !(a==b);
}

int PGCD(int a, int b)
{
    while(b!=0)
    {
        int c=a%b;
        a=b;
        b=c;
    }
    return a;
}

bool operator<(ZFraction const& a, ZFraction const& b)
{

    return(a.m_numerateur*b.m_denominateur < b.m_numerateur*a.m_denominateur);

}

bool operator>(ZFraction const& a, ZFraction const& b)
{
    return (b<a);
}

bool operator>=(ZFraction const& a, ZFraction const& b)
{
    return ((a>b) + (a==b));
}

bool operator<=(ZFraction const& a, ZFraction const& b)
{
    return ((a<b) + (a==b));
}

ZFraction& ZFraction::operator+=(const ZFraction& b)
{
    int pgcd;
    pgcd = PGCD(m_denominateur,b.m_denominateur);

    //mise sous denominateur commun
    m_numerateur=m_numerateur*b.m_denominateur/pgcd + b.m_numerateur*m_denominateur/pgcd;
    m_denominateur*=b.m_denominateur/pgcd;

    simplifier();
    convertir();
    return *this; //retourne une fraction
}

ZFraction operator+(ZFraction const& a, ZFraction const& b)
{
    ZFraction copie(a); //constructeur de copie pour pas modifier les entrees
    copie += b;
    return copie;
}

ZFraction& ZFraction::operator-=(const ZFraction& b)
{
    int pgcd;
    pgcd = PGCD(m_denominateur,b.m_denominateur);

    //mise sous denominateur commun
    m_numerateur=m_numerateur*b.m_denominateur/pgcd - b.m_numerateur*m_denominateur/pgcd;
    m_denominateur*=b.m_denominateur/pgcd;

    simplifier();
    convertir();
    return *this; //retourne une fraction
}

ZFraction operator-(ZFraction const& a, ZFraction const& b)
{
    ZFraction copie(a); //constructeur de copie pour pas modifier les entrees
    copie -= b;
    return copie;
}

ZFraction& ZFraction::operator*=(const ZFraction& b)
{
    m_numerateur*=b.m_numerateur;
    m_denominateur*=b.m_denominateur;

    simplifier();
    convertir();
    return *this; //retourne une fraction
}

ZFraction operator*(ZFraction const& a, ZFraction const& b)
{
    ZFraction copie(a); //constructeur de copie pour pas modifier les entrees
    copie *= b;
    return copie;
}

ZFraction& ZFraction::operator/=(const ZFraction& b)
{
    m_numerateur*=b.m_denominateur;
    m_denominateur*=b.m_numerateur;

    simplifier();
    convertir();
    return *this; //retourne une fraction
}
ZFraction operator/(ZFraction const& a, ZFraction const& b)
{
    ZFraction copie(a); //constructeur de copie pour pas modifier les entrees
    copie /= b;
    return copie;
}

void ZFraction::afficher(ostream &flux) const
{
    if (m_denominateur != 1)
    {
        flux << m_numerateur << "/" << m_denominateur;
    }
    else
    {
        flux << m_numerateur;
    }


}
ostream &operator<<( ostream &flux, ZFraction const& frac)
{
    frac.afficher(flux);
    return flux;
}

int ZFraction::numerateur() const
{
    return m_numerateur;
}

int ZFraction::denominateur() const
{
    return m_denominateur;
}

double ZFraction::nombreReel() const
{
    double nb;
    nb = float(m_numerateur)/m_denominateur;
    return nb;

}

void ZFraction::convertir()
{
    if(((m_numerateur < 0) && (m_denominateur < 0)) || ((m_numerateur > 0) && (m_denominateur < 0)))
    {
        m_numerateur *= (-1);
        m_denominateur *= (-1);
    }

}
ZFraction operator-(ZFraction const& a)
{
    ZFraction res;
    ZFraction moins(-1);
    res = a*moins;
    return res;
}

ZFraction& ZFraction::valeurAbs()
{
    m_numerateur = abs(m_numerateur);
    m_denominateur = abs(m_denominateur);
    return *this;
}

ZFraction valeurAbs(ZFraction const& a)
{
    ZFraction copie(a);
    copie.valeurAbs();
    return copie;
}

ZFraction& ZFraction::racineCarree()
{
    if ((m_numerateur >= 0) && (m_denominateur > 0))
    {
        m_numerateur = sqrt(m_numerateur);
        m_denominateur = sqrt(m_denominateur);
    }
    else
    {
        cout << "Fraction negative! On ne prend pas la racine carree. " << endl;
    }
    return *this;
}

ZFraction racineCarree(ZFraction const& a)
{
    ZFraction copie(a);
    copie.racineCarree();
    return copie;
}

ZFraction& ZFraction::puissance(int puiss)
{
    if (puiss >= 0)
    {
        m_numerateur = pow(m_numerateur,puiss);
        m_denominateur = pow(m_denominateur,puiss);
    }
    else
    {
        int num(m_numerateur);
        m_numerateur = pow(m_denominateur,-puiss);
        m_denominateur = pow(num,-puiss);
        convertir();
    }


    return *this;
}

ZFraction puissance(ZFraction const& a,int puiss)
{
    ZFraction copie(a);
    copie.puissance(puiss);
    return copie;
}
