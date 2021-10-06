import QtQuick 2.5

// A pair of obstacles moving across the screen. will

Item {
    id: obstaclePair
    width: obstacleWidth
    anchors { // Set anchors here so dynamic creation isn't super long
        top: parent.top
        bottom: parent.bottom
    }

    property int topHeight
    property int botHeight
    property int hittableXMin
    property int hittableXMax

    property int obstacleWidth: 100
    property color obstacleColor: "darkgreen" // canHitPlayer ? "red" : "brown"

    property bool canHitPlayer: (x + width) >= hittableXMin && x <= hittableXMax

    signal setPlayerMaximums(int newMinY, int newMaxY)
    signal playerHasCleared

    Component.onCompleted: {
        rootWindow.resetGame.connect(obstaclePair.destroy);
    }

    onCanHitPlayerChanged: {
        if (canHitPlayer) {
            setPlayerMaximums(topHeight, obstaclePair.height - botHeight);
        } else {
            setPlayerMaximums(0, obstaclePair.height);
            playerHasCleared();
        }
    }


    function startMovement() {
        moveAcrossScreen.start();
    }

    PropertyAnimation {
        id: moveAcrossScreen
        target: obstaclePair
        property: "x"
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
