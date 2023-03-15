
import 'dart:convert';

class Message {

  final String action;
  final dynamic data;

  Message({required this.action, required this.data});

  Message.fromMap(dynamic map) :
      action = map["action"],
      data = map["data"];

  String call() {
    return jsonEncode({
      "action": action,
      "data": data
    });
  }

  @override
  String toString() {
    return "action : $action\n"
        "data: $data";
  }
}