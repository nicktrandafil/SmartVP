#include "motiondetectorwrapper.h"
#include "motiondetector.h"
#include <QThread>

#ifdef QT_DEBUG
#include <QDebug>
#endif

MotionDetectorWrapper::MotionDetectorWrapper(QObject *parent) :
    QObject(parent),
    m_motionDetector(new MotionDetector),
    m_thread(new QThread)
{
#ifdef QT_DEBUG
    qDebug() << "MotionDetecotWrapper created";
#endif
    connect(m_motionDetector, SIGNAL(sendAction(QString)), SIGNAL(sendAction(QString)));

    connect(m_thread, SIGNAL(finished()), m_motionDetector, SLOT(deleteLater()));
    m_motionDetector->moveToThread(m_thread);
    m_thread->start();
}

MotionDetectorWrapper::~MotionDetectorWrapper()
{
#ifdef QT_DEBUG
    qDebug() << "MotionDetecotWrapper deleted";
#endif
    m_thread->quit();
    m_thread->deleteLater();
}

void MotionDetectorWrapper::beginSession(bool begin)
{
    QMetaObject::invokeMethod(m_motionDetector, "beginSession", Q_ARG(bool, begin));
}

MotionDetector *MotionDetectorWrapper::motionDetector() const
{
    return m_motionDetector;
}

void MotionDetectorWrapper::setMotionDetector(MotionDetector *motionDetector)
{
    m_motionDetector = motionDetector;
    emit motionDetectorChanged();
}

