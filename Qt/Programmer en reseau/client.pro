TEMPLATE = app
DEPENDPATH += .
INCLUDEPATH += .
SOURCES += \
        main.cpp \
    fenserveur.cpp \
    fenclient.cpp

HEADERS += \
    fenserveur.h \
    fenclient.h

QT += widgets network

FORMS += \
    FenClient.ui

