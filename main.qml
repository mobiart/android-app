import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtWebView 1.15

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
            WebView {
                visible: false
                id: facebook_login
                width: parent.width
                height: parent.height
                z: 100

            }

            Image {
                property bool rounded: true
                property bool adapt: true
                layer.enabled: rounded
                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: user_icon.width
                        height: user_icon.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: user_icon.adapt ? user_icon.width : Math.min(user_icon.width, user_icon.height)
                            height: user_icon.adapt ? user_icon.height : width
                            radius: Math.min(width, height)
                        }
                    }
                }
                id: user_icon
                source: "https://thumbs.dreamstime.com/b/default-avatar-profile-vector-user-profile-default-avatar-profile-vector-user-profile-profile-179376714.jpg"
                height: parent.height / 10
                width: parent.height / 10
                anchors {
                    left: parent.left
                    top: parent.top
                    margins: 10
                }
            }
            Text {
                text: "My account"
                font.pixelSize: parent.height / 25
                anchors {
                    top: user_icon.bottom
                    margins: 10
                    left: parent.left
                }
            }
            Button {
                onClicked: {
                    facebook_login.visible = true
                    facebook_login.url = "https://www.facebook.com/v9.0/dialog/oauth?client_id=281582256624404&redirect_uri=https://milsugi.tech/api/auth"
                }
                anchors {
                    left: user_icon.right
                    bottom: user_icon.bottom
                    leftMargin: -20
                }
                contentItem : Text {
                    text: "Login"
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    radius: width*0.5
                    color: "#3b5998"
                }
            }
        }
        NavigationBar {
            id: navigationbar
        }
    }
}
