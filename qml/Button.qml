import QtQuick 2.0

Rectangle {
    id: button
    signal clicked
    property alias source: icon.source
    Image {
        id: icon
        anchors.fill: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: button.onClicked()
        onPressed: {
            icon.anchors.leftMargin = 1;
            icon.anchors.topMargin = 1
        }
        onReleased: {
            icon.anchors.leftMargin = 0;
            icon.anchors.topMargin = 0
        }
    }
}
