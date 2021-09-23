import QtQuick 2.5

Rectangle {
    id: boundaryBox
    opacity: .5
    color: showBoundaires ? "red" : "transparent"

    property bool enableBoundaries: true

    property int userY
    property int minY: 0
    property int maxY: 10000
    property bool outsideOfYBoundaries: userY <= minY || userY >= maxY

    property bool showBoundaires: false

    signal setBoundaries(int newMinY, int newMaxY)
    signal hitBoundary

    onSetBoundaries: {
        minY = newMinY;
        maxY = newMaxY;
    }

    onOutsideOfYBoundariesChanged: {
        if (enableBoundaries && outsideOfYBoundaries) {
            console.log("Hit boundary");
            hitBoundary();
        }
    }
}
