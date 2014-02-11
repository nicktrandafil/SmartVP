import QtQuick 2.0
import QtQuick.Controls 1.1
import "Logic.js" as Logic

MenuBar {
    id: menuBar
    signal openFile
    signal quit
    signal openVideoSettings
    signal chooseColor
    signal about
    signal help
    signal handControl(var b)
    signal camera(var b)

    function initColors(text){
        Logic.updateColors(colorMenu, text);
        Logic.initColors(colorMenu);
    }

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
            onCheckedChanged: menuBar.handControl(checked)
        }
        Menu {
            id: colorMenu
            title: qsTr("Цвет")
            MenuSeparator {objectName: "separator"}
            MenuItem {
                text: qsTr("Выбрать цвет...")
                onTriggered: menuBar.chooseColor()
            }
            Component.onCompleted: Logic.initColors(colorMenu)
        }
        MenuItem {
            text: qsTr("Камера")
            checkable: true
            onCheckedChanged: menuBar.camera(checked)
        }
    }
    Menu {
        title: qsTr("&Помощь")
        MenuItem {
            text: qsTr("О &программе...")
            onTriggered: menuBar.about()
        }
        MenuItem {
            text: qsTr("&Справка...")
            shortcut: "F1"
            onTriggered: menuBar.help()
        }
    }
}
