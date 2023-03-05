
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:test_websockets/bloc/bloc/message.dart';

class ConnectView extends StatelessWidget {
  ConnectView({super.key});

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {

    if(!isLoaded) {
      BlocProvider.of<TicTacBloc>(context).add(const InitTicTacEvent());
      isLoaded = true;
    }

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TicTacBloc, TicTacState>(
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      var message = Message(action: "yay", data: "aya");
                      BlocProvider.of<TicTacBloc>(context).add(SendMessageEvent(message: message));
                    },
                    child: const Text(
                      "send"
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      BlocProvider.of<TicTacBloc>(context).add(AddListenerEvent(callback: (message) {
                        print("yay");
                      }));
                    },
                    child: const Text(
                      "print"
                    ),
                  ),
                ],
              )
            );
          }
        ),
      ),
    );
  }
}