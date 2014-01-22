import QtQuick 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "Logic.js" as Logic

Window {
    id: window
    minimumHeight: 250
    minimumWidth: 600
    modality: Qt.ApplicationModal
    title: qsTr("Настройки цвета")

    Label {
        id: minHLabel
        anchors {margins: 10; left: parent.left; top: parent.top}
        width: 40
        height: 20
        text: qsTr("minH")
    }
    Slider {
        id: minHSlider
        anchors {verticalCenter: minHLabel.verticalCenter; left: minHLabel.right; right: minHValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMinH(value);
    }
    Label {
        id: minHValue
        anchors {verticalCenter: minHLabel.verticalCenter; right: parent.right; margins: 10}
        height: minHLabel.height
        width: minHLabel.width
        text: minHSlider.value
    }

    Label {
        id: minSLabel
        anchors {margins: 10; left: parent.left; top: minHLabel.bottom}
        width: 40
        height: 20
        text: qsTr("minS")
    }
    Slider {
        id: minSSlider
        anchors {verticalCenter: minSLabel.verticalCenter; left: minSLabel.right; right: minSValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMinS(value);
    }
    Label {
        id: minSValue
        anchors {verticalCenter: minSLabel.verticalCenter; right: parent.right; margins: 10}
        height: minSLabel.height
        width: minSLabel.width
        text: minSSlider.value
    }

    Label {
        id: minVLabel
        anchors {margins: 10; left: parent.left; top: minSLabel.bottom}
        width: 40
        height: 20
        text: qsTr("minV")
    }
    Slider {
        id: minVSlider
        anchors {verticalCenter: minVLabel.verticalCenter; left: minVLabel.right; right: minVValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMinV(value);
    }
    Label {
        id: minVValue
        anchors {verticalCenter: minVLabel.verticalCenter; right: parent.right; margins: 10}
        height: minVLabel.height
        width: minVLabel.width
        text: minVSlider.value
    }

    Label {
        id: maxHLabel
        anchors {margins: 10; left: parent.left; top: minVLabel.bottom}
        width: 40
        height: 20
        text: qsTr("maxH")
    }
    Slider {
        id: maxHSlider
        anchors {verticalCenter: maxHLabel.verticalCenter; left: maxHLabel.right; right: maxHValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMaxH(value);
    }
    Label {
        id: maxHValue
        anchors {verticalCenter: maxHLabel.verticalCenter; right: parent.right; margins: 10}
        height: maxHLabel.height
        width: maxHLabel.width
        text: maxHSlider.value
    }

    Label {
        id: maxSLabel
        anchors {margins: 10; left: parent.left; top: maxHLabel.bottom}
        width: 40
        height: 20
        text: qsTr("maxS")
    }
    Slider {
        id: maxSSlider
        anchors {verticalCenter: maxSLabel.verticalCenter; left: maxSLabel.right; right: maxSValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMaxS(value);
    }
    Label {
        id: maxSValue
        anchors {verticalCenter: maxSLabel.verticalCenter; right: parent.right; margins: 10}
        height: maxSLabel.height
        width: maxSLabel.width
        text: maxSSlider.value
    }

    Label {
        id: maxVLabel
        anchors {margins: 10; left: parent.left; top: maxSLabel.bottom}
        width: 40
        height: 20
        text: qsTr("maxV")
    }
    Slider {
        id: maxVSlider
        anchors {verticalCenter: maxVLabel.verticalCenter; left: maxVLabel.right; right: maxVValue.left; margins: 10}
        maximumValue: 255
        style: SliderStyle {}
        onValueChanged: Logic.md.motionDetector.setMaxV(value);
    }
    Label {
        id: maxVValue
        anchors {verticalCenter: maxVLabel.verticalCenter; right: parent.right; margins: 10}
        height: maxVLabel.height
        width: maxVLabel.width
        text: maxVSlider.value
    }
    Button {
        id: ok
        anchors {margins: 10; bottom: parent.bottom; right: parent.right}
        text: "Ok"
        onClicked: {window.visible = false}
    }
}
