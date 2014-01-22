import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtMultimedia 5.0
import "Logic.js" as Logic
import QtQuick.Window 2.1
import MotionDetectorWrapper 1.0
import "."

Item {
    id: player
    property SystemPalette systemPallete
    SplitView {
        id: splitView
        anchors.fill: parent
        onWidthChanged: {
            videoOutputAndControls.width = splitView.width * 0.8
        }
        Item {
            id: videoOutputAndControls
            Item {
                id: itemForBenweenMargin
                anchors {fill: parent; rightMargin: 5}
                MediaPlayer {
                    id: mediaPlayer
                }
                Rectangle {
                    id: bkgd
                    color: "black"
                    width: parent.width
                    anchors {top: parent.top; bottom: videoControl.top; bottomMargin: 5}
                    VideoOutput {
                        id: videoOutput
                        source: mediaPlayer
                        anchors.fill: parent
                    }
                    MouseArea {
                        id: screenEvents
                        anchors.fill: parent
                        hoverEnabled: true
                        onPositionChanged: if (fullScreenWindow.visible) {
                                               videoControl.height = Settings.videoControl;
                                               screenEvents.cursorShape = Qt.ArrowCursor;
                                               videoControlHidder.restart();
                                           }
                        onClicked: {
                            if (mediaPlayer.playbackState == MediaPlayer.PlayingState)
                                mediaPlayer.pause();
                            else
                                if (mediaPlayer.playbackState == MediaPlayer.PausedState)
                                    mediaPlayer.play();
                        }
                        Timer {
                            id: videoControlHidder
                            interval: 4000
                            repeat: false
                            running: false
                            onTriggered: if (fullScreenWindow.visible  && screenEvents.containsMouse){
                                             videoControl.height = 0; screenEvents.cursorShape = Qt.BlankCursor}
                        }
                    }
                }
                Rectangle {
                    id: videoControl
                    Behavior on height { SpringAnimation { spring: 2; damping: 0.2 } }
                    anchors {bottom: parent.bottom; left: parent.left}
                    width: parent.width
                    height: Settings.videoControl
                    Button {
                        id: previdousButton
                        anchors {left: parent.left; top: parent.top}
                        width: height
                        height: parent.height
                        iconSource: "qrc:///resources/icons/Previous.png"
                        onClicked: if (mediaPlayer.position > 3000) Logic.replayMedia(); else Logic.previousMedia()
                    }
                    Button {
                        id: playButton
                        anchors { left: previdousButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        iconSource: mediaPlayer.playbackState == 2 ? "qrc:///resources/icons/Play.png" :
                                                                mediaPlayer.playbackState == 1 ? "qrc:///resources/icons/Pause.png" :
                                                                                    "qrc:///resources/icons/Play.png"
                        onClicked: Logic.playMedia()
                    }
                    Button {
                        id: nextButton
                        anchors { left: playButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        iconSource: "qrc:///resources/icons/Next.png"
                        onClicked: Logic.nextMedia()
                    }
                    Button {
                        id: fullScreenButton
                        state: "MinScreen"
                        anchors {left: nextButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        onClicked: if (mediaPlayer.playbackState != 0)
                                       if (state == "FullScreen") fullScreenWindow.visible = false;
                                       else fullScreenWindow.visibility = Window.FullScreen
                        states: [
                            State {
                                name: "FullScreen"
                                when: fullScreenWindow.visible
                                PropertyChanges {
                                    target: fullScreenButton
                                    iconSource: "qrc:///resources/icons/MinScreen.png"
                                }
                                PropertyChanges {
                                    target: itemForBenweenMargin
                                    parent: fullScreenWindowContent
                                    anchors.fill: parent
                                    anchors.rightMargin: 0
                                }
                                PropertyChanges {
                                    target: videoControl
                                    height: 0
                                }
                                PropertyChanges {
                                    target: bkgd
                                    anchors.bottomMargin: 0
                                    anchors.fill: parent
                                }
                            },
                            State {
                                name: "MinScreen"
                                when: !fullScreenWindow.visible
                                PropertyChanges
                                {target: fullScreenButton
                                    iconSource: "qrc:///resources/icons/FullScreen.png"
                                }
                            }
                        ]
                    }
                    Rectangle {
                        id: label
                        anchors { right: volumeButton.left; top: parent.top; rightMargin: 5}
                        width: duratinInfo.paintedWidth
                        height: previdousButton.height
                        Text {
                            id: duratinInfo
                            anchors.fill: parent

                        }
                        Connections {
                            target: mediaPlayer
                            onPositionChanged: duratinInfo.text = Logic.helper.duration(mediaPlayer.position / 1000,
                                                                                  mediaPlayer.duration / 1000)
                        }
                    }
                    Button {
                        id: volumeButton
                        anchors { right: parent.right; top: parent.top; leftMargin: 5}
                        width: previdousButton.width
                        height: width
                        iconSource: "qrc:///resources/icons/Volume.png"
                        onHoveredChanged: if (hovered) {volumeSlider.visible = true} else
                                        {volumeSlider.visible = false}
                        Slider {
                            id: volumeSlider
                            style: SliderStyle {}
                            value: mediaPlayer.volume
                            maximumValue: 1.0
                            width: parent.width
                            onHoveredChanged: if (hovered) {visible = true} else {visible = false}
                            visible: false
                            orientation: Qt.Vertical
                            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
                            height: 80
                            onValueChanged: mediaPlayer.volume = value
                        }
                        states: [
                            State {name: "Mute"; PropertyChanges{target: volumeButton; iconSource: "qrc:///resources/icons/Mute.png"}}
                        ]
                    }
                    Slider {
                        id: positionSlider
                        style: SliderStyle {}
                        anchors { top: parent.top; left: fullScreenButton.right; right: label.left; leftMargin: 5; rightMargin: 5}
                        maximumValue: mediaPlayer.duration
                        value: mediaPlayer.position
                        onValueChanged: {
                            if (pressed) {
                                mediaPlayer.seek(value);
                                newPosition.x = width /  mediaPlayer.duration * mediaPlayer.position;
                                newPosition.text = Logic.helper.newDuration(mediaPlayer.position / 1000);
                            }
                        }
                        Text {
                            id: newPosition;
                            visible: newPositionEvents.containsMouse && mediaPlayer.playbackState != 0
                            y: parent.y - 7;
                            color: "green"
                        }
                        MouseArea {
                            id: newPositionEvents
                            propagateComposedEvents: true
                            onPressed: mouse.accepted = false;
                            anchors.fill: parent
                            hoverEnabled: true
                            onPositionChanged: {
                                newPosition.x = mouse.x;
                                newPosition.text = Logic.helper.newDuration((mediaPlayer.duration / width * mouse.x) / 1000);
                            }
                        }
                    }
                }
            }
        }
        Item {
            id: listViewAndControls
            ListView {
                id: listView
                anchors {top: parent.top; bottom: playlistControl.top; bottomMargin: 5}
                property var playIndex: null
                width: parent.width
                height: parent.height
                header: Component {
                    Rectangle{
                        height: 20
                        width: parent.width
                        color: "#acacf3"
                        Text {
                            text: qsTr("Имя")
                        }
                    }
                }
                footer: Component {
                    Rectangle {
                        height: 1
                        color: "#acacf3"
                        width: parent.width
                    }
                }

                model: listModel
                delegate: Item {
                    id: itself
                    property var isCurrent: ListView.isCurrentItem
                    width: parent.width
                    height: 20
                    Rectangle {
                        id: itemBkgd
                        anchors {margins: 1; fill: parent}
                        radius: height / 4.
                        color: listView.indexAt(itself.x, itself.y) == listView.playIndex ? "#a2ffa2" : "white";
                        Text {
                            id: txt
                            anchors.fill: parent
                            text: name
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: listView.currentIndex = model.index;
                            onDoubleClicked: {listView.playIndex = listView.currentIndex}
                        }
                    }
                }
                highlight: highlight
                highlightFollowsCurrentItem: true
                focus: true
                Keys.onReturnPressed: {listView.playIndex = listView.currentIndex}
                DropArea {
                    id: dropArea
                    anchors.fill: parent
                    onDropped: Logic.addFiles(drop.urls)
                }
                Component {
                    id: highlight
                    Rectangle {
                        color: "lightsteelblue"
                        y: listView.currentItem.y
                        width: parent.width
                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                    }
                }
                Connections {
                    target: listView
                    onPlayIndexChanged: Logic.replayMedia()
                }
            }
            Rectangle {
                id: playlistControl
                anchors {bottom: parent.bottom}
                width: parent.width
                height: Settings.videoControl
                Button {
                    id: addTrackButton
                    anchors {left: parent.left; top: parent.top; leftMargin: 5}
                    width: height
                    height: parent.height
                    iconSource: "qrc:///resources/icons/Add.png"
                }
                Button {
                    id: deleteTrackButton
                    anchors {left: addTrackButton.right; top: parent.top; leftMargin: 5}
                    width: addTrackButton.width
                    height: width
                    iconSource: "qrc:///resources/icons/Delete.png"
                }
                Button {
                    id: upTrackButton
                    anchors {left: deleteTrackButton.right; top: parent.top; leftMargin: 5}
                    width: addTrackButton.width
                    height: width
                    iconSource: "qrc:///resources/icons/Up.png"
                }
                Button {
                    id: downTrackButton
                    anchors {left: upTrackButton.right; top: parent.top; leftMargin: 5}
                    width: addTrackButton.width
                    height: width
                    iconSource: "qrc:///resources/icons/Down.png"
                }
                Button {
                    id: deleteAllTrackButton
                    anchors {right: parent.right; top: parent.top}
                    width: addTrackButton.width
                    height: width
                    iconSource: "qrc:///resources/icons/DeleteAll.png"
                }
            }
        }
    }
    Component.onCompleted: {
        Logic.listView = listView;
        Logic.listModel = listModel;
        Logic.mediaPlayer = mediaPlayer;
        Logic.md = md;
    }
    ListModel{
        id: listModel
    }
    Window {
        id: fullScreenWindow
        Item {
            id: fullScreenWindowContent
            anchors.fill: parent
        }
    }
    MotionDetectorWrapper {
        id: md
        onSendAction: Logic.executeComand(action)
    }

    // Блок жестового управления

}

