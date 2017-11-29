import pyotherside

import sys
import time

from client import MatrixClient, Room
from api import MatrixRequestError
from requests.exceptions import MissingSchema


class PyClient ():
    def __init__(self):
        self.host = ""
        self.username = ""
        self.eventuid = ""
        self.room_id = None


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

    def connect(self, host, username, password, token=None):
        self.client = MatrixClient(host, token, username)
        if token == None:
            self.token = self.client.login_with_password(username, password, 50)
            return self.client.token
        else:
            return "success"

    def get_rooms(self):
        return self.client.get_rooms()

    def get_rooms_and_names(self):
        rooms = {}
        members = {}
        currentrooms = self.client.get_rooms()
        for room in currentrooms:
            name = None
            topic = self.client.rooms[room].topic
            name = self.client.rooms[room].name
            if name == None:
                count = len(self.client.rooms[room].aliases)
                if count > 0:
                    name = self.client.rooms[room].aliases[0]
                if name == None:
                    members = self.client.rooms[room].get_joined_members()
                    keys = list(members.keys())
                    #pyotherside.send(keys[0])
                    name = members[keys[0]]['displayname']
                    if name == None:
                        name = keys[0]
                    if name == self.client.user_id:
                        name = members[keys[1]]['displayname']
                        if name == None:
                            name = keys[1]
            members = self.client.rooms[room].get_joined_members()
            rooms[room] = {'displayname': name, 'members': members, 'topic': topic}
            #rooms[['displayname'] = name
        return rooms

    def get_joined_members(self, room_id):
        #rooms = self.client.get_rooms()
        #self.rooms = self.client.rooms
        return self.client.rooms[room_id].get_joined_members()

    def get_room_name(self, room_id):
        room = []
        name = self.client.rooms[room_id].name
        if name == None:
            count = len(self.client.rooms[room_id].aliases)
            if count > 0:
                name = self.client.rooms[room_id].aliases[0]
            if name == None:
                members = self.client.rooms[room_id].get_joined_members()
                keys = list(members.keys())
                #pyotherside.send(keys[0])
                name = members[keys[0]]['displayname']
                if name == None:
                    name = keys[0]
                if name == self.client.user_id:
                    name = members[keys[1]]['displayname']
                    if name == None:
                        name = keys[1]
        room.append(
            {
                'room_id': room_id,
                'name': name,
            }
        )
        #name = self.client.rooms[room_id].name
        #room.append({"room_id": room_id, "name": name})
        return room

    def send_text(self, room_id, text):
        return self.client.rooms[room_id].send_text(text)

    def get_room_aliases(self, room_id):
        return self.client.rooms[room_id].aliases

    def enter_room(self, room_id):
        #self.client.room = self.client.rooms[room_id]
        return self.client.rooms[room_id].events

    def get_room_events(self, room_id):
        return self.client.rooms[room_id].events

    def get_joined_members(self, room_id):
        return self.client.rooms[room_id].get_joined_members()

    def backfill_previous_messages(self, room_id):
        events = self.client.rooms[room_id].backfill_previous_messages()
        #events = reversed(events)
        return events

    def join_room(self, room_id):
        self.room = self.client.join_room(room_id)
        return self.room

    def start_listeners(self):
        self.client.add_listener(pyotherside.send)
        #self.client.add_ephemeral_listener(pyotherside.send)
        #self.client.add_invite_listener(pyotherside.send)
        self.client.start_listener_thread()
        return 'self.eventui'

    def get_download_url(self, mxcurl):
        return self.client.api.get_download_url(mxcurl)

def called_when_exiting():
   print('Now exiting the application...')

client = PyClient()
pyotherside.atexit(called_when_exiting)
print('python loaded')
