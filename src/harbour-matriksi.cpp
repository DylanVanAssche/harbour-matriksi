#ifdef QT_QML_DEBUG
//#include <QtQuick>
#endif

#include <QtQuick>
#include <sailfishapp.h>
#include "settings.h"

int main(int argc, char *argv[])
{
    //return SailfishApp::main(argc, argv);
    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    application->setApplicationName("harbour-matriksi");

    qmlRegisterType<Settings>          ("Matriksi", 1, 0, "Settings");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine* engine = view->engine();
    QObject::connect(engine, SIGNAL(quit()), application.data(), SLOT(quit()));
    //engine->addImageProvider(QStringLiteral("thumbnail"), new ThumbnailProvider);

    view->setSource(SailfishApp::pathTo("qml/harbour-matriksi.qml"));

    //if(daemonized)
    //    application->setQuitOnLastWindowClosed(false);
    //else
        view->show();

    return application->exec();
}
