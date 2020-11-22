import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtWebView 1.15
import QtQuick.LocalStorage 2.15
import "utils.js" as Utils
Window {
    width: 480
    height: 800
    visible: true
    title: qsTr("Mobiart")
    property var product_list: []
    property var bookmark_list: []
    property int products_per_row: (Utils.get("products_per_row") !== undefined) ? Utils.get("products_per_row") : 2
    property var margin_padding: root.height / (50 * products_per_row)
    property int bookmark_id: 0

    Component.onCompleted: {
        Utils.getDatabase()
        if (Utils.get("first_run") !== "true") {
            Utils.set("products_per_row", 2)
            Utils.set("first_run", "true")
        }
        var products = JSON.parse(Utils.http_get("https://milsugi.tech/api/marketplace/products/?filters=%7B%22start%22:0,%22size%22:100%7D"))
        for(var i = 0; i < products.length; i++) {
            var obj = products[i];
            product_list.push([obj.name, obj.details, obj.price, obj.active, obj.id, obj.thumbnail])
        }

        var bookmarks = JSON.parse(Utils.http_get("https://milsugi.tech/api/profile/bookmarks/?user_id=1"))
        for(var j = 0; j < bookmarks.length; j++) {
            var bookmark_obj = bookmarks[j];
            bookmark_list.push([bookmark_obj.name, bookmark_obj.details, bookmark_obj.price, bookmark_obj.active, bookmark_obj.id, bookmark_obj.thumbnail])
        }

        homescreen_gridview.model = product_list.length
        bookmark_gridview.model = bookmark_list.length

        if (Utils.get("jwt") !== undefined) {
            login_button.visible = false
            logout_button.visible = true
            var user_information = JSON.parse(Utils.http_post("https://milsugi.tech/api/profile/@me/", {
                "jwt": Utils.get("jwt")
            }))
            account_name.text = "Welcome, " + user_information["name"]
        }

    }
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
                },
                State {
                    name: "post"
                }

            ]
        }
        id: root
        width: parent.width
        height: parent.height
        color: "#e6e6e6"
        Rectangle {
            Component.onCompleted: {
                console.log(products_per_row)
            }

            visible: (state_handler.state === "home") ? true : false
            id: home_container
            height: parent.height - navigationbar.height
            width: parent.width - margin_padding
            color: "#00000000"
            GridView {
                id: homescreen_gridview
                width: parent.width - margin_padding
                height: parent.height - margin_padding
                model: 0
                cellWidth: (parent.width - margin_padding) / products_per_row
                cellHeight: (parent.width - margin_padding) / products_per_row
                x: margin_padding * 1.5
                y: margin_padding
                focus: true
                delegate: Item {
                    DropShadow {
                            anchors.fill: app_rectangle
                            radius: 8.0
                            samples: 17
                            color: "#80000000"
                            source: app_rectangle
                    }
                    Column {
                        id: app_rectangle
                        Rectangle {
                            color: "#ffffff"
                            width: homescreen_gridview.cellWidth - margin_padding
                            height: homescreen_gridview.cellHeight - margin_padding
                            anchors.horizontalCenter: parent.horizontalCenter
                            DropShadow {
                                    anchors.fill: product_image_thumb
                                    radius: 8.0
                                    samples: 17
                                    color: "#80000000"
                                    source: product_image_thumb
                            }
                            Image {
                                id: product_image_thumb
                                width: parent.width
                                height: parent.height - product_price_thumb.height - product_title_thumb.height
                                source: product_list[index][5]
                            }

                            Text {
                                id: product_title_thumb
                                font.pixelSize: parent.height / 10
                                text: product_list[index][0]
                                color: "#000000"
                                anchors {
                                    leftMargin: margin_padding
                                    left: parent.left
                                    bottom: product_price_thumb.top
                                }
                            }
                            Text {
                                id: product_price_thumb
                                font.pixelSize: parent.height / 15
                                text: (product_list[index][2] === 0) ? "Price upon request." : product_list[index][2] + " USD"
                                color: "#000000"
                                anchors {
                                    bottom: parent.bottom
                                    leftMargin: margin_padding
                                    left: parent.left
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    state_handler.state = "post"
                                    listing_title.text = product_list[index][0]
                                    if(product_list[index][2] === 0) {
                                        listing_price.text = "Price upon request."
                                    } else {
                                        listing_price.text = product_list[index][2] + " USD"
                                    }
                                    if(product_list[index][3] === true) {
                                        listing_active.text = "This listing is currently available."
                                    } else {
                                        listing_active.text = "This listing is not available and will be removed soon."
                                    }
                                    listing_descripton.text = product_list[index][1]
                                    bookmark_id = product_list[index][4]
                                    listing_image.source = product_list[index][5]
                                }
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            visible: (state_handler.state === "bookmarks") ? true : false
            id: bookmarks_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"

            GridView {
                id: bookmark_gridview
                width: parent.width - margin_padding
                height: parent.height - margin_padding
                model: 0
                cellWidth: (parent.width - margin_padding) / products_per_row
                cellHeight: (parent.width - margin_padding) / products_per_row
                x: margin_padding * 1.5
                y: margin_padding
                focus: true
                delegate: Item {
                    DropShadow {
                            anchors.fill: bookmark_rectangle
                            radius: 8.0
                            samples: 17
                            color: "#80000000"
                            source: bookmark_rectangle
                    }

                    Column {
                        id: bookmark_rectangle
                        Rectangle {
                            DropShadow {
                                    anchors.fill: bookmark_image_thumb
                                    radius: 8.0
                                    samples: 17
                                    color: "#80000000"
                                    source: bookmark_image_thumb
                            }
                            Image {
                                id: bookmark_image_thumb
                                width: parent.width
                                height: parent.height - bookmark_price_thumb.height - bookmark_title_thumb.height
                                source: bookmark_list[index][5]
                            }
                            color: "#ffffff"
                            width: homescreen_gridview.cellWidth - margin_padding
                            height: homescreen_gridview.cellHeight - margin_padding
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                id: bookmark_title_thumb
                                font.pixelSize: parent.height / 10
                                text: bookmark_list[index][0]
                                color: "#000000"
                                anchors {
                                    leftMargin: margin_padding
                                    left: parent.left
                                    bottom: bookmark_price_thumb.top
                                }
                            }
                            Text {
                                id: bookmark_price_thumb
                                font.pixelSize: parent.height / 15
                                text: (bookmark_list[index][2] === 0) ? "Price upon request." : bookmark_list[index][2] + " USD"
                                color: "#000000"
                                anchors {
                                    bottom: parent.bottom
                                    leftMargin: margin_padding
                                    left: parent.left
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    state_handler.state = "post"
                                    listing_title.text = bookmark_list[index][0]
                                    if(bookmark_list[index][2] === 0) {
                                        listing_price.text = "Price upon request."
                                    } else {
                                        listing_price.text = bookmark_list[index][2] + " USD"
                                    }
                                    if(bookmark_list[index][3] === true) {
                                        listing_active.text = "This listing is currently available."
                                    } else {
                                        listing_active.text = "This listing is not available and will be removed soon."
                                    }
                                    listing_descripton.text = bookmark_list[index][1]
                                    bookmark_id = bookmark_list[index][4]
                                    listing_image.source = bookmark_list[index][5]
                                }
                            }
                        }
                    }
                }
            }



        }
        Rectangle {
            visible: (state_handler.state === "add") ? true : false
            id: add_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                id: listing_text
                text: "Post a new listing"
                font.pixelSize: parent.height / 25
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    margins: 10
                }
            }
            Text {
                id: title_text
                text: "Title"
                font.pixelSize: parent.height / 50
                anchors {
                    top: listing_text.bottom
                    left: parent.left
                    margins: 10
                }
            }
            DropShadow {
                    anchors.fill: title_textfield
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: title_textfield
            }
            TextField {
                id: title_textfield
                placeholderText: qsTr("Ex. Grafitti art on giant buildings")
                width: parent.width
                anchors {
                    top: title_text.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
            }
            Text {
                id: description_text
                text: "Description"
                font.pixelSize: parent.height / 50
                anchors {
                    top: title_textfield.bottom
                    left: parent.left
                    margins: 10
                }
            }
            DropShadow {
                    anchors.fill: description_textfield
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: description_textfield
            }
            TextArea {
                id: description_textfield
                width: parent.width
                height: parent.height / 10
                background: Rectangle {
                    height: parent.height
                    width: parent.width
                    color: "#ffffff"
                    border.color: "#bdbdbd"
                    border.width: 1
                }

                anchors {
                    top: description_text.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
            }
            Text {
                id: price_text
                text: "Price"
                font.pixelSize: parent.height / 50
                anchors {
                    top: description_textfield.bottom
                    left: parent.left
                    margins: 10
                }
            }
            DropShadow {
                    anchors.fill: price_textfield
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: price_textfield
            }
            TextField {
                id: price_textfield
                placeholderText: qsTr("Ex. 50 USD. input 0 if you want the price to be per request.")
                width: parent.width
                anchors {
                    top: price_text.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
            }

            Text {
                id: photos_text
                text: "Photos"
                font.pixelSize: parent.height / 50
                anchors {
                    top: price_textfield.bottom
                    left: parent.left
                    margins: 10
                }
            }
            DropShadow {
                    anchors.fill: photos_container
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: photos_container
            }
            Rectangle {
                id: photos_container
                width: parent.width
                height: parent.height / 5
                color: "#e38d3d"
                anchors {
                    top: photos_text.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
                Text {
                    text: "No photos added!"
                    font.pixelSize: parent.height / 10
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        margins: 10
                    }
                }
                Text {
                    text: "\uf0fe"
                    color: "#c76c18"
                    font.pixelSize: parent.height / 5
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
            Button {
                text: "Post"
                background: Rectangle {
                    color: "#8f8bd8"
                    radius: 4
                }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height / 100
                }
                onClicked: {
                        console.log(Utils.http_post("https://milsugi.tech/api/marketplace/product/", {
                            "jwt": Utils.get("jwt"),
                            "user": 1,
                            "name": title_textfield.text,
                            "details": description_textfield.text,
                            "price_upon_request": false,
                            "price": price_textfield.text,
                            "active": true,
                            "thumbnail": "https://www.brdtex.com/wp-content/uploads/2019/09/no-image-480x480.png"
                        }))
                        thank_you_box.visible = true
                }
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
            visible: (state_handler.state === "post") ? true : false
            id: post_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            DropShadow {
                    anchors.fill: listing_image
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: listing_image
            }
            Image {
                id: listing_image
                width: parent.width
                height: parent.height / 2.2
                source: ""
                DropShadow {
                        anchors.fill: favourite_button
                        radius: 8.0
                        samples: 17
                        color: "#80000000"
                        source: favourite_button
                }
                Rectangle {
                    id: favourite_button
                    width: 50
                    height: 50
                    radius: width*0.5
                    color: "#e38d3d"
                    Text {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }
                        text: "\uf004"
                    }
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: this.height / 2
                        bottomMargin: -this.height / 2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log(JSON.stringify(Utils.bookmark_post("https://milsugi.tech/api/profile/bookmark/"), {
                                            "jwt": Utils.get("jwt"),
                                            "product_id": bookmark_id
                                        }))
                            console.log(bookmark_id)
                        }
                    }
                }
            }
            Text {
                id: listing_active
                text: "{active}"
                anchors {
                    top: listing_image.bottom
                    topMargin: 10
                    left: parent.left
                    leftMargin: 10
                }
            }

            Text {
                id: listing_title
                text: "{title}"
                anchors {
                    top: listing_image.bottom
                    topMargin: 10 + favourite_button.height / 2
                    left: parent.left
                    leftMargin: 10
                }
                font.pixelSize: parent.height / 25
            }
            Text {
                id: listing_price
                text: "{price}"
                anchors {
                    top: listing_title.bottom
                    left: parent.left
                    leftMargin: 10
                }
                font.pixelSize: parent.height / 35
            }

            Text {
                id: listing_descripton
                text: "{description}"
                anchors {
                    top: listing_price.bottom
                    topMargin: 10
                    left: parent.left
                    leftMargin: 10
                }

                width: parent.width - margin_padding
                wrapMode: Text.Wrap
            }
        }
        Rectangle {
            visible: (state_handler.state === "about") ? true : false
            id: about_container
            height: parent.height - navigationbar.height
            width: parent.width
            color: "#00000000"
            Text {
                text: "This app was made for the UniHack 2020 Hackathon."
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
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
                onLoadingChanged: {
                    if (this.url.toString().indexOf("https://milsugi.tech/api/auth/?code=") > -1) {
                        this.visible = false
                        this.runJavaScript("document.querySelector('pre').innerHTML", function(result) {
                            if (JSON.parse(result)["jwt"].length > 1) {
                                Utils.set("jwt", JSON.parse(result)["jwt"])
                                Utils.set("exp_days", 365)
                                login_button.visible = false
                                logout_button.visible = true
                                var user_information = JSON.parse(Utils.http_post("https://milsugi.tech/api/profile/@me/", {
                                    "jwt": Utils.get("jwt")
                                }))
                                account_name.text = "Welcome, " + user_information["name"]
                            }
                        })
                    }
                }
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
                id: account_name
                text: "My account"
                font.pixelSize: parent.height / 25
                anchors {
                    top: user_icon.bottom
                    margins: 10
                    left: parent.left
                }
            }
            Button {
                id: login_button
                onClicked: {
                    facebook_login.visible = true
                    facebook_login.url = "https://www.facebook.com/v9.0/dialog/oauth?client_id=281582256624404&redirect_uri=https://milsugi.tech/api/auth"
                }
                anchors {
                    left: user_icon.right
                    bottom: user_icon.bottom
                    leftMargin: -20
                }
                contentItem: Text {
                    text: "Login"
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    radius: width * 0.5
                    color: "#3b5998"
                }
            }
            Button {
                visible: false
                id: logout_button
                onClicked: {
                    Utils.set("jwt", "")
                    this.visible = false
                    login_button.visible = true
                    account_name.text = "My account"
                }
                anchors {
                    left: user_icon.right
                    bottom: user_icon.bottom
                    leftMargin: -20
                }
                contentItem: Text {
                    text: "Logout"
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    radius: width * 0.5
                    color: "#c25353"
                }
            }
            DropShadow {
                    anchors.fill: settings_btn
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: settings_btn
            }
            Button {
                id: settings_btn
                text: "Settings"
                width: parent.width
                anchors {
                    top: account_name.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
                background: Rectangle {
                    width: parent.width
                    color: "#ffffff"
                }
            }
            DropShadow {
                    anchors.fill: about
                    radius: 8.0
                    samples: 17
                    color: "#80000000"
                    source: settings_btn
            }
            Button {
                id: about
                text: "About"
                width: parent.width
                anchors {
                    top: settings_btn.bottom
                    margins: 10
                    left: parent.left
                    right: parent.right
                }
                background: Rectangle {
                    width: parent.width
                    color: "#ffffff"
                }
                onClicked: {
                    state_handler.state = "about"
                }
            }
        }
        Rectangle {
            visible: false
            id: thank_you_box
            height: parent.height
            width: parent.width
            color: "#99000000"
            z:5000
            Text {
                color: "#ffffff"
                id: thank_you_text
                text: "You may now return home."
                font.pixelSize: parent.height / 25
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
            }
            Button {
                text: "Home"
                background: Rectangle {
                    color: "#8f8bd8"
                    radius: 4
                }
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: parent.height / 100
                }
                onClicked: {
                    product_list.length = 0
                    var products = JSON.parse(Utils.http_get("https://milsugi.tech/api/marketplace/products/?filters=%7B%22start%22:0,%22size%22:100%7D"))
                    for(var i = 0; i < products.length; i++) {
                        var obj = products[i];
                        product_list.push([obj.name, obj.details, obj.price, obj.active, obj.id, obj.thumbnail])
                    }
                    homescreen_gridview.model = product_list.length

                    state_handler.state = "home"
                        thank_you_box.visible = false
                }
            }
        }
        NavigationBar {
            id: navigationbar
        }
    }
}
