#include "MaFenetre.h"
#include <iostream>

using namespace std;


MaFenetre::MaFenetre()  //constructeur
{
    //zone centrale
    QMdiArea *zoneCentrale = new QMdiArea;

    QComboBox *sexe = new QComboBox;
    sexe->addItem("Femme");
    sexe->addItem("Homme");
    sexe->addItem("Non communique");
    QDateEdit *date = new QDateEdit;
    QLineEdit *line = new QLineEdit;

    QMdiSubWindow *ssfen1 = zoneCentrale->addSubWindow(sexe);
    QMdiSubWindow *ssfen2 = zoneCentrale->addSubWindow(date);
    QMdiSubWindow *ssfen3 = zoneCentrale->addSubWindow(line);
    ssfen1->setWindowTitle("Sexe");
    ssfen2->setWindowTitle("Date de naissance");
    ssfen3->setWindowTitle("Liste des sous fenetres");

    setCentralWidget(zoneCentrale);

    // Barre de menus
    QMenu *fichier = menuBar()->addMenu("&Fichiers");
    QAction *nouveau = new QAction("&Nouveau",this);
    fichier->addAction(nouveau);

    QMenu *save = fichier->addMenu("&Enregistrer");
    save->addAction("Enre&gistrer"); //pas en pointeurs, il faudrait pour les utiliser ensuite
    save->addAction("Enregistrer &sous");

    QMenu *edit = menuBar()->addMenu("&Edition");
    QAction *coller = new QAction("&Coller",this);
    edit->addAction(coller);
    QAction *gras = new QAction("&Gras",this);
    edit->addAction(gras);
    gras->setCheckable(true);

    connect(nouveau,SIGNAL(triggered(bool)),qApp, SLOT(quit()));

    nouveau->setShortcut(QKeySequence("Ctrl+Q"));
    //nouveau->setIcon(QIcon("devil.png"));

    // Barre d'outils
    QToolBar *outils = addToolBar("outil");
    outils->addAction(nouveau);
    outils->addAction(gras);
    outils->addAction(coller);

    outils->addSeparator();
    QRadioButton *justif = new QRadioButton("Justifier");
    outils->addWidget(justif);

    //Barre d'etat
    QStatusBar *etat = new QStatusBar;
    QLineEdit *recherche = new QLineEdit("&Rechercher");
    etat->addWidget(recherche);

}


