#ifndef ACTIONPACK_H
#define ACTIONPACK_H

#include <QString>

// Расшифрованное действие, которые будем отправлять плееру.
class ActionPack
{
public:
    enum Action{AC_UNDEFINED,AC_VOLUME, AC_REWIND, AC_NEXT, AC_PREVIOUS,
                AC_MESSAGE, AC_STOP, AC_PLAY};
    ActionPack();
    ActionPack(ActionPack::Action action, double delta);

    // Proprieties
    bool isValid() const;
    Action action() const;
    void setAction(const Action &action);
    double delta() const;
    void setDelta(double delta);
    QString message() const;
    void setMessage(const QString &message);
    
private:
    Action m_action;
    double m_delta;         // Сила совершаемого действия(в процентах)
    QString m_message;
};

#endif // ACTIONPACK_H
