import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components"

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


        delegate: Component {
            Loader {
                //asynchronous: true
                //visible: status == Loader.Ready
                property ListView view: chatView
                source: switch(model.eventType) {
                    case "m.room.messagetext" : return Qt.resolvedUrl("TextDelegateComponent.qml")
                    case "m.room.messageimage": return Qt.resolvedUrl("ImageDelegate.qml")
                    case "m.room.message" : return Qt.resolvedUrl("TextDelegateComponent.qml")
                    case "m.room.member": return Qt.resolvedUrl("MemberDelegate.qml")
                    default: console.log("unknown event type: "+eventType)
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
            if (atYBeginning) py.call('pyclient.client.backfill_previous_messages', [currentRoom], function(events) {
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



