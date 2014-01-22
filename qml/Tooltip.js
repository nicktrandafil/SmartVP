.pragma library

var tool = Qt.createComponent("Tooltip.qml");
var mainWindow
var tooltip;
var fadeInDelay;
var fadeOutDelay;
var tip;
var mouseX
var mouseY

function show() {
    tooltip = tool.createObject(mainWindow);
    tooltip.text = tip;
    tooltip.fadeInDelay = fadeInDelay;
    tooltip.fadeOutDelay = fadeOutDelay;
    tooltip.state = "poppedUp";
}

function close() {
    tooltip.state = "poppedDown";
}
