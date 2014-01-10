#include <QtGui/QGuiApplication>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>
#include <QtCore/QUrl>
#include <QDebug>
#include "helper.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QQmlEngine engine;
    qmlRegisterType<Helper>("Helper", 1, 0, "Helper");
    QQmlComponent component(&engine);
    QQuickWindow::setDefaultAlphaBuffer(true);
    QGuiApplication::connect(&engine, SIGNAL(quit()), qApp, SLOT(quit()));
    component.loadUrl(QUrl("qrc:///qml/window.qml"));
    if ( component.isReady() )
        component.create();
    else
        qWarning() << component.errorString();
    return app.exec();
}

