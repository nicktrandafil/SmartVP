#ifndef HELPER_H
#define HELPER_H

#include <QtCore/QObject>
#include <QtCore/QStringList>
#include <QtCore/QHash>
#include <QtCore/QVariant>


class QGraphicsObject;

class Helper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList devices READ devices)
public:
    explicit Helper(QObject *parent = 0);
    ~Helper();
    Q_INVOKABLE bool isValidMedia(const QUrl &path) const;
    Q_INVOKABLE static QString mediaName(const QUrl & path);
    Q_INVOKABLE static QString duration(qint64 currentInfo, qint64 totalInfo);
    Q_INVOKABLE static QString newDuration(qint64 currentInfo);
    Q_INVOKABLE static QString readFile(const QString & path);
    Q_INVOKABLE static QStringList readColors(const QString &path);
    Q_INVOKABLE static void updateColors(const QString &path, const QString &content);

private:
    const QStringList devices() const;

private:
    QStringList m_videoFormats;
    QStringList m_devices;
};

#endif // HELPER_H
