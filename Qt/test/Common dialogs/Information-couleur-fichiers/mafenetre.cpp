#include "MaFenetre.h"

MaFenetre::MaFenetre() : QWidget()  //constructeur
{
    setFixedSize(500,700);

    m_bouton = new QPushButton("Ouvrir la boite de dialogue",this);
    m_bouton->move(40,50);
    m_bouton->setGeometry(100,100,300,100);
    QObject::connect(m_bouton,SIGNAL(clicked()),this,SLOT(ouvrirDialogue()));
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

