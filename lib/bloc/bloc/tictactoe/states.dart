
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import '../message.dart';

abstract class TicTacState {

  final IOWebSocketChannel socket;
  final List<Function> listeners;
  bool isOn;

  TicTacState({
    required this.socket,
    required this.listeners,
    required this.isOn
  });
}
class InitTicTacState extends TicTacState {
  InitTicTacState({
    required super.socket,
    required super.listeners,
    required super.isOn
  });

  void init(BuildContext context) {
    socket.sink.close();

    socket.stream.listen(onMessage);
    isOn = true;
  }

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
    required super.isOn,
    required this.message
  }) {
    sendMessage();
  }

  final Message message;

  void sendMessage() {
    if(isOn) {
      socket.sink.add(message());
    }
  }
}
class RemovedListenerState extends TicTacState {
  RemovedListenerState({
    required super.isOn,
    required super.listeners,
    required super.socket,
    required this.callback
  }) {
    remove();
  }

  final Function callback;

  void remove() {
    if(isOn) {
      listeners.remove(callback);
    }
  }
}
class AddedListenerState extends TicTacState {
  AddedListenerState({
    required super.isOn,
    required super.listeners,
    required super.socket,
    required this.callback
  }) {
    add();
  }

  final Function callback;

  void add() {
    if(isOn) {
      listeners.add(callback);
    }
  }
}
class ClosedListenerState extends TicTacState {
  ClosedListenerState({
    required super.isOn,
    required super.listeners,
    required super.socket,
  });

  void close() {
    if(isOn) {
      socket.sink.close();
      isOn = false;
    }
  }
}