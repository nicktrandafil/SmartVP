#include "motiondetector.h"
#include <qmath.h>
#include <QDebug>
#include <QTime>
#include <string>
#include <QtQml>

#ifdef QT_DEBUG
#include <QDebug>
#endif

Stick::Stick()
{
#ifdef QT_DEBUG
    qDebug() << "Stick created";
#endif
}

Stick::~Stick()
{
#ifdef QT_DEBUG
    qDebug() << "Stick deleted";
#endif
}

cv::Point Stick::top() const {return m_top;}
void Stick::setTop(const cv::Point &top) {m_top = top;}
cv::Point Stick::bottom() const {return m_bottom;}
void Stick::setBottom(const cv::Point &bottom) {m_bottom = bottom;}

MotionDetector::MotionDetector(QObject *parent) :
    QObject(parent),
    m_state(ST_WAITING),
    m_arAtThreshold(1000),
    m_observeTimInterval(1000 / 30/*FPS*/),
    m_observeTimId(-1),
    m_showImage(false),
    m_camId(0), m_maxH(0), m_maxS(0), m_maxV(0), m_minH(0), m_minS(0), m_minV(0)
{
#ifdef QT_DEBUG
    qDebug() << "MotionDetector created";
#endif
}

MotionDetector::~MotionDetector()
{
#ifdef QT_DEBUG
    qDebug() << "MotionDetecot deleted";
#endif
}

void MotionDetector::beginSession(bool begin)
{
    if (begin){
        m_cap.open(m_camId);
        m_observeTimId = startTimer(m_observeTimInterval);
    } else{
        // убираемся за собой
        if (m_observeTimId != -1)
            killTimer(m_observeTimId);
        m_observeTimId = -1;
        m_pointSeries.clear();
        m_cap.release();
        m_frame.release();
        m_hsv.release();
        m_binIm.release();
        m_contours.clear();
    }
}

void MotionDetector::observCam()
{
    m_cap >> m_frame;
    filterIm();
    detectStick();
    drawStick(m_binIm);
    showIms();
}

void MotionDetector::setMinH(int v) {m_minH = v;}
void MotionDetector::setMinS(int v) {m_minS = v;}
void MotionDetector::setMinV(int v) {m_minV = v;}
void MotionDetector::setMaxH(int v) {m_maxH = v;}
void MotionDetector::setMaxS(int v) {m_maxS = v;}
void MotionDetector::setMaxV(int v) {m_maxV = v;}

void MotionDetector::setShowImage(bool show)
{
    // Создается окно в motionWrapper, в основном потоке, т.к. gui должно работать в основном потоке.
    // Здесь окна только уничтожаются.
    m_showImage = show;
    if (!show)
        cv::destroyWindow("bin");
}

void MotionDetector::resetCam(int camId)
{
    bool wasObserving = false;
    if (m_observeTimId != -1){ // Если ведется, то наблюдение прекращаем
        beginSession(false);
        wasObserving = true;
    }
    m_camId = camId;
    if (wasObserving)       // Если велось наблюдение возобновляем
        beginSession(true);
}

void MotionDetector::filterIm()
{
    m_hsv = m_frame.clone();
    m_binIm = m_frame.clone();
    cv::cvtColor(m_frame, m_hsv, CV_RGB2HSV);
    // работаем с m_hsv изображением, в результате получаем m_binIm
    cv::inRange(m_hsv, cv::Scalar(m_minH, m_minS, m_minV), cv::Scalar(m_maxH, m_maxS, m_maxV), m_binIm);
}

void MotionDetector::detectStick()
{
    m_contours.clear();
    cv::findContours(m_binIm.clone(), m_contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    if (m_contours.empty())
        return;
    bool stickFound = false;
    for(int i = 0; i < m_contours.size(); ++i)
    {
        // если объект очень маленький, то пропускаем его
        if(cv::contourArea(m_contours[i]) < m_arAtThreshold)
            continue;

        // находим концы карандаша. top - это тот коненец, который всегда выше. код ниже работат(сам не знаю как),
        // лучше не лезть.
        m_stickRect = cv::minAreaRect(m_contours[i]);
        cv::Point2f vertices[4];
        cv::Point top;
        cv::Point bottom;
        m_stickRect.points(vertices);
        if (lineLength(vertices[0], vertices[1]) > lineLength(vertices[1], vertices[2])){
            top = cv::Point((vertices[1].x + vertices[2].x) / 2., (vertices[1].y + vertices[2].y) / 2.);
            bottom = cv::Point((vertices[0].x + vertices[3].x) / 2., (vertices[0].y + vertices[3].y) / 2.);
        } else{
            top = cv::Point((vertices[0].x + vertices[1].x) / 2., (vertices[0].y + vertices[1].y) / 2.);
            bottom = cv::Point((vertices[2].x + vertices[3].x) / 2., (vertices[2].y + vertices[3].y) / 2.);
        }
        if (top.y > bottom.y)
            qSwap(top, bottom);
        m_stick.setTop(top);
        m_stick.setBottom(bottom);
        stickFound = true;
    }

    // проверяем состояние
    switch (m_state){
    case ST_OBSERVING:
        if (!stickFound){
            m_state = ST_WAITING;
            m_pointSeries.clear();
        } else
        {
            m_pointSeries.append(QPair<double, double>(m_stick.top().x, m_stick.top().y));
            if (m_pointSeries.size() >= 10){
                m_actionPack = SeriesAnaliser::analize(m_pointSeries);
                if (!m_actionPack.isEmpty()){
                    emit sendAction(m_actionPack);
                }
                m_pointSeries.clear();
            }
        }
        break;
    case ST_WAITING:
        m_state = ST_OBSERVING;
        break;
    }
}

void MotionDetector::showIms() const
{
    if (m_showImage)
        cv::imshow("bin", m_binIm);
}

void MotionDetector::drawStick(cv::Mat &im)
{
    cv::Point2f vertices[4];
    m_stickRect.points(vertices);
    for (int i = 0; i < 4; i++){
        cv::line(im, vertices[i], vertices[(i+1)%4], cv::Scalar(0,255,0));
    }
    cv::circle(im, m_stick.top(), 10, cv::Scalar(0, 0, 255));
    cv::circle(im, m_stick.bottom(), 10, cv::Scalar(0, 0, 255));
    cv::line(im, m_stick.top(), m_stick.bottom(), cv::Scalar(0, 0, 255));

}

double MotionDetector::lineLength(const cv::Point2f &p1, const cv::Point2f &p2) const
{
    return qSqrt(qPow(p1.x - p2.x, 2) + qPow(p1.y - p2.y, 2));
}

void MotionDetector::timerEvent(QTimerEvent *event)
{
    Q_UNUSED(event);
    observCam();
}

double SeriesAnaliser::s_fps = 1000 / (1000 / 30);
QString SeriesAnaliser::s_actionPack;
SeriesAnaliser::SeriesAnaliser(QObject *parent) : QObject(parent)
{
#ifdef QT_DEBUG
    qDebug() << "SeriesAnaliser created";
#endif
}

SeriesAnaliser::~SeriesAnaliser()
{
#ifdef QT_DEBUG
    qDebug() << "SeriesAnaliser deleted";
#endif
}

QString SeriesAnaliser::analize(const QVector<QPair<double, double> > &source)
{
    s_actionPack.clear();
    if (linerCheck(source)){
        return s_actionPack;
    }

    return s_actionPack;
}

bool SeriesAnaliser::linerCheck(const QVector<QPair<double, double> > &source)
{
    int count = source.size();

    // скопируем значения в 2 отдельных массива, чтобы понятнее было.
    QVector<double> x(count);
    QVector<double> y(count);

    for (int i = 0; i < count; ++i){
        x[i] = source[i].first;
        y[i] = source[i].second;
    }

    double zX, zY, zX2, zXY;    // z - обнозначение знака суммы. zX - сумма x-ов и т.д.
    QVector<double> yT(count);
    // подготовка переданных
    zX = 0;
    for (int i = 0; i < count; ++i)
        zX += x[i];

    zY = 0;
    for (int i = 0; i < count; ++i)
        zY += y[i];

    zX2 = 0;
    for (int i = 0; i < count; ++i)
        zX2 += x[i] * x[i];

    zXY = 0;
    for (int i = 0; i < count; ++i)
        zXY += x[i] * y[i];

    // вычисление коэффициетов уравнения
    double a = (count * zXY - zX * zY) / (count * zX2 - zX * zX);
    double b = (zX2 * zY - zX * zXY) / (count * zX2 - zX * zX);

    // нахождение теоретического y
    for (int i = 0; i < count; ++i)
        yT[i] = x[i] * a + b;

    double dif = 0;
    for (int i = 0; i < count; ++i){
        dif += qAbs(yT[i] - y[i]);
    }
    if (a == 0)
        a = 10;

#ifdef QT_DEBUG
    qDebug() << QString("%1x+%2").arg(a).arg(b);
    qDebug() << dif;
#endif

    // если а > 3, то это, сокорее всего, вертикальная линия
    // если погрешность больше 70, то это, скорее всего, случайное движение
    // если 0.5 < a < 1.5, то это, скорее всего, косая линия
    // если скорость больше 0.6, то это, скорее всего, случайное движеие

    // Если погрешность очень большая, то выход
    if (qAbs(a) < 3 && dif > 70)
        return false;

    // вычисление скорости
    double msInFrame = 1000 / s_fps;
    double dTime = msInFrame * count;   // ms
    double dDistance;                   // px
    double speed = 0;  /*px per ser*/
    if (qAbs(a) < 3)
        dDistance = x[count - 1] - x[0];            // если вертикальная линия
    else
        dDistance = y[count -1] - y[0];
    speed = dDistance / dTime; //px per

    // если палочка не двигается, выход
    if (qSqrt(qPow(x[0] - x[count - 1], 2) + qPow(y[0] - y[count - 1], 2)) < 15){
        return false;
    }

    // резкие движения вероятно случайные.
    if (speed > 0.6)
        return false;

    // отправка пакета
    if (qAbs(a) > 0.5 && qAbs(a) < 1.5){
        // Переключение
        if (a < 0){
            // следующая дорожка
            s_actionPack = "next";
        } else{
            if (speed < 0)
                s_actionPack = "play";
            else
                // предыдущая дорожка
                s_actionPack = "previous";
        }
    } else
        if (qAbs(a) < 0.3)
        {
            s_actionPack = QString("rewind %1").arg(speed * -30000);
        } else
            if (qAbs(a) > 3){
                s_actionPack = QString("volume %1").arg(speed * -1);
            } else
                return false;

    return true;
}
/*Протокол общения
 * next, previous, play, rewind delta, volume delta
 */
