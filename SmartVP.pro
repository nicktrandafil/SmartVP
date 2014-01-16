TEMPLATE = app

folder_01.source = qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

QT += quick qml
SOURCES += main.cpp \
    helper.cpp
RESOURCES += \
    resources.qrc

target = SmartVP
INSTALLS += target

for(deploymentfolder, DEPLOYMENTFOLDERS) {
    item = item$${deploymentfolder}
    greaterThan(QT_MAJOR_VERSION, 4) {
        itemsources = $${item}.files
    } else {
        itemsources = $${item}.sources
    }
    $$itemsources = $$eval($${deploymentfolder}.source)
    itempath = $${item}.path
    $$itempath= $$eval($${deploymentfolder}.target)
    export($$itemsources)
    export($$itempath)
    DEPLOYMENT += $$item
}

HEADERS += \
    helper.h

OTHER_FILES += \
    resources/About.txt
