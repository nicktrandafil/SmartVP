import QtQuick 2.0
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import "Logic.js" as Logic
import QtQuick.Window 2.1
import Helper 1.0
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
                                               videoControl.height = 20;
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
                    height: 20
                    Button {
                        id: previdousButton
                        anchors {left: parent.left; top: parent.top}
                        width: height
                        height: parent.height
                        source: "qrc:///resources/icons/Previous.png"
                        onClicked: if (mediaPlayer.position > 3000) Logic.playMedia(); else Logic.previousMedia()
                    }
                    Button {
                        id: playButton
                        state: "Pausing"
                        anchors { left: previdousButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        source: "qrc:///resources/icons/Play.png"
                        onClicked: {if (state == "Playing") {mediaPlayer.pause()} else
                                if (state == "Pausing") {mediaPlayer.play()};
                        }
                        states: [
                            State {name: "Playing"; PropertyChanges {target: playButton; source: "qrc:///resources/icons/Pause.png"}},
                            State {name: "Pausing"; PropertyChanges {target: playButton; source: "qrc:///resources/icons/Play.png"}}
                        ]
                        Connections {
                            target: mediaPlayer
                            onPaused: playButton.state = "Pausing"
                            onPlaying: playButton.state = "Playing"
                            onStopped: {}
                        }
                    }
                    Button {
                        id: nextButton
                        anchors { left: playButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        source: "qrc:///resources/icons/Next.png"
                        onClicked: Logic.nextMedia()
                    }
                    Button {
                        id: fullScreenButton
                        state: "MinScreen"
                        anchors {left: nextButton.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdousButton.height
                        onClicked: if (state == "FullScreen") fullScreenWindow.visible = false;
                                   else fullScreenWindow.visibility = Window.FullScreen
                        states: [
                            State {
                                name: "FullScreen"
                                when: fullScreenWindow.visible
                                PropertyChanges {
                                    target: fullScreenButton
                                    source: "qrc:///resources/icons/MinScreen.png"
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
                                    source: "qrc:///resources/icons/FullScreen.png"
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
                            onPositionChanged: duratinInfo.text = helper.duration(mediaPlayer.position / 1000,
                                                                                  mediaPlayer.duration / 1000)
                        }
                    }
                    Button {
                        id: volumeButton
                        anchors { right: parent.right; top: parent.top; leftMargin: 5}
                        width: previdousButton.width
                        height: width
                        source: "qrc:///resources/icons/Volume.png"
                        onHoverChanged: if (hover) {volumeSlider.visible = true} else
                                        {volumeSlider.visible = false}
                        Slider {
                            id: volumeSlider
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
                            State {name: "Mute"; PropertyChanges{target: volumeButton; source: "qrc:///resources/icons/Mute.png"}}
                        ]
                    }
                    Slider {
                        id: positionSlider
                        anchors { top: parent.top; left: fullScreenButton.right; right: label.left; leftMargin: 5; rightMargin: 5}
                        maximumValue: mediaPlayer.duration
                        value: mediaPlayer.position
                        onValueChanged: {
                            if (pressed) {
                                mediaPlayer.seek(value);
                                newPosition.x = width /  mediaPlayer.duration * mediaPlayer.position;
                                newPosition.text = helper.newDuration(width /  mediaPlayer.duration * mediaPlayer.position);
                            }
                        }
                        Text {
                            id: newPosition;
                            visible: newPositionEvents.containsMouse
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
                                newPosition.text = helper.newDuration((mediaPlayer.duration / width * mouse.x) / 1000);
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
                    onPlayIndexChanged: Logic.playMedia()
                }
            }
        }
    }
    Component.onCompleted: {
        Logic.listView = listView;
        Logic.helper = helper;
        Logic.listModel = listModel;
        Logic.mediaPlayer = mediaPlayer;
    }
    ListModel{
        id: listModel
    }
    Helper{
        id: helper
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
    }
}

