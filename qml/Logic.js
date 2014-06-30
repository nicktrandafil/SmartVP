.pragma library
.import QtQuick.Window 2.1 as Window

var listModel;
var listView;
var mediaPlayer;
var mainWindow;
var messageBox;
var helper;
var md;
var colorSettings;

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
    console.log(comand);
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
        var newVolume = mediaPlayer.volume + Number(comandList[1]);
        if (newVolume > 1)
            mediaPlayer.volume = 1;
        else
            if (newVolume < 0)
                mediaPlayer.volume = 0;
        else
                mediaPlayer.volume = newVolume;
        break;
    default:
        break;
    }
}

function removeTrack(){
    listModel.remove(listView.currentIndex);
}

function curTrackUp(){
    if (listView.currentIndex == 0){
        swapTracks(0, listView.count - 1);
        return;
    }
    swapTracks(listView.currentIndex, listView.currentIndex - 1);
}

function curTrackDown(){
    if (listView.currentItem == listView.count - 1){
        swapTracks(listView.count - 1, 0);
        return;
    }
    swapTracks(listView.currentIndex, listView.currentIndex + 1)
}

function swapTracks(id1, id2){
    var temp;
    temp = deepCopy(listModel.get(id1), temp);
    listModel.set(id1, listModel.get(id2));
    listModel.set(id2, temp);
}

function deepCopy(p, c) {
    var c = c || {};
    for (var i in p) {
        if (typeof p[i] === 'object') {
            c[i] = (p[i].constructor === Array) ? [] : {};
            deepCopy(p[i], c[i]);
        } else {
            c[i] = p[i];
        }
    }
    return c;
}

function initColors(menu){
    while (menu.items[0].objectName != "separator")
        menu.removeItem(menu.items[0]);
    var stringList = helper.readColors("resources/Colors.txt");
    for (var i = 0; i < stringList.length; ++i){
        var number = stringList[i].split(' ');
        var name = number[0];
        var minH = number[1];
        var minS = number[2];
        var minV = number[3];
        var maxH = number[4];
        var maxS = number[5];
        var maxV = number[6];
        var item = menu.insertItem(0, number[0]);
        var action =
        Qt.createQmlObject(String('import QtQuick.Controls 1.1; import "Logic.js" as Logic; Action {' +
                'text: "%1";' +
                'onTriggered: {' +
                    'Logic.colorSettings.minH = %2;' +
                    'Logic.colorSettings.minS = %3;' +
                    'Logic.colorSettings.minV = %4;' +
                    'Logic.colorSettings.maxH = %5;' +
                    'Logic.colorSettings.maxS = %6;' +
                    'Logic.colorSettings.maxV = %7;' +
                '}' +
            '}').arg(name).arg(minH).arg(minS).arg(minV).arg(maxH).arg(maxS).arg(maxV), item, "messagebox");
        item.action = action;
    }
}

function updateColors(menu, content){
    helper.updateColors("resources/Colors.txt", content);
}

