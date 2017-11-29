import QtQuick 2.2
import Sailfish.Silica 1.0
import "../components/custom"

Page {
    id: page

    property var roomevents: ({})

    SilicaListView {

        anchors.fill: parent

        anchors.top: parent.top

        enabled: initialised
        opacity:  initialized ? 1 : 0

        clip: true

        Behavior on opacity {NumberAnimation{duration: 600}}

        PullDownMenu {

            MenuItem {
                 text: qsTr("About Matriksi")
                 onClicked: pageStack.push(aboutPage)
             }

            MenuItem {
                text: qsTr("Settings")
                onClicked:  {
                    pageStack.push(settingsPage)
                }
            }

        MenuItem {
            text: qsTr("Logout")
            onClicked:  {
                py.call('pyclient.client.client.logout', [], function () {
                    settings.setValue("user", "")
                    initialized = false
                    showlogin = true
                });
            }
        }
     }

        model: myRooms
        header: PageHeader{
            title: "Rooms"
        }

        delegate: ListItem {
            width: parent.width
            contentHeight: Theme.itemSizeSmall

            Item {
                height: parent.height
                x: Theme.paddingMedium
                width: parent.width - x-x

            AvatarImage {
                id: roomAvatar
                iconSource: "qrc:///res/harbour-matrix.png"
                iconSize: Theme.paddingLarge + Theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
            }

                Label {
                    text: model.unreadmessages > 0 ? model.name+ " ("+model.unreadmessages+")" : model.name
                    font.bold: (model.unreadmessages > 0)
                    truncationMode: TruncationMode.Fade
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.left: roomAvatar.right
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeMedium
                }
             }

            onClicked: {
                console.log("Room clicked: " + model.room_id)
                roomEvents.clear();
                py.call('pyclient.client.enter_room', [model.room_id], function(events) {
                    console.log("got events: " + JSON.stringify(events))
                    currentRoom = model.room_id
                    unreadMessages = unreadMessages - myRooms.get(index).unreadmessages
                    myRooms.setProperty(index, "unreadmessages", 0)
                    currentRoomMembers = joinedRooms[model.room_id].members
                    pageStack.push(Qt.resolvedUrl("ChatPage.qml"))
                    eventWorker.sendMessage(events);
                    /*py.call('pyclient.client.get_joined_members', [currentRoom], function (data) {
                        console.log("got memmers: " +JSON.stringify(data))
                        roomevents.members = data
                    });*/
                });
            }
        }
    }

    onStatusChanged: {
      if (status === PageStatus.Active && pageStack.depth === 1) {
          currentRoom = ""
      }
    }
}

