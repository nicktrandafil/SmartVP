import QtQuick 2.0
import QtQuick.Controls 1.1

MenuBar {
    id: menuBar
    signal openFile
    signal quit

    Menu {
        title: qsTr("&Файл")
        MenuItem {
            text: qsTr("&Открыть...")
            onTriggered: menuBar.openFile()
        }
        MenuItem {
            text: qsTr("&Выход")
            onTriggered: menuBar.quit()
        }
    }
    Menu {
        title: qsTr("&Управление")
    }
    Menu {
        title: qsTr("&Помощь")
    }
}
