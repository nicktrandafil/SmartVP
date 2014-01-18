.pragma library
.import QtQuick.Window 2.1 as Window

var listModel;
var listView;
var mediaPlayer;
var mainWindow;
var messageBox;
var helper;
var md;

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


function previousMedia(){
    var index = listView.playIndex;
    if (index < 0)
        return;
    if (index == 0){
        listView.playIndex = listView.count - 1;
        return;
    }
    listView.playIndex = listView.playIndex - 1;
}

function nextMedia(){
    var index = listView.playIndex;
    if (index < 0)
        return;
    if (index == listView.count - 1){
        listView.playIndex = 0;
        return;
    }
    listView.playIndex = listView.playIndex + 1;
}

function setMedia(index){
    mediaPlayer.source = listModel.get(index).path;
    listView.currentIndex = index;
}

function replayMedia(){
    mediaPlayer.stop();
    mediaPlayer.source = listModel.get(listView.playIndex).path;
    mediaPlayer.play();
}

function playMedia(){
    switch (mediaPlayer.playbackState){
    case 0:
        mediaPlayer.play();
        break;
    case 1:
        mediaPlayer.pause();
        break;
    case 2:
        mediaPlayer.play();
        break;
    default:
        break;
    }
}

function information(title, text){
    if (messageBox == null){
        messageBox = Qt.createQmlObject('import "."; MessageBox {id: messageBox}', mainWindow, "messagebox");
    }
    messageBox.title = title;
    messageBox.text = text;
    messageBox.visible = true;
}

function executeComand(comand){
    var comandList = comand.split(' ');
    switch (comandList[0]) {
    case "next":
        nextMedia();
        break;
    case "previous":
        previousMedia();
        break;
    case "play":
        playMedia();
        break;
    case "rewind":
        mediaPlayer.seek(mediaPlayer.position + Number(comandList[1]));
        break;
    case "volume":
        mediaPlayer.volume += Number(comandList[1]);
        break;
    default:
        break;
    }
}
