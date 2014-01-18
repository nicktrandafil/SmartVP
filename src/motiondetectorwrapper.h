#ifndef MOTIONDETECTORWRAPPER_H
#define MOTIONDETECTORWRAPPER_H

#include <QObject>

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

    MotionDetector *motionDetector() const;
    void setMotionDetector(MotionDetector *motionDetector);

signals:
    void motionDetectorChanged();
    void sendAction(const QString & action);

public slots:
private:
    MotionDetector *m_motionDetector;
    QThread *m_thread;
};

#endif // MOTIONDETECTORWRAPPER_H
