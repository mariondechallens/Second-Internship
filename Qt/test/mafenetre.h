#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QSlider>
#include <QProgressBar>

class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT //macro

    public:
    MaFenetre();

    public slots:
    void changerLargeur(int largeur);
    void changerHauteur(int hauteur);

    signals:
    void largeurMax();
    void hauteurMax();

    private:
    QSlider *m_slider;
    QSlider *m_slider2;
};

#endif // MAFENETRE_H
