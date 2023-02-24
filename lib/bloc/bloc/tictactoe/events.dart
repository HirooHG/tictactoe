
import '../message.dart';

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
