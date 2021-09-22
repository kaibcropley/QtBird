import QtQuick 2.5

Image {
    id: player
    width: 50
    height: 50
    focus: true

    source: "images/mario.png"

    property int jumpHeight: 75
    property int jumpDuration: 750

    property int startPositionX: rootWindow.width / 2
    property int startPositionY: rootWindow.height / 2
    property int fallTargetY

    property int hittableXMin: x
    property int hittableXMax: x + player.width

    property int minY: 0
    property int maxY: 5000 // Start at an unreasonably high number so we don't hit it on start

    signal setMaxY(int newMinY, int newMaxY);

    onSetMaxY: {
        console.log("onSetMaxY(", newMinY, newMaxY, ")");
        minY = newMinY;
        maxY = newMaxY;
    }

    Rectangle {
        id: playerHitBox
        color: "red"
        opacity: 25
        z: player.z - 1
        y: player.y
        x: player.x
        height: parent.height * .66
        width: parent.width * .66

        onYChanged: {
            if (y <= player.minY || y >= player.maxY) {
                player.goToStartPos();
            }
        }
    }

    Component.onCompleted: {
        goToStartPos();
        console.log("player.hittableXMin:", player.hittableXMin);
        console.log("player.hittableXMax:", player.hittableXMax);
    }

    function goToStartPos() {
        console.log("Restarting player pos");
        x = startPositionX;
        y = startPositionY;
    }

    Keys.onSpacePressed: {
        console.log("Space pressed");
        jumpAnimation.restart();
    }

    SequentialAnimation {
        id: jumpAnimation

        PropertyAnimation {
            id: jumpUp;
            target: player;
            property: "y";
            to: player.y - player.jumpHeight;
            duration: player.jumpDuration
            easing.type: Easing.OutCubic
        }

        PropertyAnimation {
            id: fall;
            target: player;
            property: "y";
            to: fallTargetY
            duration: (fallTargetY - target.y) + 250 // 2000
            easing.type: Easing.InCubic
        }
    }
}
