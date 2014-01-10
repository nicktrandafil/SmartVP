import QtQuick 2.0

Rectangle {
    signal clicked
    id: previdous
    Image {
        id: previousIcon
        anchors.fill: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: previdous.onClicked()
        onPressed: {
            previousIcon.anchors.leftMargin = 1;
            previousIcon.anchors.topMargin = 1
        }
        onReleased: {
            previousIcon.anchors.leftMargin = 0;
            previousIcon.anchors.topMargin = 0
        }
    }
}
