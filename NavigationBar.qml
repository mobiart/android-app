import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    anchors.bottom: parent.bottom
    height: root.height / 15
    width: root.width
    property alias dropshadow: dropshadow
    DropShadow {
        anchors.fill: drawerbar
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#80000000"
        source: drawerbar
        id: dropshadow
    }
    Rectangle {
        id: drawerbar
        height: parent.height
        width: parent.width
        anchors.bottom: parent.bottom
        color: "#ffffff"
        Text {
            id: home_btn
            text: "\uf1ad"
            font.pixelSize: parent.height / 2.5
            anchors {
                right: bookmarks_btn.left
                verticalCenter: parent.verticalCenter
                rightMargin: parent.width / 10
            }
            color: (root.state_handler.state === "home") ? "#989c99" : "#000000"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.state_handler.state = "home"
                }
            }
        }
        Text {
            id: bookmarks_btn
            text: "\uf004"
            font.pixelSize: parent.height / 2.5
            anchors {
                right: add_btn.left
                rightMargin: parent.width / 10
                verticalCenter: parent.verticalCenter
            }
            color: (root.state_handler.state === "bookmarks") ? "#989c99" : "#000000"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.state_handler.state = "bookmarks"
                }
            }
        }
        Text {
            id: add_btn
            text: "\uf0fe"
            font.pixelSize: parent.height / 1.7
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            color: (root.state_handler.state === "add") ? "#816991" : "#652d8c"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.state_handler.state = "add"
                }
            }
        }

        Text {
            id: map_btn
            text: "\uf279"
            font.pixelSize: parent.height / 2.5
            anchors {
                left: add_btn.right
                leftMargin: parent.width / 10
                verticalCenter: parent.verticalCenter
            }
            color: (root.state_handler.state === "map") ? "#989c99" : "#000000"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.state_handler.state = "map"
                }
            }
        }
        Text {
            id: user_btn
            text: "\uf118"
            font.pixelSize: parent.height / 2.5
            anchors {
                left: map_btn.right
                leftMargin: parent.width / 10
                verticalCenter: parent.verticalCenter
            }
            color: (root.state_handler.state === "user") ? "#989c99" : "#000000"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.state_handler.state = "user"
                }
            }
        }


    }
}
