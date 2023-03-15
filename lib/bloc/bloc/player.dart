
class Player {

  String id;
  String name;
  int score;
  Player? opponent;

  Player.empty() :
      id = "",
      name = "",
      score = 0;

  Player({
    required this.id,
    required this.name,
    this.score = 0,
    this.opponent
  });

  Player.fromJson(dynamic map) :
      id = map["id"],
      name = map["name"],
      score = map["points"];

  @override
  String toString() {
    return "id: $id\n"
        "name: $name\n.id"
        "points: $score\n"
        "opponent: ${opponent ?? "no opponent"}";
  }

  @override
  bool operator ==(Object other) {
    return other is Player && other.id == id;
  }
}