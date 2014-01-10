import QtQuick 2.0
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import "Logic.js" as Logic
import Helper 1.0
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
                }

                Rectangle {
                    id: videoControl
                    anchors {bottom: parent.bottom; left: parent.left}
                    width: parent.width
                    height: 20

                    Button {
                        id: previdous
                        anchors {left: parent.left; top: parent.top}
                        width: height
                        height: parent.height
                        source: "qrc:///resources/icons/Previous.png"
                        onClicked: Logic.previousMedia()
                    }

                    Button {
                        id: play
                        anchors { left: previdous.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdous.height
                        source: "qrc:///resources/icons/Play.png"
                    }
                    Button {
                        id: next
                        anchors { left: play.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdous.height
                        source: "qrc:///resources/icons/Next.png"
                    }
                    Button {
                        id: fullScreen
                        anchors {left: next.right; top: parent.top; leftMargin: 5}
                        width: height
                        height: previdous.height
                        source: "qrc:///resources/icons/FullScreen.png"
                    }
                    Rectangle {
                        id: label
                        anchors { right: volume.right; top: parent.top; }
                        width: previdous.width * 3 + 10;
                        height: previdous.height
                    }
                    Button {
                        id: volume
                        anchors { right: parent.right; top: parent.top; }
                        width: previdous.width
                        height: width
                        source: "qrc:///resources/icons/Volume.png"
                        onHoverChanged: if (hover) {volumeSlider.visible = true} else
                                        {volumeSlider.visible = false}
                        Slider {
                            id: volumeSlider
                            onHoveredChanged: if (hovered) {visible = true} else {visible = false}
                            visible: false
                            orientation: Qt.Vertical
                            anchors {bottom: parent.top; horizontalCenter: parent.horizontalCenter}
                            height: 80
                        }
                    }

                    Slider {
                        id: slider
                        anchors { top: parent.top; left: fullScreen.right; right: label.left; rightMargin: 5; leftMargin: 5}
                    }
                }
            }
        }

        Item {
            id: listViewAndControls
            ListView {
                width: parent.width
                height: parent.height
                id: listView
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
                model: Logic.listModel
                delegate: Component {
                    Rectangle {
                        id: itemBkgd
                        radius: height / 4.
                        onFocusChanged: if (focus) color = "#a2ffa2"; else color = "white"
                        width: parent.width
                        height: 20
                        Text {
                            id: txt
                            anchors.fill: parent
                            text: name
                        }
                        MouseArea {
                            anchors.fill: parent

                            onDoubleClicked: {
                                if (mediaPlayer.source == path)
                                    mediaPlayer.stop();
                                mediaPlayer.source = path;
                                mediaPlayer.play();
                                itemBkgd.focus = true
                            }
                        }
                    }
                }

                DropArea {
                    id: dropArea
                    anchors.fill: parent
                    onDropped: Logic.addFiles(drop.urls)
                }
            }
        }
    }

    Component.onCompleted: Logic.listView = listView

    function quit(){
        mediaPlayer.stop();
        Qt.quit();
    }
}

