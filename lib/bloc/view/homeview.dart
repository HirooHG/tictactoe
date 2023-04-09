import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/cubits.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';

import '../bloc/message.dart';
import 'gameview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}
class _HomeViewState extends State<HomeView> {

  late final width = MediaQuery.of(context).size.width;
  late final height = MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicTacBloc>(context).add(AddListenerEvent(callback: onMessage));
    var name = BlocProvider.of<PageManager>(context).state.name;
    Message msg = Message(action: "connect", data: name);
    BlocProvider.of<TicTacBloc>(context).add(SendMessageEvent(message: msg));
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<TicTacBloc>(context).add(RemoveListenerEvent(callback: onMessage));
  }

  void onMessage(message) {
    var msg = Message.fromMap(jsonDecode(message));

    switch(msg.action) {
      case 'connected':
        BlocProvider.of<TicTacBloc>(context).add(UpdatePlayerEvent(message: msg));
        break;
      case 'list':
        BlocProvider.of<TicTacBloc>(context).add(RefreshPlayersEvent(message: msg));
        break;
      case 'newGame':
        BlocProvider.of<TicTacBloc>(context).add(ChallengedPlayerEvent(message: msg));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: BlocProvider.of<TicTacBloc>(context)
                )
              ],
              child: GameView(prevContext: context)
            )
          )
        );
        break;
    }
  }

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
                        child: const Text(
                          "Players",
                          style: TextStyle(
                            color: Color(0xFF66EFD7),
                            fontSize: 30,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.60,
                        child: ListView.builder(
                          itemCount: tictacState.players.length,
                          itemBuilder: (context, index) {
                            var player = tictacState.players[index];
                            return Container(
                              height: height * 0.1,
                              width: width,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white))
                              ),
                              child: ListTile(
                                title: Text(
                                  player.name,
                                  style: const TextStyle(
                                    color: Color(0xFF66EFD7),
                                    fontFamily: "Ubuntu",
                                  ),
                                ),
                                trailing: (player.id == tictacState.currentPlayer.id)
                                  ? const Text(
                                   "Me",
                                  style: TextStyle(
                                    color: Color(0xFF66EFD7),
                                    fontFamily: "Ubuntu",
                                  ),
                                )
                                : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: TextButton(
                                    child: const Text(
                                     "Play",
                                      style: TextStyle(
                                        color: Color(0xFF048D75),
                                        fontFamily: "Ubuntu",
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<TicTacBloc>(context).add(NewGameEvent(player: player));
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(
                                                value: BlocProvider.of<TicTacBloc>(context)
                                              )
                                            ],
                                            child: GameView(prevContext: context)
                                          )
                                        )
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
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
              )
            );
          },
        ),
      ),
    );
  }
}