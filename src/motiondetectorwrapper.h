#ifndef MOTIONDETECTORWRAPPER_H
#define MOTIONDETECTORWRAPPER_H

#include <QObject>

class MotionDetectorWrapper : public QObject
{
    Q_OBJECT
public:
    explicit MotionDetectorWrapper(QObject *parent = 0);

signals:

public slots:

};

#endif // MOTIONDETECTORWRAPPER_H
