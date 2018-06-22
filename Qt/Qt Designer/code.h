#ifndef CODE_H
#define CODE_H

#include <QtWidgets>

class MonCode : public QDialog
{

    public:
    MonCode(QString &texte, QWidget *parent);

    public slots:

    private:
    QTextEdit *m_code;
    QPushButton *m_fermer;

};

#endif // CODE_H
