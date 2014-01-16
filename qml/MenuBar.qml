import QtQuick 2.0
import QtQuick.Controls 1.1
import "Logic.js" as Logic

MenuBar {
    id: menuBar
    signal openFile
    signal quit

    Menu {
        title: qsTr("&Файл")
        MenuItem {
            text: qsTr("&Открыть...")
            onTriggered: menuBar.openFile()
            shortcut: "Ctrl+O"
        }
        MenuItem {
            text: qsTr("&Выход")
            onTriggered: menuBar.quit()
            shortcut: "Ctrl+Q"
        }
    }
    Menu {
        title: qsTr("&Управление")
        MenuItem {
            text: qsTr("&Ручное управление");
            shortcut: "Ctrl+H"
        }
    }
    Menu {
        title: qsTr("&Помощь")
        MenuItem {
            text: qsTr("О &программе...")
            onTriggered: {Logic.information(qsTr("О программе"), Logic.helper.readFile(":resources/About.txt"));}
        }
        MenuItem {
            text: qsTr("&Справка...")

        }
    }
}
