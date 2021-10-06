import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/components/"

// Window, main

Window {
    id: rootWindow
    visible: true
    width: 1000
    height: 1000
    title: qsTr("Qt Bird")

    // Game properties
    property bool gameRunning: false
    property int score: 0

    // Configs
    property int obstacleSpawnSpeed: 1750 // Note in ms

    signal resetGame()

    Component.onCompleted: {
        console.log("Initializing game");
        resetGame();
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "lightblue"
    }

    onGameRunningChanged: {
        console.log("gameRunning:", gameRunning);
        if (gameRunning) {
            obstacleTimer.start();
        } else {
            obstacleTimer.stop();
        }
    }

    onResetGame: {
        console.log("Resetting game...");

        gameRunning = false;
        player.reset();
        score = 0;
    }

    Timer {
        id: obstacleTimer
        interval: obstacleSpawnSpeed
        repeat: gameRunning
        triggeredOnStart: true

        onTriggered: {
            generateObstacle();
        }
    }

    Player {
        id: player
        width: 125
        height: 100
        focus: true

        sourceImage: "images/frame-1.png"

        jumpHeight: 125
        jumpDuration: 750

        startPositionX: (rootWindow.width / 2) - (player.width / 2)
        startPositionY: (rootWindow.height / 2) - (player.height / 2)
        fallTargetY: rootWindow.height

        enableBoundaries: gameRunning

        onJump: {
            gameRunning = true;
        }
    }

    Text {
        id: instructionsTxt
        visible: !gameRunning
        anchors {
            top: parent.top
            bottom: parent.verticalCenter
            left: parent.left
            right: parent.right
        }

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "chilanka"
        font.pointSize: 30

        text: "Press Spacebar to Play!"
    }

    Rectangle {
        visible: gameRunning
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
        y: (rootWindow.height / 5) - height
        z: parent.z + 1
        height: 50
        width: 50
        radius: 10

        border.width: 4
        color: Qt.darker("lightblue", 1.1)

        Text {
            id: pointTxt
            anchors.centerIn: parent
            font.family: "chilanka"
            font.pointSize: 30

            text: score
        }
    }

    function generateObstacle() {
        var maxHeight = rootWindow.height;

        var openingSize = getRandomInt(200, 500);
        var obstacleHeight = getRandomInt(50, (maxHeight / 2) - openingSize);

        if (Math.round(getRandomInt(1, 2)) === 1) {
            createObstacle(obstacleHeight, obstacleHeight + openingSize);
        } else {
            createObstacle(obstacleHeight + openingSize, obstacleHeight);
        }
    }

    function createObstacle(topHeight, botHeight, obstacleWidth, startX) {
        if (obstacleWidth === undefined || obstacleWidth === null) {
            obstacleWidth = 100;
        }

        if (startX === undefined || startX === null) {
            startX = rootWindow.width + obstacleWidth;
        }

        var component = Qt.createComponent("qrc:/components/ObstaclePair.qml");
        var obstacle = component.createObject(rootWindow, {
                                                  "x": startX,
                                                  "topHeight": topHeight,
                                                  "botHeight": botHeight,
                                                  "hittableXMin": player.hittableXMin,
                                                  "hittableXMax": player.hittableXMax
                                              });
        obstacle.setPlayerMaximums.connect(player.setBoundaries);
        obstacle.playerHasCleared.connect(increaseScore);
        obstacle.startMovement();

        if (obstacle === null) {
            // Error Handling
            console.log("createObstacle(", topHeight, botHeight, "):", "Error creating obstacle");
        }
    }

    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }
    function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function increaseScore() {
        score++;
    }
}
