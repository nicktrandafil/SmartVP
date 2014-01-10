#ifndef HELPER_H
#define HELPER_H

#include <QObject>
#include <QStringList>

class Helper : public QObject
{
    Q_OBJECT
public:
    explicit Helper(QObject *parent = 0);
    Q_INVOKABLE bool isValidMedia(const QUrl &path);
    Q_INVOKABLE QString mediaName(const QUrl & path);

private:
    QStringList m_videoFormats;
};

#endif // HELPER_H
