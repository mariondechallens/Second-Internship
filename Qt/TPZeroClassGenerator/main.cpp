#include <QApplication>
#include <QtWidgets>
#include "MaFenetre.h"
#include "code.h"

using namespace std;

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    MaFenetre fenetre;

    fenetre.show();

    return app.exec();
}



