#include "helper.h"
#include <QFile>
#include <QFileInfo>
#include <QUrl>

#ifdef QT_DEBUG
#include <QDebug>
#endif

Helper::Helper(QObject *parent) :
    QObject(parent)
{
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
