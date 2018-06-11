#include "MaFenetre.h"

MaFenetre::MaFenetre(int largeur, int hauteur) : QWidget()  //constructeur
{
    setFixedSize(largeur,hauteur);

    // Construction du bouton
    m_bouton = new QPushButton("C'est mon bouton !", this); // pointeur

    m_bouton->setFont(QFont("Comic Sans MS", 14));
    m_bouton->setCursor(Qt::PointingHandCursor);
    m_bouton->setIcon(QIcon("devil.png"));
    m_bouton->move(60, 50);
}
