import QtQuick 2.2
import Sailfish.Silica 1.0

Component {

    ListItem {
        id: myListItem
        //property Item contextMenu
        //property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
        menu: contextMenuComponent
        width: chatView.width
        //height: menuOpen ? contextMenu.height + backgroundItem.height : backgroundItem.height
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
                height: modelitem.eventType == "m.room.message" ? authorLabel.height+ Theme.paddingLarge: authorLabel.height+  Theme.paddingLarge
                visible: modelitem.eventType == "m.room.message" ? (myListItem.ListView.nextSection != myListItem.ListView.section) : false
                width: parent.width
                Rectangle {
                    id: bubble
                    height: Theme.paddingLarge + Theme.paddingMedium
                    width: height
                    radius: height/2
                    anchors.bottom: parent.bottom
                    color: modelitem.eventType == "m.room.message" ? useFancyColors ? modelitem.fancycolor: Theme.secondaryHighlightColor: ""
                    Label {
                        anchors.centerIn: parent
                        text:  modelitem.eventType == "m.room.message" ? modelitem.author.charAt(0).toUpperCase() : ""
                        font.pixelSize: parent.height *0.8
                    }
                }
                Label {
                    id: authorLabel
                    text: modelitem.eventType == "m.room.message" ? modelitem.author : ""
                    anchors.left: bubble.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.verticalCenter: bubble.verticalCenter
                    color: modelitem.eventType == "m.room.message" ? useFancyColors ? modelitem.fancycolor : Theme.secondaryHighlightColor: ""
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }
                Label {
                    id: timeLabel
                    text: modelitem.eventType == "m.room.message" ? modelitem.time.toLocaleTimeString("hh:mm") : ""
                    anchors.right: parent.right
                    anchors.verticalCenter: bubble.verticalCenter
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.secondaryColor
                }
            }

            Label {
                x: parent.x + Theme.paddingLarge + Theme.paddingMedium
                width: parent.width - x
                height: modelitem.eventType == "m.room.message" ? undefined:  lineCount* font.pixelSize + Theme.paddingMedium
                id: chattext
                text: modelitem.content
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: modelitem.eventType == "m.room.message" ? Text.AlignLeft : Text.AlignHCenter
                color: modelitem.eventType == "m.room.message" ? Theme.primaryColor: Theme.secondaryColor
                wrapMode: Text.WordWrap
                font.pixelSize: modelitem.eventType == "m.room.message" ? Theme.fontSizeSmall : Theme.fontSizeTiny
            }
        }

        /*Rectangle {
            color: "#99bb99"
            height: chatView.ListView.previousSection != chatView.ListView.section ? 20 : 0
            width: parent.width
            visible: chatView.ListView.previousSection != chatView.ListView.section ? true : false
            Text { text: chatView.ListView.section }
        }*/

        /*onPressAndHold: {
            //if (!contextMenu)
             //   contextMenu = contextMenuComponent.createObject(chatView)
            //chatView.textvalue = chattext.text
            showMenu(myListItem)
        }*/
        Component {
            id: contextMenuComponent
            ContextMenu {
                TextArea {
                    x: 10
                    width: chatView.width -x
                    //height: contentHeight
                    //id: chattext
                    text: model.content
                    color: Theme.highlightColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeExtraSmall
                    //readOnly: true
                    Component.onCompleted: selectAll();
                }

            }
        }

    }
}
