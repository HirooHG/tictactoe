
import 'dart:convert';

class Message {

  final String action;
  final String data;

  Message({required this.action, required this.data});

  call() {
    return jsonEncode({
      "action": action,
      "data": data
    });
  }
}