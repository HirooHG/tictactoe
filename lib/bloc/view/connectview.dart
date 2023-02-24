
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectView extends StatelessWidget {
  ConnectView({super.key});

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {

    if(!isLoaded) {
      BlocProvider.of<TicTacBloc>(context).add(InitTicTacEvent(context: context));
      isLoaded = true;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () {
            },
            child: const Text(
              "connect"
            ),
          ),
        ),
      ),
    );
  }
}