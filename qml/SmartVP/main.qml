import QtQuick 2.0
import "."

Rectangle {
    id: root
    width: Settings.windowWidth
    height: Settings.windowHeight

    Loader {
        source: "MenuBar.qml"
        onItemChanged: {
            item.parent = root
            item.systemPallete = systemPallete

        }
    }

    SystemPalette {
        id: systemPallete
    }
}
