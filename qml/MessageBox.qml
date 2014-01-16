import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.1

Window {
    id: messageBox
    modality: Qt.ApplicationModal
    title: ""
    property alias text: messageBoxLabel.text
    minimumHeight: 100
    minimumWidth: 300
    Label {
        anchors.margins: 10
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: messageBoxButton.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        id: messageBoxLabel
        text: ""
    }
    Button {
        anchors.margins: 10
        id: messageBoxButton
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Ok"
        onClicked: messageBox.visible = false
    }
}
