#include <QtGui/QGuiApplication>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>
#include <QtCore/QUrl>
#include <QDebug>
#include "helper.h"
#include "actionpack.h"
#include "motiondetectorwrapper.h"
#include "motiondetector.h"
#include <QSharedPointer>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QQmlEngine engine;
    qmlRegisterType<Helper>("Helper", 1, 0, "Helper");
    //qmlRegisterType<ActionPack>("ActionPack", 1, 0, "ActionPack");
    qmlRegisterType<MotionDetectorWrapper>("MotionDetectorWrapper", 1, 0, "MotionDetectorWrapper");
    qmlRegisterType<MotionDetector>("MotionDetectorWrapper", 1, 0, "MotionDetector");
    QQmlComponent component(&engine);
    QQuickWindow::setDefaultAlphaBuffer(true);
    QGuiApplication::connect(&engine, SIGNAL(quit()), &app, SLOT(quit()));
    component.loadUrl(QUrl("qrc:///qml/window.qml"));
    QSharedPointer<QObject> pointer;
    if ( component.isReady() )
        pointer = QSharedPointer<QObject>(component.create());
    else
        qWarning() << component.errorString();
    return app.exec();
}

