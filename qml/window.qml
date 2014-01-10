import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import "."

ApplicationWindow {
    id: mainWindow
    visible: true

    height: Settings.mainWindowHeight
    width: Settings.mainWindowWidth

    onClosing: player.quit()

    // Белый фон
    Rectangle {
        anchors.fill: parent
    }

    menuBar: MenuBar {
        id: menuBar
        onOpenFile: fileDialog.visible = true
        onQuit: player.quit()
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
            player.addFiles(fileDialog.fileUrls)
            visible = false
        }
        onRejected: {
            visible = false
        }
    }

    SystemPalette {
        id: systemPallete
    }
}
