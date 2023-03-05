
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'events.dart';
import 'states.dart';

class TicTacBloc extends Bloc<TicTacEvent, TicTacState> {
  TicTacBloc() : super(InitTicTacState(
    socket: null,
    listeners: [],
  )) {
    on<TicTacEvent>(onTicTacEvent);
  }

  void onTicTacEvent(TicTacEvent event, Emitter<TicTacState> emit) async {
    switch(event.runtimeType) {
      case InitTicTacEvent:
        var nextState = InitTicTacState(
          socket: state.socket,
          listeners: state.listeners
        );
        await nextState.init();
        emit(nextState);
        break;
      case SendMessageEvent:
        emit(MessageSentState(
          socket: state.socket,
          listeners: state.listeners,
          message: (event as SendMessageEvent).message
        ));
        break;
      case RemoveListenerEvent:
        emit(RemovedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          callback: (event as RemoveListenerEvent).callback
        ));
        break;
      case AddListenerEvent:
        emit(AddedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          callback: (event as AddListenerEvent).callback
        ));
        break;
      case CloseSocketEvent:
        var nextState = ClosedListenerState(
          socket: state.socket,
          listeners: state.listeners,
        );
        await nextState.close();
        emit(nextState);
        break;
    }
  }
}