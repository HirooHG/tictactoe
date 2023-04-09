
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:test_websockets/ressources.dart';

import '../message.dart';
import '../player.dart';

abstract class TicTacState {

  WebSocket? socket;
  final List<Function> listeners;
  final List<Player> players;
  final Player currentPlayer;

  TicTacState({
    required this.socket,
    required this.listeners,
    required this.players,
    required this.currentPlayer,
  });

  void onMessage(message);
}
class InitTicTacState extends TicTacState {
  InitTicTacState({
    required super.socket,
    required super.listeners,
    required super.players,
    required super.currentPlayer
  });

  Future<void> init() async {
    try {
      socket = await WebSocket.connect(Ressources.address);
      socket!.listen(onMessage);
    } catch(e) {
      if(kDebugMode) {
        print("websocket failed : $e");
      }
    }
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}

// connection
class MessageSentState extends TicTacState {
  MessageSentState({
    required super.socket,
    required super.listeners,
    required this.message,
    required super.players,
    required super.currentPlayer
  }) {
    sendMessage();
  }

  final Message message;

  void sendMessage() {
    if(socket != null) {
      socket!.add(message());
    }
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class RemovedListenerState extends TicTacState {
  RemovedListenerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.callback
  }) {
    remove();
  }

  final Function callback;

  void remove() {
    listeners.remove(callback);
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class AddedListenerState extends TicTacState {
  AddedListenerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.callback
  }) {
    add();
  }

  final Function callback;

  void add() {
    listeners.add(callback);
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class ClosedListenerState extends TicTacState {
  ClosedListenerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  });

  Future<void> close() async {
    if(socket != null) {
      await socket!.close();
    }
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}

// player(s)
class RefreshedPlayersState extends TicTacState {
  RefreshedPlayersState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.message
  }) {
    getPlayers();
  }

  final Message message;

  void getPlayers() {
    var list = message.data as List<dynamic>;
    var newList = <Player>[];
    for(var i in list) {
      var player = Player.fromJson(jsonDecode(i));
      newList.add(player);
    }

    add(newList);
    remove(newList);
  }

  void remove(List<Player> list) {
    for(var i in players) {
      if(!list.any((element) => element.id == i.id)) {
        players.remove(i);
      }
    }
  }

  void add(List<Player> list) {
    for(var i in list) {
      if(!players.any((element) => element.id == i.id)) {
        players.add(i);
      }
    }
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class UpdatedPlayerState extends TicTacState {
  UpdatedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  });

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}

// New game
class NewGameState extends TicTacState {
  NewGameState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.player
  }) {
    newGame();
  }

  final Player player;

  void newGame() {
    var msg = Message(action: "newGame", data: player.id);
    socket!.add(msg());
    player.character = 'X';
    currentPlayer.character = 'O';
    player.turn = true;
    currentPlayer.turn = false;
    currentPlayer.opponent = player;
    player.opponent = currentPlayer;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class ChallengedPlayerState extends TicTacState {
  ChallengedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.message
  }) {
    newGame();
  }

  final Message message;

  void newGame() {
    var player = players.singleWhere((element) => element.id == message.data);
    player.character = 'O';
    currentPlayer.character = 'X';
    player.turn = false;
    currentPlayer.turn = true;
    currentPlayer.opponent = player;
    player.opponent = currentPlayer;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}

// play
class PlayedPlayerState extends TicTacState {
  PlayedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
    required this.message
  }) {
    play();
  }

  final Message message;

  void play() {
    socket!.add(message());
    currentPlayer.turn = false;
    currentPlayer.opponent!.turn = true;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class OpponentPlayedPlayerState extends TicTacState {
  OpponentPlayedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  }) {
    play();
  }

  void play() {
    currentPlayer.turn = true;
    currentPlayer.opponent!.turn = false;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}

// game ended
class OpponentResignedPlayerState extends TicTacState {
  OpponentResignedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  }) {
    resign();
  }

  void resign() {
    if(currentPlayer.opponent!.score != 0) currentPlayer.opponent!.score--;
    currentPlayer.opponent!.score++;
    currentPlayer.opponent!.turn = null;
    currentPlayer.turn = null;
    currentPlayer.opponent!.opponent = null;
    currentPlayer.opponent = null;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class PlayerLostState extends TicTacState {
  PlayerLostState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  }) {
    lose();
  }

  void lose() {
    if(currentPlayer.opponent!.score != 0) currentPlayer.opponent!.score--;
    currentPlayer.opponent!.score++;
    currentPlayer.opponent!.turn = null;
    currentPlayer.turn = null;
    currentPlayer.opponent!.opponent = null;
    currentPlayer.opponent = null;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class WonPlayerState extends TicTacState {
  WonPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  }) {
    won();
  }

  void won() {
    var data = {
      "action": "win",
    };
    socket!.add(jsonEncode(data));
    currentPlayer.score++;
    if(currentPlayer.opponent!.score != 0) currentPlayer.opponent!.score--;
    currentPlayer.opponent!.turn = null;
    currentPlayer.turn = null;
    currentPlayer.opponent!.opponent = null;
    currentPlayer.opponent = null;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
class ResignedPlayerState extends TicTacState {
  ResignedPlayerState({
    required super.listeners,
    required super.socket,
    required super.players,
    required super.currentPlayer,
  }) {
    resign();
  }

  void resign() {
    var data = {
      "action": "resign",
    };
    socket!.add(jsonEncode(data));
    if(currentPlayer.score != 0) currentPlayer.score--;
    currentPlayer.opponent!.score++;
    currentPlayer.opponent!.turn = null;
    currentPlayer.turn = null;
    currentPlayer.opponent!.opponent = null;
    currentPlayer.opponent = null;
  }

  @override
  void onMessage(message) {
    for(var i in listeners) {
      i(message);
    }
  }
}
