import QtQuick 2.2
import Sailfish.Silica 1.0
import "pages"
import io.thp.pyotherside 1.4
import Matriksi 1.0



ApplicationWindow
{
    id: appWindow
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    property string appName: "Matriksi"
    property string version: "0.9.7 Beta"

    property string token: ""
    property var joinedRooms: ({})
    property var currentRoomMembers: ({})

    property bool useFancyColors: true
    property bool useBlackBackground: false

    property bool initialized: false
    property bool showlogin: true

    property string currentRoom: ""
    property int unreadMessages: 0

    Settings {id:settings }

    ListModel {id:myRooms}
    ListModel {id:roomEvents}
    ListModel {id:roomUsers}

    SettingsPage {
        id: settingsPage
    }

    AboutPage {
        id: aboutPage
    }

    function stringToColour(str) {
      var hash = 0;
      for (var i = 0; i < str.length; i++) {
        hash = str.charCodeAt(i) + ((hash << 5) - hash);
      }
      var colour = '#';
      for (var i = 0; i < 3; i++) {
        var value = (hash >> (i * 8)) & 0xFF;
        colour += ('00' + value.toString(16)).substr(-2);
      }
      return colour;
    }

    function urlify(text) {
        var urlRegex = /(https?:\/\/[^\s]+)/g;
        return text.replace(urlRegex, function(url) {
            return '<a href="' + url + '">' + url + '</a>';
        })
        // or alternatively
        // return text.replace(urlRegex, '<a href="$1">$1</a>')
    }

    function login_with_data(host, user, password, token){
        py.call('pyclient.client.connect', [host, user, password, token], function (result) {
            if (result == "success") {
                console.log("Got success: "+token)
            } else {
                console.log("Got new token: "+token)
                settings.setValue("user", user)
                settings.setValue("token", result)
                settings.setValue("host", host)
            }
            initialized = true
            getRoomsAndNames();
        });
    }

    function getRoomsAndNames() {
        py.call('pyclient.client.get_rooms_and_names', [], function(rooms) {
            console.log("got rooms and names: " + JSON.stringify(rooms))
            joinedRooms = rooms
            for (var room in rooms) {
                myRooms.append({"name": rooms[room].displayname, "room_id": room, "unreadmessages": 0, "topic": rooms[room].topic})
            }
            showlogin = false
            initialized = true
            py.call('pyclient.client.start_listeners', [], function(uid) {
                console.log("got uid: " + JSON.stringify(uid))
            });
        });
    }


    function getMembers(room_id) {
        py.call('pyclient.client.get_joined_members', [room_id], function(members) {
            console.log("got members: " + JSON.stringify(members))
        });
    }

    function newEventReceived(events) {
        console.log("Event received: "+ JSON.stringify(events))
        for (var i=0; i<events.length; i++) {
            if (events[i].room_id == currentRoom) {
                insertNewEvent(events)
            } else {
                unreadMessages = unreadMessages+1
                for (var a=0; a<myRooms.count; a++) {
                    if (myRooms.get(a).room_id == events[i].room_id) {
                        var count = myRooms.get(a).unreadmessages + 1
                        myRooms.setProperty(a, "unreadmessages", count)
                        console.log("unread messages in "+events[i].room_id+" is "+myRooms.get(a).unreadmessages)
                    }
                }
            }
        }
    }

    function insertNewEvent(events) {
        for (var i=events.length-1; i>=0; i--) {
            var url = ""
            var thumbnail_url = ""
            var content = "Unkown event"
            var eventType = events[i].type
            if (events[i].type == "m.room.member") {
                if (events[i].membership == "join") {
                    content = events[i].content.displayname +" joined the room"
                } else {
                    if (events[i].membership == "leave") {
                        content = events[i].user_id +" left the room"
                   }
                }
            } else {
                if (events[i].type == "m.room.message") {
                    if (events[i].content.msgtype == "m.text") {
                        eventType = eventType + "text"
                        //if (events[i].content.hasOwnProperty("formatted_body")) content = events[i].content.formatted_body
                        //else content = events[i].content.body
                        content = urlify(events[i].content.body)
                    }
                    if (events[i].content.msgtype == "m.emote") {
                        eventType = eventType + "text"
                        content =  "<i>* "+ events[i].content.body +"</i>"
                    }
                    if (events[i].content.msgtype == "m.notice") {
                        eventType = eventType + "text"
                        content =  "<small>*** "+ events[i].content.body +"</small>"
                    }
                    if (events[i].content.msgtype == "m.image") {
                        eventType = eventType + "image"
                        content =  "<small>"+ events[i].content.body +"</small>"
                        url = events[i].content.url
                        thumbnail_url = events[i].content.info.thumbnail_url
                    }
                }
            }
            var displayname = currentRoomMembers[events[i].sender].displayname
            var time = new Date()
            time = time.getTime()
            var time = new Date(time - events[i].age);
            var fancycolor = stringToColour(events[i].sender)
            roomEvents.insert(0, {"eventType": eventType,"time": time, "author": displayname, "user_id":events[i].sender,"content": content, "fancycolor": fancycolor, "age": events[i].age, "url": url, "thumbnail_url":thumbnail_url })
        }
    }

    WorkerScript {
        id: eventWorker
        source: "./pages/eventWorker.js"
        onMessage: {
            //console.log("Got message")
            if (currentRoomMembers.hasOwnProperty(messageObject.user_id)) {
                if (currentRoomMembers[messageObject.user_id].hasOwnProperty("displayname")) messageObject.author = currentRoomMembers[messageObject.user_id].displayname
            }
            roomEvents.append(messageObject)
        }
    }


    Python {
        id: py
        Component.onCompleted: {
            var pythonpath = Qt.resolvedUrl('.').substr('file://'.length);
            addImportPath(pythonpath);
            console.log(pythonpath);
            importModule('pyclient',  function () {
                console.log('imported python module');
                var host = settings.value("host")
                var token = settings.value("token")
                var user = settings.value("user")
                if(host && token && user) {
                    console.log("Host: "+host +" and token: "+token)
                    login.login(true)
                    var ps
                    login_with_data(host, user, ps, token)
                }
            });
        }
        onReceived: {
            newEventReceived(data)
        }

        onError: {
            console.log("ERROR: " + traceback)
            var string = traceback,
                substring = "M_FORBIDDEN";
            if (string.indexOf(substring) !== -1) {
                console.log("Login M_FORBIDDEN")
                login.loginongoing = false
                login.labeltext = "Matriksi"
                showlogin = true
            }
        }
    }

    Login {
        id: login
        window: window
        anchors.fill: parent
        visible: showlogin
        Component.onCompleted: {

        }
    }
}

