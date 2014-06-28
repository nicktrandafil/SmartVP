#include "helper.h"

#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtCore/QUrl>
#include <QtCore/QTime>
#include <QtCore/QTextStream>
#include <QtMultimedia/QCamera>
#include <QtCore/QDebug>

Helper::Helper(QObject *parent) :
    QObject(parent)
{
    qDebug() << "Helper created";

    // Чтение видео форматов
    QFile file(":resources/videoFormats.txt");
    if (!file.open(QFile::ReadOnly)){
        qDebug() << "Can't open the file videFormats";
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
    qDebug() << "Helper deleted";
}

bool Helper::isValidMedia(const QUrl &path) const
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

// длительность для метки слева от ползунка длительности
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

// определение длительности, когда курсор нахдится над ползунков длительности
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

QStringList Helper::readColors(const QString &path)
{
    QFile file(path);
    if (!file.open(QFile::ReadOnly))
        return QStringList();

    QStringList sl;             // первый элемент название цвета, остальные 6 hsv
    QTextStream inf(&file);
    QString temp = inf.readLine();

    while (!temp.isEmpty()){    // пока есть строки в файле
        QStringList tTemp = temp.split(' ');
        int i = 0;
        for (i = 0; i < tTemp.size(); ++i){
            bool ok;
            tTemp[i].toDouble(&ok);
            if (ok)
                break;
        }
        QString name = tTemp[0];
        tTemp.removeFirst();
        for (int j = 0; j < i - 1; ++j){
            name += "_" + tTemp[0];
            tTemp.removeFirst();
        }
        sl << (name + " " + tTemp.join(' '));
        temp = inf.readLine();
    }
    file.close();
    return sl;
}

void Helper::updateColors(const QString &path, const QString &content)
{
    QFile file(path);
    if (!file.open(QFile::Append)){
        qDebug() << file.errorString();
        return;
    }
    QTextStream outf(&file);
    outf << content << endl;
    file.close();
}

const QStringList Helper::devices() const
{
    return m_devices;
}
