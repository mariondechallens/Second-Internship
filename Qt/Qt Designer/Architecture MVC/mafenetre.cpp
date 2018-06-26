#include "MaFenetre.h"


MaFenetre::MaFenetre()
{
    QVBoxLayout *layout = new QVBoxLayout;

    QStringList liste;
    liste << "Marion" << "Annabelle" << "Margaux";
    liste.append("bouh");
    modele = new QStringListModel(liste);

    /*QDirModel *modele = new QDirModel; //notre disque dur
    QStandardItemModel *modele = new QStandardItemModel(1,1);
    modele->setItem(0,0,new QStandardItem("salut"));

    QStandardItem *item = new QStandardItem("Hallo");
    modele->appendRow(item);
    item->appendRow(new QStandardItem("allemand")); // elt enfant

    QStandardItem *item2 = new QStandardItem("Hello");
    modele->appendRow(item2);
    item2->appendRow(new QStandardItem("Anglais"));
*/
    vue = new QListView;
    vue->setModel(modele);
    vue->setSelectionMode(QAbstractItemView::ExtendedSelection); //selection multiple
    //vue->header()->hide(); // supprimer les entêtes d'un arbre
    //vue->setRootIndex(modele->index("C:"));

    bouton = new QPushButton("Afficher la selection");

    layout->addWidget(vue);
    layout->addWidget(bouton);

    setLayout(layout);

    connect(bouton,SIGNAL(clicked()),this, SLOT(clicSelectionMult()));
}

void MaFenetre::clicSelectionSimple()
{
    QItemSelectionModel *selection = vue->selectionModel();
    QModelIndex indexElementSelectionne = selection->currentIndex();
    QVariant elementSelectionne = modele->data(indexElementSelectionne, Qt::DisplayRole);
    QMessageBox::information(this, "Elément sélectionné", elementSelectionne.toString());
}

void MaFenetre::clicSelectionMult()
{
    QItemSelectionModel *selection = vue->selectionModel();
    QModelIndexList listeSelections = selection->selectedIndexes();
    QString elementsSelectionnes;

    for (int i = 0 ; i < listeSelections.size() ; i++)
    {
        QVariant elementSelectionne = modele->data(listeSelections[i], Qt::DisplayRole);
        elementsSelectionnes += elementSelectionne.toString() + "<br />";
    }

    QMessageBox::information(this, "Eléments sélectionnés", elementsSelectionnes);
}
