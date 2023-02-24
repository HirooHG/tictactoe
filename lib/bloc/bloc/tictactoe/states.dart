
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class TicTacState {

  IO.Socket socket;

  TicTacState({
    required this.socket
  });
}
class InitTicTacState extends TicTacState {
  InitTicTacState({
    required super.socket
  });

  void init(BuildContext context) {

    print(socket.connected);

    socket.onConnect((data) {
      print(data);
    });
  }
}