.pragma library

var component = Qt.createComponent("Helper.qml");
var helper = component.createObject();

component = Qt.createComponent("ListModel.qml");
var listModel = component.createObject();

var listView;

function addFiles(newFile){
    if (newFile == null)
        return;
    for (var i = 0; i < newFile.length; ++i){
        if (helper.isValidMedia(newFile[i])){
            listModel.append({"name": helper.mediaName(newFile[i]), "path": newFile[i]})
        }
    }
}

function previousMedia(){
    console.log(listView.currentIndex);
}

function nextMedia(){

}

