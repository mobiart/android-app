import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import "utils.js" as Utils

Window {
    width: 480
    height: 800
    visible: true
    title: qsTr("Mobiart")
    FontLoader {
        id: fontAwesome
        source: "fonts/Font Awesome 5 Free-Regular-400.otf"
    }

    Rectangle {
        property alias state_handler: state_handler
        Item {
            id: state_handler
            state: "home"
            states: [
                State {
                    name: "home"
                },
                State {
                    name: "bookmarks"
                },
                State {
                    name: "add"
                },
                State {
                    name: "map"
                },
                State {
                    name: "user"
                }

            ]
        }
        id: root
        width: parent.width
        height: parent.height
        color: "#e6e6e6"
        Rectangle {
            visible: (state_handler.state === "home") ? true : false
            id: home_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "home container"
            }

        }
        Rectangle {
            visible: (state_handler.state === "bookmarks") ? true : false
            id: bookmarks_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "bookmarks container"
            }
        }
        Rectangle {
            visible: (state_handler.state === "add") ? true : false
            id: add_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "add container"
            }
        }
        Rectangle {
            visible: (state_handler.state === "map") ? true : false
            id: map_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "map container"
            }
        }
        Rectangle {
            visible: (state_handler.state === "user") ? true : false
            id: user_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "user container"
            }
        }
        NavigationBar {
            id: navigationbar
        }

    }


}
