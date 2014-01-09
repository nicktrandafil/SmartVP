import QtQuick 2.0
import "."

Rectangle {
    id: manuBar
    // Раземеры и расположение
    anchors {top: parent.top; left: parent.left}
    height: Settings.menuBarHeight
    width: parent.width

    Item {
        id: file
        anchors {top: parent.top; left: parent.left}
        width: 50
        height: parent.height
        Text {
            id: fileText
            anchors.fill: parent
            text: qsTr("File")
        }
    }

    Item {
        id: control
        anchors {left: file.right}
        width: 50
        height: parent.height

        Text {
            id: controlText
            anchors.fill: parent
            text: qsTr("Control")
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                listView.visible = true
                listView.anchors.top = parent.bottom
                listView.anchors.left = parent.left
            }
        }

        ListView {
            id: listView
            anchors.topMargin: 1
            model: listModel
            delegate: delegate
            visible: false
            width: 50
            height: 50

            Behavior on y {
                SpringAnimation { spring: 0.2; damping: 2; duration: 1000}
            }

            Rectangle {
                anchors.fill: parent
                color: systemPallete.window
                z: -1
            }

        }
        ListModel {
            id: listModel

            ListElement {
                name: "Abc"
            }
            ListElement {
                name: "Def"
            }
            ListElement {
                name: "Zya"
            }
        }
        Component {
            id: delegate
            Row {
                spacing: 10
                Text {text: name}
            }
        }
    }

    // Установка цвета
    property SystemPalette systemPallete
    onSystemPalleteChanged: if (systemPallete != 0) manuBar.color = systemPallete.window
}
