#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QApplication>
#include <QWidget>
#include <QPushButton>

class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    public:
    MaFenetre(int largeur = 300,int hauteur = 150);

    private:
    QPushButton *m_bouton;
};

#endif // MAFENETRE_H
