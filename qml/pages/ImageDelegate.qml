import QtQuick 2.2
import Sailfish.Silica 1.0


ListItem {
    id: myListItem
    menu: contextMenuComponent
    width: chatView.width
    contentHeight: visible ? labelColumn.height+ Theme.paddingSmall : 0

    ListView.onAdd: AddAnimation {
        target: myListItem
        duration: 300
    }

    Column {
        id: labelColumn
        x: Theme.paddingMedium
        width: parent.width - x-x

        Item {
            height:authorLabel.height+ Theme.paddingLarge
            visible: (index == chatView.model.count) ? true : (chatView.model.get(index+1).eventType === "m.room.member") ? true :(chatView.model.get(index+1).author != chatView.model.get(index).author)
             width: parent.width
            Rectangle {
                id: bubble
                height: Theme.paddingLarge + Theme.paddingMedium
                width: height
                radius: height/2
                anchors.bottom: parent.bottom
                color: useFancyColors ? fancycolor: Theme.secondaryHighlightColor
                Label {
                    anchors.centerIn: parent
                    text: author.charAt(0).toUpperCase()
                    font.pixelSize: parent.height *0.8
                }
            }
            Label {
                id: authorLabel
                text:  author
                anchors.left: bubble.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.verticalCenter: bubble.verticalCenter
                color: useFancyColors ? fancycolor : Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }
            Label {
                id: timeLabel
                text: time.toLocaleTimeString("hh:mm")
                anchors.right: parent.right
                anchors.verticalCenter: bubble.verticalCenter
                font.pixelSize: Theme.fontSizeTiny
                color: Theme.secondaryColor
            }
        }
        Image {
            id: image
            x: parent.x + Theme.paddingLarge + Theme.paddingMedium
            width: parent.width - x
            height: source == "" ? 0 : width * sourceSize.height / sourceSize.width
            source: ""
            fillMode: Image.PreserveAspectFit
            Behavior on height {
                NumberAnimation {duration: 200}
            }

        }
        Label {
            x: parent.x + Theme.paddingLarge + Theme.paddingMedium
            width: parent.width - x
            height: undefined
            id: chattext
            text: model.content
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignLeft
            color: Theme.secondaryColor
            wrapMode: Text.WrapAnywhere
            font.pixelSize:Theme.fontSizeTiny
        }
    }

    Component {
        id: contextMenuComponent
        ContextMenu {
            MenuItem {
                text: "Download"
                onClicked: console.log("Clicked Download")
            }
        }
    }

    onClicked: {
        console.log("Clicked image")
    }

    Component.onCompleted: {
        py.call('pyclient.client.get_download_url', [model.thumbnail_url], function (result) {
            image.source = result
        });
    }


}
