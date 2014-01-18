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
    onClosing: Logic.quit()
    // Белый фон
    Rectangle {
        anchors.fill: parent
    }
    menuBar: MenuBar {
        id: menuBar
        onOpenFile: fileDialog.visible = true
        onQuit: Logic.quit()
        onOpenVideoSettings: videoSettings.visible = true
    }
    Player {
        id: player
        anchors {fill: parent; leftMargin: 5; rightMargin: 5; topMargin: 5; bottomMargin: 5}
        systemPallete: systemPallete
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

    SystemPalette {
        id: systemPallete
    }
    Component.onCompleted: {
        Logic.mainWindow = mainWindow;
        Logic.helper = Qt.createQmlObject('import Helper 1.0; Helper{id: helper}', mainWindow, "helper");
        videoSettings.initModel();
    }
}
