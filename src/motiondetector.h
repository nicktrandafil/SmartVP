#ifndef MOTIONDETECTOR_H
#define MOTIONDETECTOR_H

#include <QObject>
#include <QVector>
#include <vector>
#include <opencv/cv.h>
#include <opencv/highgui.h>

class QTimerEvent;

class Stick
{
public:
    explicit Stick();
    ~Stick();
    cv::Point top() const;
    void setTop(const cv::Point &top);
    cv::Point bottom() const;
    void setBottom(const cv::Point &bottom);
private:
    cv::Point m_top;
    cv::Point m_bottom;
};

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
    void setShowImage(bool show);
    void resetCam(int camId);
signals:
    void sendAction(const QString & action);                    // Отправляет рашифрованное действие
private:
    void observCam();           // Наблюдает за камерой
    void filterIm();            // Подготавливает hsv картинку. результат - bin картинка
    void detectStick();         // Обноружатель палочки
    void showIms() const;
    void drawStick(cv::Mat & im);
    double lineLength(const cv::Point2f & p1, const cv::Point2f & p2) const;
protected:
    void timerEvent(QTimerEvent *event);                    // Следит за камерой. Вызвает observCap
private:
    State m_state;
    int m_arAtThreshold;                              // AreaAtentionThreshold - площадь объектов, на которые обращает внимаетие детектор
    QVector<QPair<double, double> > m_pointSeries;    // Серия картинок, нужно для расшифровки движеия
    cv::VideoCapture m_cap;

    cv::Mat m_frame;
    cv::Mat m_hsv;
    cv::Mat m_binIm;

    int m_observeTimInterval;
    int m_observeTimId;

    std::vector<std::vector<cv::Point> > m_contours;
    Stick m_stick;
    cv::RotatedRect m_stickRect;

    int m_minH, m_minS, m_minV, m_maxH, m_maxS, m_maxV;

    QString m_actionPack;

    bool m_showImage;
    int m_camId;
};

#endif // MOTIONDETECTOR_H
