import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/components/"

Window {
    id: rootWindow
    visible: true
    width: 1000
    height: 1000
    title: qsTr("Hello World")

    Rectangle {
        anchors.fill: parent
        color: "lightblue"
    }

    Component.onCompleted: {
        obstacleTimer.start();
    }

    function createObstacle(topHeight, botHeight) {
//        console.log("createObstacle(", topHeight, botHeight, ")");

        var component = Qt.createComponent("qrc:/components/ObstaclePair.qml");
        var obstacle = component.createObject(rootWindow, {
                                                  "topHeight": topHeight,
                                                  "botHeight": botHeight,
                                                  "hittableXMin": player.hittableXMin,
                                                  "hittableXMax": player.hittableXMax
                                              });
        obstacle.setPlayerMaximums.connect(player.setMaxY);

        if (obstacle === null) {
            // Error Handling
            console.log("createObstacle(", topHeight, botHeight, "):", "Error creating obstacle");
        }
    }

    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }

    Timer {
        id: obstacleTimer
        interval: 1500
        repeat: true

        onTriggered: {
            // TODO have smarter way of generating obstacle heights
            createObstacle(300 + getRandomArbitrary(-100, 100), 300 + getRandomArbitrary(-100, 100));
        }
    }

    Player {
        id: player
        width: 100
        height: 100
        focus: true

        source: "images/mario.png"

        jumpHeight: 100
        jumpDuration: 500

        startPositionX: rootWindow.width / 2
        startPositionY: rootWindow.height / 2
        fallTargetY: rootWindow.height


    }
}
