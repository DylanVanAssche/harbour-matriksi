import QtQuick 2.2
import QtQuick.LocalStorage 2.0

QtObject {
    id: settings


    signal settingsLoaded ();

    function openDatabase() {
        return LocalStorage.openDatabaseSync("Matriksi", "1.0", "Matrix client with python", 100000)
    }

    function initialize() {
        var db = openDatabase()
        db.transaction(
            function(tx) {
                tx.executeSql("CREATE TABLE IF NOT EXISTS Matriksi(name TEXT UNIQUE, value TEXT)")
            }
        )
    }

    function setValue(name, value) {
        var db = openDatabase()
        var res = "Error"
        db.transaction(
            function(tx) {
                var rs = tx.executeSql("INSERT OR REPLACE INTO Matriksi VALUES(?, ?)", [name,value])
                if (rs.rowsAffected > 0)
                    res = "OK"
            }
        )
        return res
    }

    function getPlayers() {
        var db = openDatabase()
        var res = "Unknown"
        db.transaction(
            function(tx) {
                // Show all added greetings
                var rs = tx.executeSql('SELECT * FROM Matriksi');
                for(var i = 0; i < rs.rows.length; i++) {
                    playersModel.append({"name": rs.rows.item(i).name, "ip":rs.rows.item(i).ip, "port":rs.rows.item(i).port})
                }
                if (rs.rowsAffected > 0 || rs.rows.length > 0)
                    res = "OK"
            }
        )
        return res
    }


    function deletePlayer(name) {
        var db = openDatabase()
        var res = "Error"
        db.transaction(
            function(tx) {
                var rs = tx.executeSql("DELETE FROM Players WHERE name = ?", [name]);
                if (rs.rowsAffected > 0)
                    res = "OK"
            }
        )
        return res
    }
    function clearDB() { // for dev purposes
        var db = openDatabase()
        db.transaction(
            function(tx){
                tx.executeSql('DELETE FROM Players WHERE 1');
        });
    }


    function loadPlayer() {
        //playersModel.append({"ip":"192.168.0.81", "port":"6680" })
        connectToPlayer(0);
    }



}
