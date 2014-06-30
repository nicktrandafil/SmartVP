import QtQuick 2.3
import QtQuick.Window 2.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import "Logic.js" as Logic
import QtQuick.Dialogs 1.2

Window {
    id: window
    minimumHeight: 250
    minimumWidth: 600
    modality: Qt.ApplicationModal
    title: qsTr("Настройка цвета")

    property alias minH: minHSlider.value
    property alias minS: minSSlider.value
    property alias minV: minVSlider.value
    property alias maxH: maxHSlider.value
    property alias maxS: maxSSlider.value
    property alias maxV: maxVSlider.value

    signal initColors(var text)

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
        anchors {verticalCenter: minHLabel.verticalCenter; right: parent.right; margins: 10;}
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
        focus: true
        Keys.onReturnPressed: ok.clicked()
    }
    Button {
        id: save
        anchors {margins: 10; bottom: parent.bottom; right: ok.left}
        text: qsTr("Добавить в меню")
        onClicked: inputDialog.visible = true
    }
    Window {
        id: inputDialog
        modality: Qt.ApplicationModal
        title: qsTr("Название цвета")
        width: 400
        height: 80
        Item {
            anchors.fill: parent
            Keys.onReturnPressed: accept.clicked();
            Keys.onEscapePressed: reject.clicked();
            focus: true
            Label {
                id: textInputLabel
                text: qsTr("Введие название цвета: ")
                width: paintedWidth
                height: paintedHeight
                anchors {margins: 10; left: parent.left; top: parent.top}
            }
            Rectangle {
                height: textInputLabel.height + 2
                anchors { left: textInputLabel.right; right: parent.right; verticalCenter: textInputLabel.verticalCenter; margins: 10 }
                border.width: 1
                TextInput {
                    id: textInput
                    anchors { fill: parent; leftMargin: 2; rightMargin: 2 }
                }
            }
            Button {
                id: accept
                anchors {margins: 10; bottom: parent.bottom; right: parent.right}
                text: "Ok"
                onClicked: {window.initColors(textInput.text + String(" %1 %2 %3 %4 %5 %6").arg(minH).arg(minS).arg(minV).arg(maxH).arg(maxS).arg(maxV));
                    inputDialog.visible = false}
            }
            Button {
                id: reject
                anchors { margins: 10; bottom: parent.bottom; right: accept.left }
                text: qsTr("Отмена")
                onClicked: inputDialog.visible = false
            }
        }
    }
}
