#include "MaFenetre.h"

MaFenetre::MaFenetre() : QWidget()  //constructeur
{
    setFixedSize(200,200);

    m_bouton = new QPushButton("Ouvrir la boite de dialogue",this);
    m_bouton->move(40,50);
    QObject::connect(m_bouton,SIGNAL(clicked()),this,SLOT(ouvrirDialogue()));
}

void MaFenetre::ouvrirDialogue()
{
   int reponse = QMessageBox::question(this,"Titre","<strong>Bonjour?</strong>");
   if (reponse == QMessageBox::Yes)
   {
       QMessageBox::information(this,"INFO","Bienvenue!");
   }
   else if (reponse == QMessageBox::No)
   {
       QMessageBox::critical(this,"HALTE","Au revoir!");
   }
}

