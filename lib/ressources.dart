
class Ressources {
  static const String raspi = "ws://hugogolliet.fr:34002/ws/tictactoe";
  static const String portable = "ws://192.168.1.60:3402/ws/tictactoe";
  static const String localhost = "ws://localhost:3402/ws/tictactoe";

  static String get address => portable;
}