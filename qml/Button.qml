import QtQuick 2.0

Rectangle {
    id: button
    property bool hover: false
    signal clicked
    property alias source: icon.source
    Image {
        id: icon
        anchors.fill: parent
    }
    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            button.clicked()
        }
        onPressed: {
            icon.anchors.leftMargin = 1;
            icon.anchors.topMargin = 1
        }
        onReleased: {
            icon.anchors.leftMargin = 0;
            icon.anchors.topMargin = 0
        }
        onEntered: hover = true
        onExited: hover = false
    }
}
