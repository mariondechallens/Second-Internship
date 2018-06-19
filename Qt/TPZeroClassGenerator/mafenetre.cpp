#include "MaFenetre.h"
#include "code.h"

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
    QObject::connect(m_generer,SIGNAL(clicked()),this,SLOT(genererCode()));



 }

void MaFenetre::genererCode()
{   if (m_nom->text().isEmpty())

    {
        QMessageBox::critical(this, "Erreur", "Veuillez entrer au moins un nom de classe");
        return; // Arrêt de la méthode
    }
    // Si tout va bien, on génère le code
        QString code;

        if (m_com->isChecked()) // On a demandé à inclure les commentaires
        {
            code += "/*\nAuteur : " + m_auteur->text() + "\n";
            code += "Date de création : " + m_date->date().toString() + "\n\n";
            code += "Rôle :\n" + m_texte->toPlainText() + "\n*/\n\n\n";
        }

        if (m_header->isChecked())
        {
            code += "#ifndef HEADER_" + m_nom->text().toUpper() + "\n";
            code += "#define HEADER_" + m_nom->text().toUpper() + "\n\n\n";
        }

        code += "class " + m_nom->text();

        if (!m_classeMere->text().isEmpty())
        {
            code += " : public " + m_classeMere->text();
        }

        code += "\n{\n    public:\n";
        if (m_const->isChecked())
        {
            code += "        " + m_nom->text() + "();\n";
        }
        if (m_destr->isChecked())
        {
            code += "        ~" + m_nom->text() + "();\n";
        }
        code += "\n\n    public slots:\n";
        code += "\n\n    protected:\n";
        code += "\n\n    private:\n";
        code += "};\n\n";

        if (m_header->isChecked())
        {
            code += "#endif\n";
        }


    MonCode *fenetreCode = new MonCode(code, this);
    fenetreCode->exec();
}


