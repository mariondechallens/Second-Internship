#include <QApplication>
#include <QtWidgets>


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QWidget fenetre;
    // 1 : Créer le QTabWidget
        QTabWidget *onglets = new QTabWidget(&fenetre);
        onglets->setGeometry(30, 20, 240, 160);

   // 2 : Créer les pages, en utilisant un widget parent pour contenir chacune des pages, sans indiquer le parent
        QWidget *page1 = new QWidget;
        QWidget *page2 = new QWidget;
        QLabel *page3 = new QLabel; // Comme un QLabel est aussi un QWidget (il en hérite), on peut aussi s'en servir de page

   // 3 : Créer le contenu des pages de widgets, sans indiquer de parent

         // Page 1

            QLineEdit *lineEdit = new QLineEdit("Entrez votre nom");
            QRadioButton *bouton1 = new QRadioButton("Fille");
            QRadioButton *bouton2 = new QRadioButton("Garcon");

            QVBoxLayout *vbox1 = new QVBoxLayout;
            vbox1->addWidget(lineEdit);
            vbox1->addWidget(bouton1);
            vbox1->addWidget(bouton2);

            page1->setLayout(vbox1);

         // Page 2

            QSpinBox *age = new QSpinBox;
            QPushButton *bouton3 = new QPushButton("Valider");

            QVBoxLayout *vbox2 = new QVBoxLayout;
            vbox2->addWidget(age);
            vbox2->addWidget(bouton3);

            page2->setLayout(vbox2);

       // Page 3 (je ne vais afficher qu'un texte ici, pas besoin de layout)

            page3->setText("J'ai fini ");
            page3->setAlignment(Qt::AlignCenter);

        // 4 : ajouter les onglets au QTabWidget, en indiquant la page qu'ils contiennent
        onglets->addTab(page1, "Coordonnées");
        onglets->addTab(page2, "Age");
        onglets->addTab(page3, "Texte");

    fenetre.show();

    return app.exec();
}



