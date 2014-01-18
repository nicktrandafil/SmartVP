#include "helper.h"
#include <QFile>
#include <QFileInfo>
#include <QUrl>
#include <QTime>
#include <QFile>
#include <QTextStream>
#include <QtMultimedia/QCamera>

#ifdef QT_DEBUG
#include <QDebug>
#endif

Helper::Helper(QObject *parent) :
    QObject(parent)
{
#ifdef QT_DEBUG
    qDebug() << "Helper created";
#endif

    // Чтение виде форматов
    QFile file(":resources/videoFormats.txt");
    if (!file.open(QFile::ReadOnly)){
#ifdef QT_DEBUG
        qDebug() << "Can't open the file videFormats";
#endif
        return;
    }
    QTextStream inf(&file);
    QString format;
    inf >> format;
    format.remove(0, 1);
    while (inf.status() == QTextStream::Ok && inf.status() != QTextStream::ReadPastEnd){
        m_videoFormats << format;
        inf >> format;
        if (!format.isEmpty())
            format.remove(0, 1);
    }

    // Обноружене установленных камер
    QList<QByteArray> listDevice = QCamera::availableDevices();
        for (int i = 0; i < listDevice.size(); ++i){
            int j = listDevice[i].size();
            QString number;
            while (std::isdigit(listDevice[i][--j]))
                number += listDevice[i][j];
            m_devices.append(QCamera::deviceDescription(listDevice[i]));
            m_devices.append(number);
        }
}

Helper::~Helper()
{
#ifdef QT_DEBUG
    qDebug() << "Helper deleted";
#endif
}

bool Helper::isValidMedia(const QUrl &path)
{
    QFileInfo fileInfo(path.path());
    if (!fileInfo.exists())
        return false;
    if (m_videoFormats.contains(fileInfo.suffix().toLower()))
        return true;
    else
        return false;
}

QString Helper::mediaName(const QUrl &path)
{
    QFileInfo fileInfo(path.path());
    if (!fileInfo.exists())
        return "";
    return fileInfo.fileName();
}

QString Helper::duration(qint64 currentInfo, qint64 totalInfo)
{
    QString tStr;
    QTime currentTime((currentInfo/3600)%60, (currentInfo/60)%60, currentInfo%60, (currentInfo*1000)%1000);
    QTime totalTime((totalInfo/3600)%60, (totalInfo/60)%60, totalInfo%60, (totalInfo*1000)%1000);
    QString format = "mm:ss";
    if (totalInfo > 3600)
        format = "hh:mm:ss";
    tStr = currentTime.toString(format) + " / " + totalTime.toString(format);
    return tStr;
}

QString Helper::newDuration(qint64 currentInfo)
{
    QString tStr;
    QTime currentTime((currentInfo/3600)%60, (currentInfo/60)%60, currentInfo%60, (currentInfo*1000)%1000);
    QString format = "mm:ss";
    if (currentInfo > 3600)
        format = "hh:mm:ss";
    tStr = currentTime.toString(format);
    return tStr;
}

QString Helper::readFile(const QString &path)
{
    QFile file(path);
    if (!file.open(QFile::ReadOnly))
        return "";
    QTextStream inf(&file);
    return inf.readAll();
}

const QStringList Helper::devices() const
{
    return m_devices;
}

void Helper::setDevices(const QStringList &devices)
{
    m_devices = devices;
    emit devicesChanged();
}
