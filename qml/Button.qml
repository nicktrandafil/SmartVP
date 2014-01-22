import QtQuick 2.2
import QtQuick.Controls 1.1
import "Tooltip.js" as Tooltip

Rectangle {
    id: button
    property bool hovered: mouseArea.containsMouse
    property alias iconSource: icon.source
    signal clicked

    Image {
        id: icon
        anchors.fill: parent
    }
    MouseArea {
        id: mouseArea
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
        onEntered: {
            Tooltip.fadeInDelay = 500;
            Tooltip.fadeOutDelay = 700;
            Tooltip.tip = "This is tooltip!";
            Tooltip.mainWindow = button
            console.log(mouseArea.mouseX)
            Tooltip.show();
        }
        onExited: {
            Tooltip.close();
        }
    }
}
