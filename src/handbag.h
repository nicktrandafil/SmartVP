#ifndef HANDBAG_H
#define HANDBAG_H

#include <opencv/cv.h>

class Stick
{
public:
    Stick() { valid = false; }
    Stick(const cv::Point &t, const cv::Point &b) : top(t), bottom(b), valid(true) { }
    bool isValid() const { return valid; }

    cv::Point getTop() const { return top; }
    void setTop(const cv::Point &value) { top = value; }

    cv::Point getBottom() const { return bottom; }
    void setBottom(const cv::Point &value) { bottom = value; }

private:
    cv::Point top;
    cv::Point bottom;
    bool valid;
};

#endif // HANDBAG_H
