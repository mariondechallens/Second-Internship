#include "MaFenetre.h"

using namespace std;


MaFenetre::MaFenetre() : QWidget()  //constructeur
{
    // Def de la classe
    QGroupBox *groupbox1 = new QGroupBox("Definition de la classe",this);
    m_nom = new QLineEdit;
    m_classeMere = new QLineEdit;
    m_nom->setText("Demoniste");
    m_classeMere->setText("Personnage");

    QFormLayout *layout1 = new QFormLayout;
    layout1->addRow("&Nom",m_nom);
    layout1->addRow("Classe &mere",m_classeMere);
    groupbox1->setLayout(layout1);

    // Options
    QGroupBox *groupbox2 = new QGroupBox("Options",this);
    m_header = new QCheckBox("Proteger le &header contre les inclusions multiples");
    m_const = new QCheckBox("Generer un &constructeur par defaut");
    m_destr = new QCheckBox("Generer un &destructeur");
    m_header->setChecked(true);
    m_const->setChecked(true);

    QVBoxLayout *layout2 = new QVBoxLayout;
    layout2->addWidget(m_header);
    layout2->addWidget(m_const);
    layout2->addWidget(m_destr);
    groupbox2->setLayout(layout2);

    // Commentaires
    QGroupBox *groupbox3 = new QGroupBox("Ajouter des commentaires",this);
    groupbox3->setCheckable(true);
    groupbox3->setChecked(true);
    m_auteur = new QLineEdit;
    m_date = new QDateEdit;
    m_texte = new QTextEdit;
    m_auteur->setText("Marion");
    m_texte->setText("Gere un personnage de type Demon");

    QFormLayout *layout3 = new QFormLayout;
    layout3->addRow("&Auteur",m_auteur);
    layout3->addRow("Da&te de creation",m_date);
    layout3->addRow("&Role de la classe", m_texte);
    groupbox3->setLayout(layout3);


    // Boutons
    QPushButton *generer = new QPushButton("Generer !");
    QPushButton *quitter = new QPushButton("Quitter");

    QHBoxLayout *layout4 = new QHBoxLayout;
    layout4->addWidget(generer,0,Qt::AlignRight);
    layout4->addWidget(quitter,0,Qt::AlignJustify);

    QVBoxLayout *layoutPrincipal = new QVBoxLayout;
    layoutPrincipal->addWidget(groupbox1);
    layoutPrincipal->addWidget(groupbox2);
    layoutPrincipal->addWidget(groupbox3);
    layoutPrincipal->addLayout(layout4);

    setLayout(layoutPrincipal);

    QObject::connect(quitter,SIGNAL(clicked()),qApp,SLOT(quit()));



 }

void MaFenetre::ouvrirDialogue()
{
    // bool ok = false;
    QString file = QFileDialog::getSaveFileName(this,"Sauver",QString(),"Images (*.png)");
    QMessageBox::information(this,"Fichier","Vous avez sélectionné :\n" + file);
    /*if (ok)

        {
            QMessageBox::information(this, "Nouvelle police", "La police est maintenant " + police.toString());
            m_bouton->setFont(police);
        }

        else

        {
            QMessageBox::critical(this, "Police", "Vous n'avez pas change de police snif.");
        }
    QPalette palette; // creation d'une palette de couleur
    palette.setColor(QPalette::ButtonText,couleur);
    m_bouton->setPalette(palette); */


}

