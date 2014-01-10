import QtQuick 2.0
import QtQuick.Controls 1.1
import QtMultimedia 5.0
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
                    height: parent.height * 0.9
                    anchors {left: parent.left; top: parent.top}

                    VideoOutput {
                        id: videoOutput
                        source: mediaPlayer
                        anchors.fill: parent
                    }
                }

                Rectangle {
                    id: videoControl
                    anchors {top: bkgd.bottom; bottom: parent.bottom; topMargin: 5}
                    width: parent.width

                    Button {
                        id: previdous
                        anchors {left: parent.left; top: parent.top}
                        width: height
                        height: parent.height / 2.
                        source: "qrc:///resources/icons/Previous.png"
                    }

                    Button {
                        id: play
                        anchors { left: previdous.right; top: parent.top; leftMargin: 10}
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
                    Rectangle {
                        id: label
                        anchors { right: volume.right; top: parent.top; }
                        width: previdous.width * 3 + 10;
                        height: previdous.height
                    }
                    Rectangle {
                        id: volume
                        anchors { right: parent.right; top: parent.top; }
                        width: previdous.width
                        height: width
                        Image {
                            anchors.fill: parent
                            source: "qrc:///resources/icons/Volume.png"
                        }
                    }

                    Slider {
                        id: slider
                        anchors { top: parent.top; left: next.right; right: label.left; rightMargin: 5; leftMargin: 5}
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
                model: listModel
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
                    onDropped: addFiles(drop.urls)
                }
            }
        }

    }

    ListModel {
        id: listModel
    }


    function addFiles(newFile){
        if (newFile == null)
            return;
        for (var i = 0; i < newFile.length; ++i){
            if (helper.isValidMedia(newFile[i])){
                listModel.append({"name": helper.mediaName(newFile[i]), "path": newFile[i]})
            }
        }
    }

    function quit(){
        mediaPlayer.stop();
        Qt.quit();
    }

    Helper {
        id: helper
    }
}

