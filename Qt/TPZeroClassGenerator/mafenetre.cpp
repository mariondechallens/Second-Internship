#include "MaFenetre.h"

using namespace std;


MaFenetre::MaFenetre() : QWidget()  //constructeur
{
    // Def de la classe

    m_nom = new QLineEdit;
    m_classeMere = new QLineEdit;
    m_nom->setText("Demoniste");
    m_classeMere->setText("Personnage");

    QFormLayout *layout1 = new QFormLayout;
    layout1->addRow("&Nom",m_nom);
    layout1->addRow("Classe &mere",m_classeMere);

    QGroupBox *groupbox1 = new QGroupBox("Definition de la classe");
    groupbox1->setLayout(layout1);

    // Options

    m_header = new QCheckBox("Proteger le &header contre les inclusions multiples");
    m_header->setChecked(true);
    m_const = new QCheckBox("Generer un &constructeur par defaut");
    m_const->setChecked(true);
    m_destr = new QCheckBox("Generer un &destructeur");

    QVBoxLayout *layout2 = new QVBoxLayout;
    layout2->addWidget(m_header);
    layout2->addWidget(m_const);
    layout2->addWidget(m_destr);

    QGroupBox *groupbox2 = new QGroupBox("Options");
    groupbox2->setLayout(layout2);

    // Commentaires

    m_auteur = new QLineEdit;
    m_date = new QDateEdit;
    m_texte = new QTextEdit;
    m_auteur->setText("Marion");
    m_texte->setText("Gere un personnage de type Demon");

    QFormLayout *layout3 = new QFormLayout;
    layout3->addRow("&Auteur",m_auteur);
    layout3->addRow("Da&te de creation",m_date);
    layout3->addRow("&Role de la classe", m_texte);

    m_com = new QGroupBox("Ajouter des commentaires");
    m_com->setCheckable(true);
    m_com->setChecked(true);
    m_com->setLayout(layout3);


    // Boutons
    m_generer = new QPushButton("&Generer !");
    m_quitter = new QPushButton("&Quitter");

    QHBoxLayout *layout4 = new QHBoxLayout;
    layout4->setAlignment(Qt::AlignRight); //vers la droite
    layout4->addWidget(m_generer);
    layout4->addWidget(m_quitter);

    //Layout principal

    QVBoxLayout *layoutPrincipal = new QVBoxLayout;
    layoutPrincipal->addWidget(groupbox1);
    layoutPrincipal->addWidget(groupbox2);
    layoutPrincipal->addWidget(m_com);
    layoutPrincipal->addLayout(layout4);

    setLayout(layoutPrincipal);
    setWindowTitle("Zero Class Generator");

    QObject::connect(m_quitter,SIGNAL(clicked()),qApp,SLOT(quit()));



 }

/*void MaFenetre::ouvrirDialogue()
{
    // bool ok = false;
    QString file = QFileDialog::getSaveFileName(this,"Sauver",QString(),"Images (*.png)");
    QMessageBox::information(this,"Fichier","Vous avez sélectionné :\n" + file);
    if (ok)

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
    m_bouton->setPalette(palette);


}
*/

