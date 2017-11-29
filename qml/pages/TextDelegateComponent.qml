import QtQuick 2.2
import Sailfish.Silica 1.0


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
                height:authorLabel.height+ Theme.paddingLarge
                visible: (index == chatView.model.count) ? true : (chatView.model.get(index+1).eventType === "m.room.member") ? true :(chatView.model.get(index+1).author != chatView.model.get(index).author)
                //visible: eventType == "m.room.message" ? (view.ListView.nextSection != view.ListView.section) : false
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

            Label {
                x: parent.x + Theme.paddingLarge + Theme.paddingMedium
                width: parent.width - x
                height: undefined
                id: chattext
                text: model.content
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignLeft
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                font.pixelSize:Theme.fontSizeSmall
                onLinkActivated: {
                    console.log("Link clicked: "+link)
                    Qt.openUrlExternally(link)
                }
                linkColor: Theme.highlightColor
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
