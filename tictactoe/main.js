// -----------------------------------------------------------
// Paramètres
// -----------------------------------------------------------
var webSocketsServerPort = 34263; // Adaptez le numéro de port à utiliser



// -----------------------------------------------------------
// Variables globales
// websocket et http servers
// -----------------------------------------------------------
var webSocketServer = require('websocket').server;
var http = require('http');



// -----------------------------------------------------------
// HTTP server pour implémenter les WebSockets
// -----------------------------------------------------------
var server = http.createServer(function(request, response) {
  // Non important pour nous car nous écrivons à WebSocket server
  // et non un HTTP server
});



// -----------------------------------------------------------
// When the server is ready to work
// -----------------------------------------------------------
server.listen(webSocketsServerPort, function() {
  console.log((new Date()) + " Serveur à l'écoute du port "
      + webSocketsServerPort);
});



// -----------------------------------------------------------
// When the server is ready to work
// -----------------------------------------------------------
var wsServer = new webSocketServer({
  // WebSocket server est lié à un HTTP server.
  // Un requête WebSocket n'est qu'une extension d'une requête HTTP.
  // Plus d'informations: http://tools.ietf.org/html/rfc6455#page-6
  httpServer: server
});




// -----------------------------------------------------------
// Cette fonction est appelée à chaque fois d'un client 
// tente de se connecter au WebSocket server
// -----------------------------------------------------------
wsServer.on('request', function(request) {
    
    var connection = request.accept(null, request.origin); 
	
    let point = 0;


    //
    // A nouveau joueur s'est connecté.  Mémorisons son socket
    //
    var player = new Player(request.key, connection, point);



    //
    // Ajoutons ce joueur à la liste de tous les joueurs
    //
    Players.push(player);



    //
    // Nous devons retourner l'identifiant unique de ce joueur au joueur lui-même
    //
    connection.sendUTF(JSON.stringify({action: 'connect', data: player.id, points : point}));



    //
    // Ecoutons tous les messages émis par ce joueur
    //
    connection.on('message', function(data) {

      //
      // Gestion des actions
      //
      var message = JSON.parse(data.utf8Data);

      switch(message.action){
        //
        // Lorsqu'un joueur envoie une action "join", il fournit un nom.
        // Mémorisons ce nom et maintenant qu'il en a un, 
        // envoyons une liste mise-à-jour de tous les joueurs à 
        // tous les joueurs
        //
        case 'join':
            player.name = message.data;
            player.point = message.other;
            BroadcastPlayersList();
            break;

        //
        // Quand un joueur se "couche", nous devons cassez la relation
        // entre les 2 joueurs de la partie et notifier l'autre joueur
        // que le premier s'est couché
        //
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

        //
        // Un joueur initie une nouvelle partie.
        // Créons la relation entre les deux joueurs de la partie
        // et notifions l'autre joueur que la partie commence
        // 
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

        //
        // Un joueur joue un mouvement.  Envoyons ce mouvement à l'autre joueur
        //
        case 'play':
            Players[player.opponentIndex]
              .connection
              .sendUTF(JSON.stringify({'action':'play', 'data': message.data, 'other' : message.other}));
            break;
      }
    });



    //
    // L'utilisateur se déconnecte
    //
    connection.on('close', function(data) {
      Players.splice(player.index, 1);
      BroadcastPlayersList();
    });
});

// -----------------------------------------------------------
// Liste des joueurs
// -----------------------------------------------------------
var Players = [];

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
        var self = this;
        Players.forEach(function(player, index){
            if (player.id == id){
                self.opponentIndex = index;
                Players[index].opponentIndex = self.index;
                return false;
            }
        });
    }
};

// ---------------------------------------------------------
// Routine qui envoie la liste de tous les joueurs à tout
// le monde
// ---------------------------------------------------------
function BroadcastPlayersList(){
    var playersList = [];
    Players.forEach(function(player){
        if (player.name !== ''){
            playersList.push(player.getId());
        }
    });

    var message = JSON.stringify({
        'action': 'players_list',
        'data': playersList
    });

    Players.forEach(function(player){
        player.connection.sendUTF(message);
    });
}