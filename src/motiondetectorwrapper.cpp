#include "motiondetectorwrapper.h"
#include "motiondetector.h"

#include <QtCore/QThread>

#include <QDebug>

MotionDetectorWrapper::MotionDetectorWrapper(QObject *parent) :
    QObject(parent),
    m_motionDetector(new MotionDetector),
    m_thread(new QThread),
    m_showDetection(false)
{
    qRegisterMetaType<cv::Mat>("cv::Mat");

    qDebug() << "MotionDetecotWrapper created";

    connect(m_motionDetector, SIGNAL(sendAction(QString)), SIGNAL(sendAction(QString)));
    connect(m_thread, SIGNAL(finished()), m_motionDetector, SLOT(deleteLater()));
    connect(m_motionDetector, &MotionDetector::showIm, this, &MotionDetectorWrapper::drawIm, Qt::QueuedConnection);

    m_motionDetector->moveToThread(m_thread);
    m_thread->start();
}

MotionDetectorWrapper::~MotionDetectorWrapper()
{
    cv::destroyAllWindows();
    qDebug() << "MotionDetecotWrapper deleted";
    QMetaObject::invokeMethod(m_motionDetector, "beginSession", Qt::BlockingQueuedConnection, Q_ARG(bool, false));
    m_thread->quit();
    m_thread->deleteLater();
}

void MotionDetectorWrapper::beginSession(bool begin)
{
    QMetaObject::invokeMethod(m_motionDetector, "beginSession", Q_ARG(bool, begin));
}

void MotionDetectorWrapper::showDetection(bool show)
{
    if (show)
        cv::namedWindow("bin");
    else
        cv::destroyWindow("bin");
    m_showDetection = show;
}

void MotionDetectorWrapper::resetCam(int camId)
{
    QMetaObject::invokeMethod(m_motionDetector, "resetCam", Q_ARG(int, camId));
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

void MotionDetectorWrapper::drawIm(const cv::Mat &im)
{
    if (m_showDetection)
        cv::imshow("bin", im);
}

