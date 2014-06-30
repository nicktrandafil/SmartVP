import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import "Logic.js" as Logic

Window {
    id: window
    minimumHeight: 100
    minimumWidth: 400
    modality: Qt.ApplicationModal
    title: qsTr("Настройки")

    Label {
        id: camLabel
        anchors {margins: 10; left: parent.left; top: parent.top}
        width: paintedWidth
        height: paintedHeight
        text: qsTr("Камера")
    }
    ComboBox {
        id: camBox
        anchors {margins: 10; verticalCenter: camLabel.verticalCenter; left: camLabel.right; right: parent.right}
        height: 30
        model: camModel
    }
    ListModel {
        id: camModel
        ListElement {
            text: ""
        }
    }
    Button {
        id: ok
        anchors {margins: 10; bottom: parent.bottom; right: cencel.left}
        text: "Ok"
        onClicked: { Logic.md.resetCam(camModel.get(camBox.currentIndex).device); window.visible = false}
    }

    Button {
        id: cencel
        anchors {margins: 10; bottom: parent.bottom; right: parent.right}
        text: "Cencel"
        onClicked: window.visible = false
    }

    function initModel(){
        for (var i = 0; i <= Logic.helper.devices.length / 2; i += 2)
            camModel.append({"text": Logic.helper.devices[i], "device": Logic.helper.devices[i + 1]})
        camBox.currentIndex = 1;
        camModel.remove(0);
    }
}
