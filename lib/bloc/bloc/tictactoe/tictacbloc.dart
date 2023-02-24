
import 'package:bloc/bloc.dart';
import 'package:test_websockets/ressources.dart';
import 'package:web_socket_channel/io.dart';

import 'events.dart';
import 'states.dart';

class TicTacBloc extends Bloc<TicTacEvent, TicTacState> {
  TicTacBloc() : super(InitTicTacState(
    socket: IOWebSocketChannel.connect(Ressources.address),
    listeners: [],
    isOn: false
  )) {
    on<TicTacEvent>(onTicTacEvent);
  }

  void onTicTacEvent(TicTacEvent event, Emitter<TicTacState> emit) {
    switch(event.runtimeType) {
      case SendMessageEvent:
        emit(MessageSentState(
          socket: state.socket,
          listeners: state.listeners,
          isOn: state.isOn,
          message: (event as SendMessageEvent).message
        ));
        break;
      case RemoveListenerEvent:
        emit(RemovedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          isOn: state.isOn,
          callback: (event as RemoveListenerEvent).callback
        ));
        break;
      case AddListenerEvent:
        emit(AddedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          isOn: state.isOn,
          callback: (event as AddListenerEvent).callback
        ));
        break;
      case CloseSocketEvent:
        emit(ClosedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          isOn: state.isOn,
        ));
        break;
    }
  }
}