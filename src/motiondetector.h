#ifndef MOTIONDETECTOR_H
#define MOTIONDETECTOR_H

#include <QtCore/QObject>
#include <QtCore/QVector>

#include <vector>

#include <opencv/cv.h>
#include <opencv/highgui.h>

#include "handbag.h"

class QTimerEvent;

class SeriesAnaliser : public QObject
{
    Q_OBJECT
public:
    explicit SeriesAnaliser(QObject * parent = 0);
    ~SeriesAnaliser();

    static QString analize(const QVector<QPair<double, double> > &source);

private:
    static bool linerCheck(const QVector<QPair<double, double> > &source);

private:
    static double s_fps;
    static QString s_actionPack;
};

class MotionDetector : public QObject
{
    Q_OBJECT
public:
    explicit MotionDetector(QObject *parent = 0);
    ~MotionDetector();

    enum State{ST_WAITING, ST_OBSERVING};

public slots:
    void beginSession(bool begin);                                    // Начать наблюдение за камерой
    void setMinH(int v);
    void setMinS(int v);
    void setMinV(int v);
    void setMaxH(int v);
    void setMaxS(int v);
    void setMaxV(int v);
    void resetCam(int camId);

signals:
    void sendAction(const QString & action);                    // Отправляет рашифрованное действие
    void showIm(const cv::Mat &im);

private:
    void observCam();           // Наблюдает за камерой
    cv::Mat filterIm(const cv::Mat &frame);            // Подготавливает hsv картинку. результат - bin картинка
    Stick detectStick(const cv::Mat &binIm);         // Обноружатель палочки
    void drawStick(cv::Mat & im, const Stick &m_stick);
    void accumulator(const cv::Point &top);
    double lineLength(const cv::Point2f & p1, const cv::Point2f & p2) const;

protected:
    void timerEvent(QTimerEvent *event);                    // Следит за камерой. Вызвает observCap

private:
    State m_state;
    int m_arAtThreshold;                              // AreaAtentionThreshold - площадь объектов, на которые обращает внимаетие детектор
    QVector<QPair<double, double> > m_pointSeries;    // Серия картинок, нужно для расшифровки движеия
    cv::VideoCapture m_cap;

    int m_observeTimInterval;
    int m_observeTimId;

    int m_minH, m_minS, m_minV, m_maxH, m_maxS, m_maxV;

    int m_camId;
};

#endif // MOTIONDETECTOR_H
