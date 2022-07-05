import 'package:flutter/material.dart';
import 'game_communication.dart';

Future<void> popup({String? title = "", String? text = "", required BuildContext context}) async{

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title!),
        content: Text(
          text!,
          style: const TextStyle(
              color: Colors.blue,
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


class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.opponentName,
    required this.character,
    required this.points
  }): super(key: key);

  ///
  /// Nom de l'adversaire
  ///
  final String opponentName;

  ///
  /// Points de l'adversaire
  ///
  final int points;

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

      case 'lost':
        Navigator.of(context).pop();
        popup(context: context, text: "You lost", title: "NT !");

        setState(() {});
        break;

      case 'play':
        var data = (message["data"] as String).split(';');
        grid[int.parse(data[0])] = data[1];

        turn = true;

        setState((){});
        break;
    }
  }
  _doResign(){
    game.send('resign', '');
    Navigator.pop(context);
  }
  bool _verifGrid(){
    bool x1 = grid[0] == widget.character && grid[1] == widget.character && grid[2] == widget.character;
    bool x2 = grid[3] == widget.character && grid[4] == widget.character && grid[5] == widget.character;
    bool x3 = grid[6] == widget.character && grid[7] == widget.character && grid[8] == widget.character;

    bool y1 = grid[0] == widget.character && grid[3] == widget.character && grid[6] == widget.character;
    bool y2 = grid[1] == widget.character && grid[4] == widget.character && grid[7] == widget.character;
    bool y3 = grid[2] == widget.character && grid[5] == widget.character && grid[8] == widget.character;

    bool d1 = grid[0] == widget.character && grid[4] == widget.character && grid[8] == widget.character;
    bool d2 = grid[2] == widget.character && grid[4] == widget.character && grid[6] == widget.character;

    return x1 || x2 || x3 || y1 || y2 || y3 || d1 || d2;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
            title: Text('Game against: ${widget.opponentName} ; ${widget.points}', style: const TextStyle(fontSize: 16.0)),
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

          if(_verifGrid()){
            game.send('win', '');
            Navigator.pop(context);
            popup(context: context, text: "${game.playerName} won !", title: "GG !");

            setState(() {});
          }else{
            game.send('play', '$index;${widget.character}');

            turn = false;
          }
        }
        setState((){});
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