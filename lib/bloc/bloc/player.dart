
class Player {

  String id;
  String name;
  String password;
  int score;

  Player({
    required this.id,
    required this.name,
    required this.password,
    this.score = 0
  });
}