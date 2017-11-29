import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: settingsPage

    Column {
        width: parent.width -x
        spacing: Theme.paddingMedium
        x: Theme.paddingLarge

        PageHeader {title: "Settings"}

        SectionHeader{ text: qsTr("Matriksi Settings") }

        TextSwitch {
            id: colorSwitch
            text: "Fancy colors"
            description: "Use fancy colors on user names"
            checked: useFancyColors
            automaticCheck: false
            onClicked: {
                useFancyColors = !useFancyColors
                settings.setValue("fancycolors", useFancyColors)
            }
        }
        TextSwitch {
            id: bgSwitch
            text: "Dark background"
            description: "Use dark background on chat"
            checked: useBlackBackground
            automaticCheck: false
            onClicked: {
                useBlackBackground = !useBlackBackground
                settings.setValue("blackbackground", useBlackBackground)
            }
        }
    }
 }
