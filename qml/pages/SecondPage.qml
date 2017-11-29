import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: room

    Rectangle {
        color: "Black"
        anchors.fill: parent
        visible: useBlackBackground
        opacity: 0.8
    }

    SilicaListView {
        id: chatView
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        verticalLayoutDirection: ListView.BottomToTop
        //anchors.bottom: parent.bottom
        model: roomEvents

        header: Item {
             id: textEntryItem
             width: chatView.width
             height: textEntry.height
             TextArea {
                width: parent.width - sendButton.width
                id: textEntry
                placeholderText: qsTr("Message @") + joinedRooms[currentRoom].displayname
                EnterKey.onClicked: {
                    //sendLine(text)
                    //textEntry.text = ""
                }
             }
             IconButton {
                 id: sendButton
                 anchors.right: parent.right
                 anchors.bottom: parent.bottom
                 anchors.bottomMargin: Theme.paddingLarge
                 icon.source: "image://theme/icon-m-enter-accept"
                 enabled: textEntry.text.length > 0
                 onClicked: {
                    py.call('pyclient.client.send_text', [currentRoom, textEntry.text], function (result) {
                        textEntry.text = ""
                    });
                    //sendMessage(textEntry.text)
                 }
             }
        }


        delegate: ListItem {
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
                    height: eventType == "m.room.messagetext" ? authorLabel.height+ Theme.paddingLarge: authorLabel.height+  Theme.paddingLarge
                    visible: eventType == "m.room.messagetext" ? (myListItem.ListView.nextSection != myListItem.ListView.section) : false
                    width: parent.width
                    Rectangle {
                        id: bubble
                        height: Theme.paddingLarge + Theme.paddingMedium
                        width: height
                        radius: height/2
                        anchors.bottom: parent.bottom
                        color: eventType == "m.room.messagetext" ? useFancyColors ? model.fancycolor: Theme.secondaryHighlightColor: ""
                        Label {
                            anchors.centerIn: parent
                            text:  eventType == "m.room.messagetext" ? author.charAt(0).toUpperCase() : ""
                            font.pixelSize: parent.height *0.8
                        }
                    }
                    Label {
                        id: authorLabel
                        text: eventType == "m.room.messagetext" ? author : ""
                        anchors.left: bubble.right
                        anchors.leftMargin: Theme.paddingMedium
                        anchors.verticalCenter: bubble.verticalCenter
                        color: eventType == "m.room.messagetext" ? useFancyColors ? model.fancycolor : Theme.secondaryHighlightColor: ""
                        font.pixelSize: Theme.fontSizeSmall
                        font.bold: true
                    }
                    Label {
                        id: timeLabel
                        text: eventType == "m.room.messagetext" ? time.toLocaleTimeString("hh:mm") : ""
                        anchors.right: parent.right
                        anchors.verticalCenter: bubble.verticalCenter
                        font.pixelSize: Theme.fontSizeTiny
                        color: Theme.secondaryColor
                    }
                }

                Label {
                    x: parent.x + Theme.paddingLarge + Theme.paddingMedium
                    width: parent.width - x
                    height: eventType == "m.room.messagetext" ? undefined:  lineCount* font.pixelSize + Theme.paddingMedium
                    id: chattext
                    text: content
                    verticalAlignment: Text.AlignBottom
                    horizontalAlignment: eventType == "m.room.messagetext" ? Text.AlignLeft : Text.AlignHCenter
                    color: eventType == "m.room.messagetext" ? Theme.primaryColor: Theme.secondaryColor
                    wrapMode: Text.WordWrap
                    font.pixelSize: eventType == "m.room.messagetext" ? Theme.fontSizeSmall : Theme.fontSizeTiny
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





        VerticalScrollDecorator {
            flickable: chatView
        }

        /*delegate: Row {
            id: message
            width: parent.width
            spacing: 8

            Label {
                id: timelabel
                text: time.toLocaleTimeString("hh:mm:ss")
                color: "grey"
            }
            Label {
                width: 64
                elide: Text.ElideRight
                text: eventType == "message" ? author : "***"
                color: eventType == "message" ? "grey" : "lightgrey"
                horizontalAlignment: Text.AlignRight
            }
            Label {
                text: content
                wrapMode: Text.Wrap
                width: parent.width - (x - parent.x) - spacing
                color: eventType == "message" ? "black" : "lightgrey"
            }
        }*/

        section {
            property: "author"
            //criteria: ViewSection.FullString
            //labelPositioning: ViewSection.InlineLabels
            /*delegate:
                Label {
                    width: parent.width
                    //text: chatView.ListView.nextSection //section.toLocaleString(Qt.locale())
                    horizontalAlignment: Text.AlignHCenter
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: true
                }*/


        }

        onAtYBeginningChanged: {
            if (status === PageStatus.Active && atYBeginning) py.call('pyclient.client.backfill_previous_messages', [currentRoom], function(events) {
                console.log("got events: " + JSON.stringify(events))
                eventWorker.sendMessage(events)
            });
        }
    }


    onStatusChanged: {
      if (status === PageStatus.Active && pageStack.depth === 2) {
          pageStack.pushAttached(Qt.resolvedUrl("UsersPage.qml"))
      }
    }

}



