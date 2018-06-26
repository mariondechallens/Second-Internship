#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QtWidgets>


class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT

    public:
        MaFenetre();

    private:

    private slots:
        void clicSelectionSimple();
        void clicSelectionMult();


    private:
        QPushButton *bouton;
        QListView *vue;
        QStringListModel *modele;

};

#endif // MAFENETRE_H
