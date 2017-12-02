import QtQuick 2.2
import Sailfish.Silica 1.0

Item {
    property variant window

    property bool showstuff: true

    property bool loginongoing: false

    property alias labeltext: label.text

    function login(pretend) {
        labeltext = qsTr("Please wait loading...")
        if(!pretend) login_with_data(hostNameField.text, userNameField.text, passwordField.text)
        loginongoing = true
        showstuff = false
        accountbutton.opacity = 0
    }

    Column {
        width: parent.width /1.5
        anchors.centerIn: parent
        opacity: 0
        spacing: 18

        Item {
            width: parent.width
            height: 1
        }

        Item {
            width: 128
            height: 128
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                source: "qrc:/res/harbour-matrix.png"

                RotationAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0
                    to: 360
                    duration: 60000
                }
            }
            BusyIndicator {
                anchors.centerIn: parent
                running: showlogin&&loginongoing
                opacity: loginongoing ? 1:0
            }
        }

        Label { id: phantomLabel; visible: false }

        Label {
            opacity: showlogin ? 1:0
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: phantomLabel.font.pixelSize * 3/2
            text: qsTr("Matriksi")
            color: "#888"
        }

        TextField {
            enabled: !loginongoing
            opacity: !loginongoing&&showlogin ? 1:0
            id: userNameField
            width: parent.width
            placeholderText: qsTr("User Name or Matrix ID:")
            label: qsTr("username[:server][:port]");
        }

        TextField {
            enabled: !loginongoing
            opacity: !loginongoing&&showlogin ? 1:0
            id: passwordField
            echoMode: TextInput.Password
            width: parent.width
            placeholderText: qsTr("Password")
        }

        TextField {
            enabled: !loginongoing
            opacity: !loginongoing&&showlogin ? 1:0
            id: hostNameField
            width: parent.width
            text: "https://matrix.org"
            placeholderText: qsTr("https://matrix.org")
        }

        Button {
            opacity: !loginongoing ? 1:0
            enabled: !loginongoing&&showlogin ? 1:0
            id: loginbutton
            text: "Login"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: login()
        }

        Button {
           id: accountbutton
            text: qsTr("Create an Matrix account")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: { Qt.openUrlExternally("https://riot.im/app/#/register");
           }
        }

        NumberAnimation on opacity {
            id: fadeIn
            to: 1.0
            duration: 1500
        }

        Component.onCompleted: fadeIn.start()
    }
}
