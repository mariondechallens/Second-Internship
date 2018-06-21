#include <QApplication>
#include <QtWidgets>
#include "FenCalculatrice.h"
#include <iostream>

using namespace std;

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    FenCalculatrice fenetre;

    fenetre.show();

    return app.exec();
}



