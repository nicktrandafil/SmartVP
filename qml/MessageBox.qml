import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

Window {
    id: messageBox
    modality: Qt.ApplicationModal
    property alias text: messageBoxLabel.text
    title: ""
    width: 500
    height: 200
    ScrollView {
        anchors { top: parent.top; left: parent.left; right: parent.right; bottom: messageBoxButton.top; bottomMargin: 10}
        Label {
            id: messageBoxLabel
            width: 500
            anchors.margins: 10
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            text: ""
        }
        focus: true
        Keys.onReturnPressed: messageBoxButton.clicked()
    }
    Button {
        id: messageBoxButton
        anchors.margins: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Ok"
        onClicked: messageBox.visible = false
    }
}
