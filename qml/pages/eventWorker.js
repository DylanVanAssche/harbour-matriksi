WorkerScript.onMessage = function(events) {
    //console.log(JSON.stringify(events.members))
    for (var i=events.length-1; i>=0; i--) {
        var content = "Unkown event"
        var url = ""
        var thumbnail_url = ""
        var eventType =  events[i].type
        if (events[i].type == "m.room.member") {
            if (events[i].content.membership == "join") {
                content = events[i].sender +" joined the room"
            } else {
                if (events[i].content.membership == "leave") {
                    content = events[i].sender +" left the room"
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
        var displayname = events[i].sender
        /*var string = JSON.stringify(events.members[displayname]),
            substring = "displayname";
        if (string.indexOf(substring) !== -1) {
            displayname = events.members[events[i].sender]
        }*/
        var time = new Date()
        time = time.getTime()
        var time = new Date(time - events[i].age);
        var fancycolor = stringToColour(events[i].sender)
        WorkerScript.sendMessage({"eventType": eventType,"time": time, "author": displayname, "user_id":events[i].sender,"content": content, "fancycolor": fancycolor, "age": events[i].age, "url": url, "thumbnail_url":thumbnail_url })
    }
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
