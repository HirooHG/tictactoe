
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/message.dart';

class GameView extends StatefulWidget {
  const GameView({super.key, required this.prevContext});

  final BuildContext prevContext;

  @override
  State<GameView> createState() {
    return _GameViewState();
  }
}
class _GameViewState extends State<GameView> {

  List<String> grid = <String>["","","","","","","","",""];

  late final width = MediaQuery.of(context).size.width;
  late final height = MediaQuery.of(context).size.height;
  bool hasQuit = true;

  Future<void> popup({String title = "", String text = "", required BuildContext context}) async{

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          backgroundColor: const Color(0xFF1a1a1a),
          content: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF66EFD7),
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicTacBloc>(context).add(AddListenerEvent(callback: onMessage));
  }

  @override
  void dispose() {
    BlocProvider.of<TicTacBloc>(widget.prevContext).add(AddListenerEvent(callback: onMessage));
    if(hasQuit) {
      BlocProvider.of<TicTacBloc>(widget.prevContext).add(const ResignPlayerEvent());
    }
    super.dispose();
  }

  void onMessage(message){
    var msg = Message.fromMap(jsonDecode(message));

    switch(msg.action){
      case 'resigned':
        BlocProvider.of<TicTacBloc>(widget.prevContext).add(const WinPlayerEvent());
        popup(context: context, text: "You won", title: "GG ! He just resigned");
        Navigator.of(context).pop();
        break;

      case 'lost':
        BlocProvider.of<TicTacBloc>(widget.prevContext).add(const PlayerLoseEvent());
        popup(context: context, text: "You lost", title: "NT !");
        Navigator.of(context).pop();
        break;

      case 'play':
        var data = int.parse(msg.data);
        var character = BlocProvider.of<TicTacBloc>(widget.prevContext).state.currentPlayer.opponent!.character!;
        grid[data] = character;
        BlocProvider.of<TicTacBloc>(widget.prevContext).add(const OpponentPlayPlayerEvent());
        break;
    }
  }

  bool verif(){
    var character = BlocProvider.of<TicTacBloc>(context).state.currentPlayer.character;
    bool x1 = grid[0] == character && grid[1] == character && grid[2] == character;
    bool x2 = grid[3] == character && grid[4] == character && grid[5] == character;
    bool x3 = grid[6] == character && grid[7] == character && grid[8] == character;

    bool y1 = grid[0] == character && grid[3] == character && grid[6] == character;
    bool y2 = grid[1] == character && grid[4] == character && grid[7] == character;
    bool y3 = grid[2] == character && grid[5] == character && grid[8] == character;

    bool d1 = grid[0] == character && grid[4] == character && grid[8] == character;
    bool d2 = grid[2] == character && grid[4] == character && grid[6] == character;

    return x1 || x2 || x3 || y1 || y2 || y3 || d1 || d2;
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
                        child: Text(
                          (tictacState.currentPlayer.opponent != null) ?
                            tictacState.currentPlayer.opponent!.name :
                            "no opp",
                          style: const TextStyle(
                            color: Color(0xFF66EFD7),
                            fontSize: 20,
                            fontFamily: "Ubuntu",
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          (tictacState.currentPlayer.turn != null && tictacState.currentPlayer.opponent != null )
                              ? (tictacState.currentPlayer.turn!)
                                ? "${tictacState.currentPlayer.name}'s turn"
                                : "${tictacState.currentPlayer.opponent!.name}'s turn"
                              : "no one turns",
                          style: const TextStyle(
                            fontFamily: "Ubuntu",
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      _buildBoard()
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

  Widget _buildBoard(){
    return SizedBox(
      height: height * 0.5,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index){
          return _gridItem(index);
        },
      ),
    );
  }

  Widget _gridItem(int index){
    Color color = grid[index] == "X" ? const Color(0xFF1a1a1a) : Colors.white38;

    return BlocBuilder<TicTacBloc, TicTacState>(
      builder: (context, tictacstate) {
        return InkWell(
          onTap: () {
            if (grid[index] == "" && tictacstate.currentPlayer.turn!){
              grid[index] = tictacstate.currentPlayer.character!;

              //verif()
              if(true){
                popup(context: context, text: "U won !", title: "GG !").whenComplete(() {
                  hasQuit = false;
                  Navigator.of(context).pop();
                  BlocProvider.of<TicTacBloc>(context).add(const WinPlayerEvent());
                });
              } else {
                var message = Message(action: "play", data: "$index");
                BlocProvider.of<TicTacBloc>(context).add(PlayPlayerEvent(message: message));
              }
            }
          },
          child: GridTile(
            child: Card(
              color: const Color(0xFF66EFD7),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(grid[index], style: TextStyle(fontSize: 50.0, color: color,))
              ),
            ),
          ),
        );
      }
    );
  }
}