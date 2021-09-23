import QtQuick 2.5

Item {
    id: player

    property alias sourceImage: playerImage.source

    property int jumpHeight
    property int jumpDuration

    property int fallTargetY
    property int startPositionX
    property int startPositionY

    property int hittableXMin: x
    property int hittableXMax: x + player.width

    property bool enableJump: true
    property alias enableBoundaries: bodyBoundaryBox.enableBoundaries

    signal setBoundaries(int newMinY, int newMaxY)
    signal jump()

    onSetBoundaries: {
        bodyBoundaryBox.setBoundaries(newMinY, newMaxY);
    }

    Component.onCompleted: {
        reset();
    }

    function reset() {
        console.log("Resetting player");
        playerRotationAnimation.stop();
        jumpAnimation.stop();

        bodyBoundaryBox.setBoundaries(0, fallTargetY);

        x = startPositionX;
        y = startPositionY;
        rotation = 0;
    }

    Keys.onSpacePressed: {
        jump();
    }

    onJump: {
        if (enableJump) {
            jumpAnimation.restart();
            playerRotationAnimation.restart();
        }
    }

    Image {
        id: playerImage
        anchors.fill: parent
    }

    Boundarybox {
        id: bodyBoundaryBox
        userY: player.y

        height: player.height * .70
        width: player.width * .60
        x: 20
        y: 15

        onHitBoundary: {
            rootWindow.resetGame();
        }
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
            duration: (fallTargetY - target.y) + 250
            easing.type: Easing.InCubic
        }
    }

    SequentialAnimation {
        id: playerRotationAnimation

        PropertyAnimation {
            id: playerJumpRotationAnimation
            target: player
            property: "rotation"
            from: -75
            to: 0
            duration: player.jumpDuration
        }

        PropertyAnimation {
            id: playerFallRotationAnimation
            target: player
            property: "rotation"
            from: 0
            to: 90
            duration: 1500
        }
    }
}
