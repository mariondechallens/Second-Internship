#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QtWidgets>
#include <QtWebKitWidgets>


class MaFenetre : public QMainWindow // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT //macro

    public:

        MaFenetre();
        void creerActions();
        void creerMenus();
        void creerBarresOutils();
        QWidget creerOngletPageWeb(QString url);
        QWebView pageActuelle();

    private slots:
        void changementOnglet();


    private:
        QTabWidget *onglets;

        QAction *nouveau;
        QAction *prec;
        QAction *suiv;
        QAction *actu ;
        QAction *acc;
        QAction *quit;
        QAction *aideQt;
        QAction *go;

        QProgressBar *pourc;
        QLineEdit *recherche;


};

#endif // MAFENETRE_H
