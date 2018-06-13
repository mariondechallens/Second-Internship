#ifndef MAFENETRE_H
#define MAFENETRE_H

#include <QApplication>
#include <QWidget>
#include <QPushButton>
#include <QSlider>
#include <QProgressBar>
#include <QMessageBox>
#include <QInputDialog>
#include <QFontDialog>
#include <QColorDialog>
#include <QPalette>
#include <QFileDialog>

class MaFenetre : public QWidget // On hérite de QWidget (IMPORTANT)
{
    Q_OBJECT //macro

    public:
    MaFenetre();

    public slots:
    void ouvrirDialogue();

    private:
    QPushButton *m_bouton;
};

#endif // MAFENETRE_H
