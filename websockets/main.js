const webSocketsServerPort = 3402;
const webSocketServer = require('websocket').server;
const http = require('http');
const server = http.createServer(function(request, response) {});

server.listen(webSocketsServerPort, function() {
  console.log((new Date()) + " Serveur à l'écoute du port " + webSocketsServerPort);
});

const wsServer = new webSocketServer({
  httpServer: server
});

wsServer.on('request', function(request) {
    
    const connection = request.accept(null, request.origin);
    let point = 0;
    const player = new Player(request.key, connection, point);

    Players.push(player);

    connection.sendUTF(JSON.stringify({action: 'connect', data: player.id, points : point}));

    console.log("yay");

    connection.on('message', function(data) {
      let message = JSON.parse(data.utf8Data);

      switch(message.action){
        case 'join':
            player.name = message.data;
            player.point = message.other;
            BroadcastPlayersList();
            break;
        case 'resign':
          Players[player.opponentIndex]
            .connection
            .sendUTF(JSON.stringify({'action':'resigned'}));

          (Players[player.opponentIndex]).point += 1;

          setTimeout(function(){
            Players[player.opponentIndex].opponentIndex = player.opponentIndex = null;
          }, 0);

          BroadcastPlayersList();
          break;

        case 'new_game':
            player.setOpponent(message.data);
            Players[player.opponentIndex]
              .connection
              .sendUTF(JSON.stringify({'action':'new_game', 'data': player.name, 'other': player.point}));
            break;

        case 'win':
          Players[player.opponentIndex]
              .connection
              .sendUTF(JSON.stringify({'action':'lost'}));
          player.point += 1;

          setTimeout(function(){
            Players[player.opponentIndex].opponentIndex = player.opponentIndex = null;
          }, 0);

          BroadcastPlayersList();
          break;

        case 'play':
            Players[player.opponentIndex]
              .connection
              .sendUTF(JSON.stringify({'action':'play', 'data': message.data, 'other' : message.other}));
            break;
      }
    });

    connection.on('close', function(data) {
      Players.splice(player.index, 1);
      BroadcastPlayersList();
    });
});

let Players = [];

function Player(id, connection, points){
    this.id = id;
    this.connection = connection;
    this.name = "";
    this.opponentIndex = null;
    this.index = Players.length;
    this.point = points;
}

Player.prototype = {
    getId: function(){
        return {name: this.name, id: this.id, point: this.point};
    },
    setOpponent: function(id){
        let self = this;
        Players.forEach(function(player, index){
            if (player.id === id){
                self.opponentIndex = index;
                Players[index].opponentIndex = self.index;
                return false;
            }
        });
    }
};

function BroadcastPlayersList(){
    let playersList = [];
    Players.forEach(function(player){
        if (player.name !== ''){
            playersList.push(player.getId());
        }
    });

    let message = JSON.stringify({
        'action': 'players_list',
        'data': playersList
    });

    Players.forEach(function(player){
        player.connection.sendUTF(message);
    });
}