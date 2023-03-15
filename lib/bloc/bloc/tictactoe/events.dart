
import '../message.dart';
import '../player.dart';

abstract class TicTacEvent {
  const TicTacEvent();
}
class InitTicTacEvent extends TicTacEvent {
  const InitTicTacEvent();
}
class SendMessageEvent extends TicTacEvent {
  const SendMessageEvent({required this.message});

  final Message message;
}
class RemoveListenerEvent extends TicTacEvent {
  const RemoveListenerEvent({required this.callback});

  final Function callback;
}
class AddListenerEvent extends TicTacEvent {
  const AddListenerEvent({required this.callback});

  final Function callback;
}
class CloseSocketEvent extends TicTacEvent {
  const CloseSocketEvent();
}
class RefreshPlayersEvent extends TicTacEvent {
  const RefreshPlayersEvent({required this.message});

  final Message message;
}
class UpdatePlayerEvent extends TicTacEvent {
  const UpdatePlayerEvent({required this.message});

  final Message message;
}
class NewGameEvent extends TicTacEvent {
  const NewGameEvent({required this.player});

  final Player player;
}
class ChallengedPlayerEvent extends TicTacEvent {
  const ChallengedPlayerEvent({required this.message});

  final Message message;
}
