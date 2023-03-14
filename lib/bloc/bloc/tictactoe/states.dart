
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:test_websockets/ressources.dart';

import '../message.dart';

abstract class TicTacState {

  WebSocket? socket;
  final List<Function> listeners;

  TicTacState({
    required this.socket,
    required this.listeners,
  });

  void onMessage(message);
}
class InitTicTacState extends TicTacState {
  InitTicTacState({
    required super.socket,
    required super.listeners,
  });

  Future<void> init() async {
    try {
      socket = await WebSocket.connect(
        Ressources.address
      );
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
class MessageSentState extends TicTacState {
  MessageSentState({
    required super.socket,
    required super.listeners,
    required this.message
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