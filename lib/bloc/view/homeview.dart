
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/states.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';

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
  void dispose() {
    super.dispose();
    BlocProvider.of<TicTacBloc>(context).add(AddListenerEvent(callback: onMessage));
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicTacBloc>(context).add(RemoveListenerEvent(callback: onMessage));
  }

  void onMessage(message) {

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
            );
          },
        ),
      ),
    );
  }
}