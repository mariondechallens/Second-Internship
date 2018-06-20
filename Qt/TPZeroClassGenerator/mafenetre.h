#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QtWidgets>

class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT //macro

    public:
    MaFenetre();

    public slots:
    void genererCode();
    void afficherHeader();

    private:
    QLineEdit *m_nom;
    QLineEdit *m_classeMere;
    QLineEdit *m_auteur;
    QDateEdit *m_date;
    QTextEdit *m_texte;
    QCheckBox *m_header;
    QCheckBox *m_const;
    QCheckBox *m_destr;
    QPushButton *m_generer;
    QPushButton *m_quitter;
    QGroupBox *m_com;

};

#endif // MAFENETRE_H
