#include "MaFenetre.h"

MaFenetre::MaFenetre() : QWidget()  //constructeur
{
    setFixedSize(200,200);

    m_slider = new QSlider(Qt::Horizontal, this);
    m_slider->setGeometry(10, 60, 150, 20);
    m_slider->setRange(200, 600);

    m_slider2 = new QSlider(this);
    m_slider2->setGeometry(170,10,20,150);
    m_slider2->setRange(200, 600);

    QObject::connect(m_slider,SIGNAL(valueChanged(int)),this,SLOT(changerLargeur(int)));
    QObject::connect(m_slider2,SIGNAL(valueChanged(int)),this,SLOT(changerHauteur(int)));
    QObject::connect(this,SIGNAL(largeurMax()),qApp,SLOT(aboutQt()));
    QObject::connect(this,SIGNAL(hauteurMax()),qApp,SLOT(quit()));
}

void MaFenetre::changerLargeur(int largeur)
{
    setFixedSize(largeur,height()); // garder hauteur actuelle
    if (largeur == 600)
    {
        emit largeurMax();
    }
}

void MaFenetre::changerHauteur(int hauteur)
{
    setFixedSize(width(),hauteur);
    if (hauteur == 600)
    {
        emit hauteurMax();
    }
}
