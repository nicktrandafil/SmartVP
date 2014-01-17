#ifndef MOTIONDETECTORWRAPPER_H
#define MOTIONDETECTORWRAPPER_H

#include <QObject>

class QThread;
class MotionDetector;

class MotionDetectorWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(MotionDetector* motionDetector READ motionDetector WRITE setMotionDetector NOTIFY motionDetectorChanged)
public:
    explicit MotionDetectorWrapper(QObject *parent = 0);
    ~MotionDetectorWrapper();

    MotionDetector *motionDetector() const;
    void setMotionDetector(MotionDetector *motionDetector);

signals:
    void motionDetectorChanged();

public slots:
private:
    MotionDetector *m_motionDetector;
    QThread *m_thread;
};

#endif // MOTIONDETECTORWRAPPER_H
