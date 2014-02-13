import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "Logic.js" as Logic
import Helper 1.0
import "."

ApplicationWindow {
    id: mainWindow
    visible: true
    height: Settings.mainWindowHeight
    width: Settings.mainWindowWidth
    onClosing: {Logic.quit(); close.accepted = false}
    // Белый фон
    Rectangle {
        anchors.fill: parent
    }
    menuBar: MenuBar {
        id: menuBar
        onOpenFile: fileDialog.visible = true
        onQuit: Logic.quit()
        onOpenVideoSettings: videoSettings.visible = true
        onChooseColor: colorSettings.visible = true
        onAbout: {Logic.information(qsTr("О программе"), Logic.helper.readFile(":resources/About.txt"))}
        onHelp: {Logic.information(qsTr("Помощь"), Logic.helper.readFile(":resources/Help.txt"))}
        onHandControl: Logic.md.beginSession(checked)
        onCamera: Logic.md.showDetection(checked)
    }
    Player {
        id: player
        anchors {fill: parent; leftMargin: 5; rightMargin: 5; topMargin: 5; bottomMargin: 5}
        onAddFiles: fileDialog.visible = true
    }
    FileDialog {
        id: fileDialog
        title: qsTr("Выберите файлы...")
        selectMultiple: true
        onAccepted: {
            Logic.addFiles(fileDialog.fileUrls)
            visible = false
        }
        onRejected: {
            visible = false;
        }
    }
    VideoSettings {
        id: videoSettings
    }
    ColorSettings {
        id: colorSettings
        onInitColors: menuBar.initColors(text)
    }
    Component.onCompleted: {
        Logic.mainWindow = mainWindow;
        Logic.helper = Qt.createQmlObject('import Helper 1.0; Helper{id: helper}', mainWindow, "helper");
        videoSettings.initModel();
        Logic.colorSettings = colorSettings;
    }
}
