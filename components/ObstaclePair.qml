import QtQuick 2.5

Item {
    id: obstaclePair
    width: obstacleWidth
    anchors {
        top: parent.top
        bottom: parent.bottom
    }

    property int topHeight
    property int botHeight

    property int obstacleWidth: 100

    property int hittableXMin
    property int hittableXMax

    property bool canHitPlayer: (x + width) >= hittableXMin && x <= hittableXMax
    property color obstacleColor: canHitPlayer ? "red" : "brown"

    signal setPlayerMaximums(int newMinY, int newMaxY)

    onCanHitPlayerChanged: {
        if (canHitPlayer) {
            setPlayerMaximums(topHeight, obstaclePair.height - botHeight);
        }
    }


    Component.onCompleted: {
        moveAcrossScreen.start();
    }

    PropertyAnimation {
        id: moveAcrossScreen
        target: obstaclePair
        property: "x"
        from: rootWindow.width + target.width
        to: 0 - obstaclePair.width
        duration: 5000

        onStopped: {
            obstaclePair.destroy();
        }
    }

    Obstacle {
        id: obstacle
        height: topHeight

        anchors {
            left: parent.left
            right: parent.right
        }

        color: obstacleColor
    }

    Obstacle {
        id: obstacle2
        height: botHeight

        anchors {
            left: parent.left
            right: parent.right
        }

        y: rootWindow.height - height

        color: obstacleColor
    }
}