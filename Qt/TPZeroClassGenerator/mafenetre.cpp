#include "MaFenetre.h"
#include <QtWebKitWidgets>

using namespace std;


MaFenetre::MaFenetre()
{
    // Génération des widgets de la fenêtre principale
    creerActions();
    creerMenus();
    creerBarresOutils();
    creerBarreEtat();

    // Génération des onglets et chargement de la page d'accueil
    onglets = new QTabWidget;
    onglets->addTab(creerOngletPageWeb(tr("http://www.siteduzero.com")), tr("(Nouvelle page)"));
    connect(onglets, SIGNAL(currentChanged(int)), this, SLOT(changementOnglet(int)));
    setCentralWidget(onglets);

    // Définition de quelques propriétés de la fenêtre
    setMinimumSize(500, 350);
    setWindowIcon(QIcon("web.png"));
    setWindowTitle(tr("zNavigo"));
}

void MaFenetre::creerActions()
{
    actionNouvelOnglet = new QAction(tr("&Nouvel onglet"), this);
    actionNouvelOnglet->setShortcut(tr("Ctrl+T"));
    connect(actionNouvelOnglet, SIGNAL(triggered()), this, SLOT(nouvelOnglet()));

    actionFermerOnglet = new QAction(tr("&Fermer l'onglet"), this);
    actionFermerOnglet->setShortcut(tr("Ctrl+W"));
    connect(actionFermerOnglet, SIGNAL(triggered()), this, SLOT(fermerOnglet()));

    actionQuitter = new QAction(tr("&Quitter"), this);
    actionQuitter->setShortcut(tr("Ctrl+Q"));
    connect(actionQuitter, SIGNAL(triggered()), qApp, SLOT(quit()));

    actionPrecedente = new QAction(QIcon("prec.png"), tr("&Precedente"), this);
    actionPrecedente->setShortcut(QKeySequence::Back);
    connect(actionPrecedente, SIGNAL(triggered()), this, SLOT(precedente()));

    actionSuivante = new QAction(QIcon("suiv.png"), tr("&Suivante"), this);
    actionSuivante->setShortcut(QKeySequence::Forward);
    connect(actionSuivante, SIGNAL(triggered()), this, SLOT(suivante()));

    actionStop = new QAction(QIcon("stop.png"), tr("S&top"), this);
    connect(actionStop, SIGNAL(triggered()), this, SLOT(stop()));

    actionActualiser = new QAction(QIcon("actu.png"), tr("&Actualiser"), this);
    actionActualiser->setShortcut(QKeySequence::Refresh);
    connect(actionActualiser, SIGNAL(triggered()), this, SLOT(actualiser()));

    actionAccueil = new QAction(QIcon("home.png"), tr("A&ccueil"), this);
    connect(actionAccueil, SIGNAL(triggered()), this, SLOT(accueil()));

    actionGo = new QAction(QIcon("go.png"), tr("A&ller à"), this);
    connect(actionGo, SIGNAL(triggered()), this, SLOT(chargerPage()));

    actionAPropos = new QAction(tr("&A propos..."), this);
    connect(actionAPropos, SIGNAL(triggered()), this, SLOT(aPropos()));

    actionAPropos->setShortcut(QKeySequence::HelpContents);
    actionAProposQt = new QAction(tr("A propos de &Qt..."), this);
    connect(actionAProposQt, SIGNAL(triggered()), qApp, SLOT(aboutQt()));
}

void MaFenetre::creerMenus()
{
    QMenu *menuFichier = menuBar()->addMenu(tr("&Fichier"));

    menuFichier->addAction(actionNouvelOnglet);
    menuFichier->addAction(actionFermerOnglet);
    menuFichier->addSeparator();
    menuFichier->addAction(actionQuitter);

    QMenu *menuNavigation = menuBar()->addMenu(tr("&Navigation"));

    menuNavigation->addAction(actionPrecedente);
    menuNavigation->addAction(actionSuivante);
    menuNavigation->addAction(actionStop);
    menuNavigation->addAction(actionActualiser);
    menuNavigation->addAction(actionAccueil);


    QMenu *menuAide = menuBar()->addMenu(tr("&?"));

    menuAide->addAction(actionAPropos);
    menuAide->addAction(actionAProposQt);
}

void MaFenetre::creerBarresOutils()
{
    champAdresse = new QLineEdit;
    connect(champAdresse, SIGNAL(returnPressed()), this, SLOT(chargerPage()));

    QToolBar *toolBarNavigation = addToolBar(tr("Navigation"));

    toolBarNavigation->addAction(actionPrecedente);
    toolBarNavigation->addAction(actionSuivante);
    toolBarNavigation->addAction(actionStop);
    toolBarNavigation->addAction(actionActualiser);
    toolBarNavigation->addAction(actionAccueil);
    toolBarNavigation->addWidget(champAdresse);
    toolBarNavigation->addAction(actionGo);
}

void MaFenetre::creerBarreEtat()
{
    progression = new QProgressBar(this);
    progression->setVisible(false);
    progression->setMaximumHeight(14);
    statusBar()->addWidget(progression, 1);
}



// Slots

void MaFenetre::precedente()
{
    pageActuelle()->back();
}

void MaFenetre::suivante()
{
    pageActuelle()->forward();
}

void MaFenetre::accueil()
{
    pageActuelle()->load(QUrl(tr("http://www.siteduzero.com")));
}

void MaFenetre::stop()
{
    pageActuelle()->stop();
}

void MaFenetre::actualiser()
{
    pageActuelle()->reload();
}


void MaFenetre::aPropos()
{
    QMessageBox::information(this, tr("A propos..."), tr("zNavigo est un projet réalisé pour illustrer les tutoriels C++ du <a href=\"http://www.siteduzero.com\">Site du Zéro</a>.<br />Les images de ce programme ont été créées par <a href=\"http://www.everaldo.com\">Everaldo Coelho</a>"));
}

void MaFenetre::nouvelOnglet()
{
    int indexNouvelOnglet = onglets->addTab(creerOngletPageWeb(), tr("(Nouvelle page)"));
    onglets->setCurrentIndex(indexNouvelOnglet);

    champAdresse->setText("");
    champAdresse->setFocus(Qt::OtherFocusReason);
}

void MaFenetre::fermerOnglet()
{
    // On ne doit pas fermer le dernier onglet, sinon le QTabWidget ne marche plus
    if (onglets->count() > 1)
    {
        onglets->removeTab(onglets->currentIndex());
    }
    else
    {
        QMessageBox::critical(this, tr("Erreur"), tr("Il faut au moins un onglet !"));
    }
}

void MaFenetre::chargerPage()
{
    QString url = champAdresse->text();

    // On rajoute le "http://" s'il n'est pas déjà dans l'adresse
    if (url.left(7) != "http://")
    {
        url = "http://" + url;
        champAdresse->setText(url);
    }

    pageActuelle()->load(QUrl(url));
}

void MaFenetre::changementOnglet(int index)
{
    changementTitre(pageActuelle()->title());
    changementUrl(pageActuelle()->url());
}


void MaFenetre::changementTitre(const QString & titreComplet)
{
    QString titreCourt = titreComplet;

    // On tronque le titre pour éviter des onglets trop larges
    if (titreComplet.size() > 40)
    {
        titreCourt = titreComplet.left(40) + "...";
    }

    setWindowTitle(titreCourt + " - " + tr("zNavigo"));
    onglets->setTabText(onglets->currentIndex(), titreCourt);
}

void MaFenetre::changementUrl(const QUrl & url)
{
    if (url.toString() != tr("html/page_blanche.html"))
    {
        champAdresse->setText(url.toString());
    }
}

void MaFenetre::chargementDebut()
{
    progression->setVisible(true);
}

void MaFenetre::chargementEnCours(int pourcentage)
{
    progression->setValue(pourcentage);
}

void MaFenetre::chargementTermine(bool ok)
{
    progression->setVisible(false);
    statusBar()->showMessage(tr("Prêt"), 2000);
}



// Autres méthodes


QWidget *MaFenetre::creerOngletPageWeb(QString url)
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

QWebView *MaFenetre::pageActuelle()
{
    return onglets->currentWidget()->findChild<QWebView *>();
}

