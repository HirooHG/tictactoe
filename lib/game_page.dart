import 'package:flutter/material.dart';
import 'game_communication.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.opponentName,
    required this.character,
  }): super(key: key);

  ///
  /// Nom de l'adversaire
  ///
  final String opponentName;

  ///
  /// Caratère utilisé pour les jetons du jeu ("X" ou "O")
  ///
  final String character;

  @override
  State<GamePage> createState() => _GamePageState();
}
class _GamePageState extends State<GamePage> {

  List<String> grid = <String>["","","","","","","","",""];

  late bool turn;

  @override
  void initState(){
    super.initState();
    game.addListener(_onAction);

    turn = widget.character == "X";
  }

  @override
  void dispose(){
    game.removeListener(_onAction);
    super.dispose();
  }

  _onAction(message){
    switch(message["action"]){

      case 'resigned':
        Navigator.of(context).pop();
        break;

      case 'turn':
        turn = true;
        break;

      case 'play':
        var data = (message["data"] as String).split(';');
        grid[int.parse(data[0])] = data[1];

        setState((){});
        break;
    }
  }
  _doResign() => game.send('resign', '');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Game against: ${widget.opponentName}', style: const TextStyle(fontSize: 16.0)),
            actions: <Widget>[
              TextButton(
                onPressed: _doResign,
                child: const Text('Resign', style: TextStyle(color: Colors.white))
              ),
            ]
        ),
        body: _buildBoard(),
      ),
    );
  }

  Widget _buildBoard(){
    return SafeArea(
      top: false,
      bottom: false,
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
    Color color = grid[index] == "X" ? Colors.blue : Colors.red;

    return InkWell(
      onTap: () {
        if (grid[index] == "" && turn){
          grid[index] = widget.character;

          game.send('play', '$index;${widget.character}');

          turn = false;
          setState((){});
        }
      },
      child: GridTile(
        child: Card(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(grid[index], style: TextStyle(fontSize: 50.0, color: color,))
          ),
        ),
      ),
    );
  }
}