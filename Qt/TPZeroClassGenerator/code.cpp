#include "code.h"

MonCode::MonCode(QString &texte, QWidget *parent = 0): QDialog(parent)
{
    m_code = new QTextEdit;
    m_code->setPlainText(texte);
    m_code->setFont(QFont("Courier"));
    m_code->setReadOnly(true);

    m_fermer = new QPushButton("&Fermer");
    QVBoxLayout *layout = new QVBoxLayout;
    layout->addWidget(m_code);
    layout->addWidget(m_fermer);
    setLayout(layout);

    QObject::connect(m_fermer,SIGNAL(clicked()),this,SLOT(accept()));

}
