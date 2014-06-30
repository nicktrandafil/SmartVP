#ifndef MOTIONDETECTORWRAPPER_H
#define MOTIONDETECTORWRAPPER_H

#include <QtCore/QObject>

#include <opencv/cv.h>

class QThread;
class MotionDetector;

class MotionDetectorWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(MotionDetector* motionDetector READ motionDetector WRITE setMotionDetector NOTIFY motionDetectorChanged)
    Q_PROPERTY(NOTIFY sendAction)
public:
    explicit MotionDetectorWrapper(QObject *parent = 0);
    ~MotionDetectorWrapper();

    Q_INVOKABLE void beginSession(bool begin);
    Q_INVOKABLE void showDetection(bool show);
    Q_INVOKABLE void resetCam(int camId);

    MotionDetector *motionDetector() const;
    void setMotionDetector(MotionDetector *motionDetector);

signals:
    void motionDetectorChanged();
    void sendAction(const QString & action);

private:
    void drawIm(const cv::Mat &im);

    MotionDetector *m_motionDetector;
    QThread *m_thread;
    bool m_showDetection;
};

#endif // MOTIONDETECTORWRAPPER_H
