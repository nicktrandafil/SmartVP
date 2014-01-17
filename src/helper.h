#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QStringList>

class QGraphicsObject;

class Helper : public QObject
{
    Q_OBJECT
public:
    explicit Helper(QObject *parent = 0);
    ~Helper();
    Q_INVOKABLE bool isValidMedia(const QUrl &path);
    Q_INVOKABLE QString mediaName(const QUrl & path);
    Q_INVOKABLE QString duration(qint64 currentInfo, qint64 totalInfo);
    Q_INVOKABLE QString newDuration(qint64 currentInfo);
    Q_INVOKABLE QString readFile(const QString & path);
private:
    QStringList m_videoFormats;
};

#endif // HELPER_H
