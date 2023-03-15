
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() {
    return _GameViewState();
  }
}
class _GameViewState extends State<GameView> {

  late final width = MediaQuery.of(context).size.width;
  late final height = MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
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
          builder: (context, tictacState) {
            return Container(
              width: width,
              height: height,
              color: const Color(0xFF1a1a1a),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: height * 0.15,
                        alignment: Alignment.center,
                        width: width,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white))
                        ),
                        child: Text(
                          tictacState.currentPlayer.opponent!.name,
                          style: const TextStyle(
                            color: Color(0xFF66EFD7),
                            fontSize: 20,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: const Color(0xFF2a2a2a),
                      padding: const EdgeInsets.only(right: 30, left: 30),
                      height: height * 0.1,
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tictacState.currentPlayer.name,
                            style: const TextStyle(
                                color: Color(0xFF66EFD7),
                                fontFamily: "Ubuntu",
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "score : ${tictacState.currentPlayer.score}",
                            style: const TextStyle(
                              color: Color(0xFF66EFD7),
                              fontFamily: "Ubuntu",
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}