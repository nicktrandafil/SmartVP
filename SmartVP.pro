TEMPLATE = app

folder_01.source = qml
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

QT += quick qml multimedia widgets

MOC_DIR = notApp
OBJECTS_DIR = notApp
RCC_DIR = notApp
UI_DIR = notApp

SOURCES += src/main.cpp \
    src/helper.cpp \
    src/motiondetector.cpp \
    src/motiondetectorwrapper.cpp
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
    src/helper.h \
    src/motiondetector.h \
    src/motiondetectorwrapper.h

OTHER_FILES += \
    resources/About.txt \
    resources/TODO.txt \
    resources/Issues.txt \
    resources/Help.txt \
    resources/Colors.txt

linux {
    CONFIG(debug, debug|release) {
        DESTDIR = $$PWD
        INCLUDEPATH += /home/nicktrandafil/Develop/opencv2.4.8
        LIBS += -L/home/nicktrandafil/Develop/opencv2.4.8/lib \
            -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d \
            -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_flann -lopencv_nonfree
    }
    CONFIG(release, debug|release) {
        DESTDIR = $$PWD
        INCLUDEPATH += /home/nicktrandafil/Develop/opencv2.4.8_release
        LIBS += -L/home/nicktrandafil/Develop/opencv2.4.8_release/lib \
            -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_ml -lopencv_video -lopencv_features2d \
            -lopencv_calib3d -lopencv_objdetect -lopencv_contrib -lopencv_legacy -lopencv_flann -lopencv_nonfree
    }
    QMAKE_LFLAGS += -Wl,-rpath=\\\$\$ORIGIN/libs
}
