#include <QApplication>
#include <QPushButton>
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QGridLayout>
#include <QFormLayout>
#include <QLineEdit>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QWidget fenetre;

    QLineEdit *champ1 = new QLineEdit;
    QLineEdit *champ2 = new QLineEdit;
    QLineEdit *champ3 = new QLineEdit;

    QFormLayout *layout = new QFormLayout;
    layout->addRow("&Nom",champ1);
    layout->addRow("&Prenom",champ2);
    layout->addRow("&Classe",champ3);

    // Création du layout principal de la fenêtre (vertical)

    QVBoxLayout *layoutPrincipal = new QVBoxLayout;
    layoutPrincipal->addLayout(layout); // Ajout du layout de formulaire

    QPushButton *boutonQuitter = new QPushButton("Quitter");
    QWidget::connect(boutonQuitter, SIGNAL(clicked()), &app, SLOT(quit()));
    layoutPrincipal->addWidget(boutonQuitter); // Ajout du bouton

    fenetre.setLayout(layoutPrincipal);

    fenetre.show();

    return app.exec();
}
