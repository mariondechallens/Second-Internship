#ifndef FENCALCULATRICE_H
#define FENCALCULATRICE_H

#include <QDialog>
#include <QMessageBox>


namespace Ui {
    class FenCalculatrice;
}

class FenCalculatrice : public QDialog
{
    Q_OBJECT

public:
    explicit FenCalculatrice(QWidget *parent = 0);
     ~FenCalculatrice();

public slots:
    void calcul();

private :
    Ui::FenCalculatrice *ui;

};

#endif // FENCALCULATRICE_H
