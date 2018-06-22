#include "FenCalculatrice.h"
#include "ui_FenCalculatrice.h"



FenCalculatrice::FenCalculatrice(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::FenCalculatrice)
{
    ui->setupUi(this);
    //ui->egal->setText("Egal");
    connect(ui->egal, SIGNAL(clicked()), this, SLOT(calcul()));
}

FenCalculatrice::~FenCalculatrice()
{
    delete ui;
}

void FenCalculatrice::calcul()
{
    if (ui->operation->currentText() == "+")
    {
        int result(ui->nombre1->value() + ui->nombre2->value());
        ui->res->setText(QString::number(result));
    }
    else if (ui->operation->currentText() == "-")
    {
        int result(ui->nombre1->value() - ui->nombre2->value());
        ui->res->setText(QString::number(result));
    }
    else if (ui->operation->currentText() == "*")
    {
        int result(ui->nombre1->value() * ui->nombre2->value());
        ui->res->setText(QString::number(result));
    }
    else if ((ui->operation->currentText() == "/") && (ui->nombre2->value() != 0))
    {
        double result(ui->nombre1->value() / (double)ui->nombre2->value());
        ui->res->setText(QString::number(result));
    }
    else
    {
        QMessageBox::critical(this,"ATTENTION","Division par zero impossible!");
    }
}
