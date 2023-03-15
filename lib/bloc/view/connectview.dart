
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/cubits.dart';
import 'package:test_websockets/bloc/bloc/message.dart';

import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';

class ConnectView extends StatelessWidget {
  ConnectView({super.key});

  double width = 0;
  double height = 0;

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if(!isLoaded) {
      BlocProvider.of<TicTacBloc>(context).add(const InitTicTacEvent());
      isLoaded = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        shadowColor: Colors.white,
        elevation: 1.0,
        title: const Text(
          "Tic Tac Toe App",
          style: TextStyle(
            fontFamily: "Ubuntu",
            color: Color(0xFF66EFD7)
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<TicTacBloc, TicTacState>(
          builder: (context, state) {
            return Container(
              width: width,
              height: height,
              color: const Color(0xFF1a1a1a),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome, What is your name ?!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Ubuntu",
                      color: Color(0xFF66EFD7),
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0x9900A98C),
                    ),
                    width: width * 0.6,
                    child: TextField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        label: Text(
                          "name",
                          style: TextStyle(
                            fontFamily: "Ubuntu",
                            color: Color(0xFF66EFD7),
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      onSubmitted: (value) {
                        BlocProvider.of<PageManager>(context).change(PageValue(value: true, name: value));
                      },
                    ),
                  )
                ],
              )
            );
          }
        ),
      ),
    );
  }
}