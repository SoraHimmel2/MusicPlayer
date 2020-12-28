#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>



int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);



    QQmlApplicationEngine engine;

    engine.load(QUrl(QLatin1String("qrc:/PlayerView.qml")));


    return app.exec();
}
