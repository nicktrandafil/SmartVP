import QtQuick 2.0
import QtQuick.Controls 1.1
import "Logic.js" as Logic

MenuBar {
    id: menuBar
    signal openFile
    signal quit
    signal openVideoSettings
    signal chooseColor

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
            text: qsTr("&Настройки")
            onTriggered: menuBar.openVideoSettings()
        }

        MenuItem {
            text: qsTr("&Ручное управление");
            shortcut: "Ctrl+H"
            checkable: true
            onCheckedChanged: Logic.md.beginSession(checked)
        }
        Menu {
            title: qsTr("Цвет")
            MenuItem {
                text: qsTr("Оранжевый")
                onTriggered: {
                    Logic.md.motionDetector.setMinH(value);
                    Logic.md.motionDetector.setMinS(value);
                    Logic.md.motionDetector.setMinV(value);
                    Logic.md.motionDetector.setMaxV(value);
                    Logic.md.motionDetector.setMaxV(value);
                    Logic.md.motionDetector.setMaxV(value);
                }
            }
            MenuItem {
                text: qsTr("Оранжевый")
                onTriggered: {

                }
            }

            MenuSeparator {}
            MenuItem {
                text: qsTr("Выбрать цвет...")
                onTriggered: menuBar.chooseColor()
            }
        }
        MenuItem {
            text: qsTr("Камера")
            checkable: true
            onCheckedChanged: Logic.md.showDetection(checked)
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
            shortcut: "F1"
        }
    }
}
