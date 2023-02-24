
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectView extends StatelessWidget {
  const ConnectView({super.key});

  @override
  Widget build(BuildContext context) {

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