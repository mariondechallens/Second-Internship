#include "MaFenetre.h"
#include <QtWebKitWidgets>

using namespace std;


MaFenetre::MaFenetre()  //constructeur
{
    creerActions();
    creerMenus();
    creerBarresOutils();

    onglets = new QTabWidget;
    onglets->addTab(creerOngletPageWeb("http://www.siteduzero.com"),"Nouvelle page");
    connect(onglets, SIGNAL(currentChanged(int)), this, SLOT(changementOnglet(int)));
    setCentralWidget(onglets);

    setMinimumSize(500, 350);
    setWindowTitle(tr("Google - zNavigo")); // tr pour traduction
    setWindowIcon(QIcon("web.png"));
}

QWidget *MaFenetre::creerOngletPageWeb(QString url) // cree QWidget page avec un QWebView dedans
{
    QWidget *pageOnglet = new QWidget;
    QWebView *pageWeb = new QWebView;

    QVBoxLayout *layout = new QVBoxLayout;
    layout->setContentsMargins(0,0,0,0);
    layout->addWidget(pageWeb);
    pageOnglet->setLayout(layout);

    if (url.isEmpty())
    {
        pageWeb->load(QUrl(tr("html/page_blanche.html")));
    }
    else
    {
        if (url.left(7) != "http://")
        {
            url = "http://" + url;
        }
        pageWeb->load(QUrl(url));
    }

    // Gestion des signaux envoyés par la page web
    connect(pageWeb, SIGNAL(titleChanged(QString)), this, SLOT(changementTitre(QString)));
    connect(pageWeb, SIGNAL(urlChanged(QUrl)), this, SLOT(changementUrl(QUrl)));
    connect(pageWeb, SIGNAL(loadStarted()), this, SLOT(chargementDebut()));
    connect(pageWeb, SIGNAL(loadProgress(int)), this, SLOT(chargementEnCours(int)));
    connect(pageWeb, SIGNAL(loadFinished(bool)), this, SLOT(chargementTermine(bool)));

    return pageOnglet;
}

QWebView *MaFenetre::pageActuelle() // pointeur vers le QWebView de l'onglet actuel
{
    return onglets->currentWidget()->findChild<QWebView *>();
}

void MaFenetre::changementOnglet()
{

}

void MaFenetre::creerActions()
{

}

void MaFenetre::creerMenus()
{
    QMenu *fichier = menuBar()->addMenu("&Fichier");
    nouveau = new QAction("&Nouveau",this);
    fichier->addAction(nouveau);
    QMenu *ouvrir = fichier->addMenu("&Ouvrir");
    ouvrir->addAction("Rechercher");
    ouvrir->addAction("Fichiers recents");
    QMenu *enreg = fichier->addMenu("&Enregistrer");
    enreg->addAction("Enregistrer");
    enreg->addAction("Enregistrer sous");

    QMenu *navig = menuBar()->addMenu("&Navigation");
    prec = new QAction("Page &précedente",this);
    navig->addAction(prec);
    suiv = new QAction("Page &suivante",this);
    navig->addAction(suiv);
    actu = new QAction("&Actualiser la page",this);
    navig->addAction(actu);
    acc = new QAction("Aller a la page d'ac&cueil",this);
    navig->addAction(acc);
    quit = new QAction("Arreter la navigation",this);
    navig->addAction(quit);

    QMenu *aide = menuBar()->addMenu("&?");
    aideQt  = new QAction("Aide &Qt",this);
    aide->addAction(aideQt);


    connect(aideQt,SIGNAL(triggered(bool)),qApp, SLOT(aboutQt()));


}

void MaFenetre::creerBarresOutils()
{
    QToolBar *outils = addToolBar("outil");
    outils->addAction(prec);
    prec->setIcon(QIcon("prec.png"));
    outils->addAction(suiv);
    suiv->setIcon(QIcon("suiv.png"));
    outils->addAction(quit);
    quit->setIcon(QIcon("stop.png"));
    outils->addAction(actu);
    actu->setIcon(QIcon("actu.png"));
    outils->addAction(acc);
    acc->setIcon(QIcon("home.png"));

    recherche = new QLineEdit("http://www.google.fr/");
    outils->addWidget(recherche);
    go = new QAction("Aller a la page demandee",this);
    outils->addAction(go);
    go->setIcon(QIcon("go.png"));

    QStatusBar *etat = new QStatusBar();
    pourc = new QProgressBar;
    etat->addWidget(pourc);
    setStatusBar(etat);
}
