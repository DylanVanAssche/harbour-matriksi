import QtQuick 2.2
import Sailfish.Silica 1.0

Page {


    ListModel {id: usersModel}

    SilicaListView {
        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: joinedRooms[currentRoom].displayname + " members"
        }

        model: usersModel
        delegate: ListItem {
            contentHeight: Theme.itemSizeMedium
            Rectangle {
                id: bubble
                x:Theme.paddingMedium
                height: parent.height * 0.6
                width: height
                radius: height/2
                anchors.verticalCenter: parent.verticalCenter
                color: useFancyColors ? model.fancycolor: Theme.secondaryHighlightColor
                Label {
                    anchors.centerIn: parent
                    text: displayname.charAt(0).toUpperCase()
                    font.pixelSize: parent.height *0.8
                }
            }
            Column {
                width: parent.width-bubble.width-bubble.x
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: bubble.right
                anchors.leftMargin: Theme.paddingMedium
                Label{
                    width: parent.width
                    color: useFancyColors ? model.fancycolor: Theme.primaryColor
                    text: model.displayname
                    font.bold: true
                }
                Label{
                    width: parent.width
                    color: Theme.secondaryColor
                    text: model.user_id
                }
            }


        }
        VerticalScrollDecorator {
            flickable: listView
        }
    }
    Component.onCompleted: {
        //var members
        /*py.call('pyclient.client.get_joined_members', [currentRoom], function (data) {
            members = data
            append(members)
        });*/
        append(currentRoomMembers)

    }

    function append(members) {
        //console.log("got members: " + JSON.stringify(members))
        for (var i in members) {
            var displayname =  i
            var string = JSON.stringify(members[i]),
                substring = "displayname";
            if (string.indexOf(substring) !== -1) {
                displayname = members[i].displayname
            }
            //console.log("adding user: "+ displayname)
            usersModel.append({"displayname": displayname, "user_id": i, "fancycolor": stringToColour(displayname)})
            /*for (var j=0; j<roomEvents.count;j++) {
                if (roomEvents.get(j).author == i) {
                    roomEvents.setProperty(j, "author", displayname)
                }
            }*/
        }
    }
}
