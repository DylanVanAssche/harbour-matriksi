import pyotherside

import sys
import logging

from client import MatrixClient
from api import MatrixRequestError
from requests.exceptions import MissingSchema



class PyClient:
    client = MatrixClient(host)

    try:
        client.login_with_password(username, password)
    except MatrixRequestError as e:
        print(e)
        if e.code == 403:
            print("Bad username or password.")
            sys.exit(4)
        else:
            print("Check your sever details are correct.")
            sys.exit(2)
    except MissingSchema as e:
        print("Bad URL format.")
        print(e)
        sys.exit(3)

    #return "success"
    print("success")
    try:
        room = client.join_room(room_id_alias)
    except MatrixRequestError as e:
        print(e)
        if e.code == 400:
            print("Room ID/Alias in the wrong format")
            sys.exit(11)
        else:
            print("Couldn't find room.")
            sys.exit(12)
            # Called when a message is recieved.

    def on_message(room, event):
        if event['type'] == "m.room.member":
            if event['membership'] == "join":
                pyotherside.send("{0} joined".format(event['content']['displayname']))
        elif event['type'] == "m.room.message":
            if event['content']['msgtype'] == "m.text":
                pyotherside.send("{0}: {1}".format(event['sender'], event['content']['body']))
        else:
            pyotherside.send(event['type'])


    room.add_listener(on_message)
    client.start_listener_thread()




