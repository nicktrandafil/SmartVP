#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QStringList>
#include <QHash>
#include <QVariant>


class QGraphicsObject;

class Helper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList devices READ devices WRITE setDevices NOTIFY devicesChanged)
public:
    explicit Helper(QObject *parent = 0);
    ~Helper();
    Q_INVOKABLE bool isValidMedia(const QUrl &path);
    Q_INVOKABLE QString mediaName(const QUrl & path);
    Q_INVOKABLE QString duration(qint64 currentInfo, qint64 totalInfo);
    Q_INVOKABLE QString newDuration(qint64 currentInfo);
    Q_INVOKABLE QString readFile(const QString & path);

    const QStringList devices() const;
    void setDevices(const QStringList & devices);

signals:
    void devicesChanged();
private:
    QStringList m_videoFormats;
    QStringList m_devices;
};

#endif // HELPER_H
