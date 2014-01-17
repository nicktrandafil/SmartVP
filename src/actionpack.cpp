#include "actionpack.h"

ActionPack::ActionPack()
{
    m_action = ActionPack::AC_UNDEFINED;
}

ActionPack::ActionPack(ActionPack::Action action, double force)
{
    m_action = action;
    m_delta = force;
}

bool ActionPack::isValid() const
{
    return m_action != AC_UNDEFINED;
}
ActionPack::Action ActionPack::action() const
{
    return m_action;
}

void ActionPack::setAction(const Action &action)
{
    m_action = action;
}
double ActionPack::delta() const
{
    return m_delta;
}

void ActionPack::setDelta(double force)
{
    m_delta = force;
}
QString ActionPack::message() const
{
    return m_message;
}

void ActionPack::setMessage(const QString &message)
{
    m_message = message;
}
