#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QApplication>
#include <QtWidgets>
#include <string>

class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT //macro

    public:
    MaFenetre();

    public slots:
    void ouvrirDialogue();

    private:
    QLineEdit *m_nom;
    QLineEdit *m_classeMere;
    QLineEdit *m_auteur;
    QDateEdit *m_date;
    QTextEdit *m_texte;
    QCheckBox *m_header;
    QCheckBox *m_const;
    QCheckBox *m_destr;


};

#endif // MAFENETRE_H
