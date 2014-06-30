#include "motiondetector.h"

#include <QtCore/QDebug>
#include <QtCore/QDebug>
#include <QtCore/QTime>

#include <QtQml>

#include <qmath.h>
#include <string>

MotionDetector::MotionDetector(QObject *parent) :
    QObject(parent),
    m_state(ST_WAITING),
    m_arAtThreshold(1000),
    m_observeTimInterval(1000 / 30/*FPS*/),
    m_observeTimId(-1),
    m_camId(0), m_maxH(0), m_maxS(0), m_maxV(0), m_minH(0), m_minS(0), m_minV(0)
{
    qDebug() << "MotionDetector created";
}

MotionDetector::~MotionDetector()
{
    qDebug() << "MotionDetecot deleted";
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
    }
}

void MotionDetector::observCam()
{
    cv::Mat frame;
    m_cap >> frame;
    cv::Mat bin = filterIm(frame);

    Stick stick = detectStick(bin);
    if (stick.isValid())
    {
        accumulator(stick.getTop());
        drawStick(bin, stick);
    }
    emit showIm(bin);
}

void MotionDetector::setMinH(int v) { m_minH = v; }
void MotionDetector::setMinS(int v) { m_minS = v; }
void MotionDetector::setMinV(int v) { m_minV = v; }
void MotionDetector::setMaxH(int v) { m_maxH = v; }
void MotionDetector::setMaxS(int v) { m_maxS = v; }
void MotionDetector::setMaxV(int v) { m_maxV = v; }

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

cv::Mat MotionDetector::filterIm(const cv::Mat &frame)
{
    cv::Mat hsv = frame.clone();
    cv::Mat binIm = frame.clone();

    cv::cvtColor(frame, hsv, CV_RGB2HSV);

    // работаем с m_hsv изображением, в результате получаем m_binIm
    cv::inRange(hsv, cv::Scalar(m_minH, m_minS, m_minV), cv::Scalar(m_maxH, m_maxS, m_maxV), binIm);

    return binIm;
}

Stick MotionDetector::detectStick(const cv::Mat &binIm)
{
    std::vector<std::vector<cv::Point> > contours;

    cv::findContours(binIm.clone(), contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    if (contours.empty())
        return Stick();

    bool stickFound = false;
    cv::Point top;          // Веришины карандаша
    cv::Point bottom;

    for(int i = 0; i < contours.size() && !stickFound; ++i)
    {
        // если объект очень маленький, то пропускаем его
        if(cv::contourArea(contours[i]) < m_arAtThreshold)
            continue;

        // находим концы карандаша. top - это тот коненец, который всегда выше. код ниже работат(сам не знаю как),
        // лучше не лезть.
        cv::RotatedRect stickRect = cv::minAreaRect(contours[i]);
        cv::Point2f vertices[4];
        stickRect.points(vertices);
        if (lineLength(vertices[0], vertices[1]) > lineLength(vertices[1], vertices[2])){
            top = cv::Point((vertices[1].x + vertices[2].x) / 2., (vertices[1].y + vertices[2].y) / 2.);
            bottom = cv::Point((vertices[0].x + vertices[3].x) / 2., (vertices[0].y + vertices[3].y) / 2.);
        } else{
            top = cv::Point((vertices[0].x + vertices[1].x) / 2., (vertices[0].y + vertices[1].y) / 2.);
            bottom = cv::Point((vertices[2].x + vertices[3].x) / 2., (vertices[2].y + vertices[3].y) / 2.);
        }
        if (top.y > bottom.y)
            qSwap(top, bottom);
        stickFound = true;
    }
    if (stickFound)
        return Stick(top, bottom);
    else
        return Stick();
}

void MotionDetector::accumulator(const cv::Point &top)
{
    m_pointSeries.append(QPair<double, double>(top.x, top.y));
    if (m_pointSeries.size() >= 10){
        QString actionPack = SeriesAnaliser::analize(m_pointSeries);
        if (!actionPack.isEmpty()){
            emit sendAction(actionPack);
        }
        m_pointSeries.clear();
    }
}

void MotionDetector::drawStick(cv::Mat &im, const Stick &stick)
{
    cv::Point2f vertices[4];
    for (int i = 0; i < 4; i++){
        cv::line(im, vertices[i], vertices[(i+1)%4], cv::Scalar(0,255,0));
    }
    cv::circle(im, stick.getTop(), 10, cv::Scalar(0, 0, 255));
    cv::circle(im, stick.getBottom(), 10, cv::Scalar(0, 0, 255));
    cv::line(im, stick.getTop(), stick.getBottom(), cv::Scalar(0, 0, 255));
}

void MotionDetector::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == m_observeTimId)
        observCam();
}

double MotionDetector::lineLength(const cv::Point2f & p1, const cv::Point2f & p2) const
{
    return qSqrt(qPow(p1.x - p2.x, 2) + qPow(p1.y - p2.y, 2));
}

double SeriesAnaliser::s_fps = 1000 / (1000 / 30);
QString SeriesAnaliser::s_actionPack;
SeriesAnaliser::SeriesAnaliser(QObject *parent) : QObject(parent)
{
    qDebug() << "SeriesAnaliser created";
}

SeriesAnaliser::~SeriesAnaliser()
{
    qDebug() << "SeriesAnaliser deleted";
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

    qDebug() << QString("%1x+%2").arg(a).arg(b);
    qDebug() << dif;

    // если а > vBorder, то это, сокорее всего, вертикальная линия
    // если погрешность больше epsilan, то это, скорее всего, случайное движение
    // если oblMovMin < a < oblMovMax, то это, скорее всего, косая линия
    // если скорость больше 0.6, то это, скорее всего, случайное движеие
    // если a < horMov, то это, скорее всего, горизонтально

    int vBorder = 3;
    int epsilan = 50;
    double oblMovMin = 0.5;
    double oblMovMax = 1.5;
    double horMov = 0.3;

    // Если погрешность очень большая, то выход
    if (qAbs(a) < vBorder && dif > epsilan)
        return false;

    // вычисление скорости
    double msInFrame = 1000 / s_fps;
    double dTime = msInFrame * count;   // ms
    double dDistance;                   // px
    double speed = 0;  /*px per ser*/
    if (qAbs(a) < vBorder)
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
    if (qAbs(a) > oblMovMin && qAbs(a) < oblMovMax){
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
        if (qAbs(a) < horMov)
        {
            s_actionPack = QString("rewind %1").arg(speed * -30000);
        } else
            if (qAbs(a) > vBorder){
                s_actionPack = QString("volume %1").arg(speed * -1);
            } else
                return false;

    return true;
}
/*Протокол общения
 * next, previous, play, rewind delta, volume delta
 */
