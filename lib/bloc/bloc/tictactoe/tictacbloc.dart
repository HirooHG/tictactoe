
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'events.dart';
import 'states.dart';
import '../player.dart';

class TicTacBloc extends Bloc<TicTacEvent, TicTacState> {
  TicTacBloc() : super(InitTicTacState(
    socket: null,
    listeners: [],
    players: [],
    currentPlayer: Player.empty()
  )) {
    on<TicTacEvent>(onTicTacEvent);
  }

  void onTicTacEvent(TicTacEvent event, Emitter<TicTacState> emit) async {
    switch(event.runtimeType) {
      case InitTicTacEvent:
        var nextState = InitTicTacState(
          socket: state.socket,
          listeners: state.listeners,
          players: state.players,
          currentPlayer: state.currentPlayer,
        );
        await nextState.init();
        emit(nextState);
        break;
      case SendMessageEvent:
        emit(MessageSentState(
          socket: state.socket,
          listeners: state.listeners,
            players: state.players,
            currentPlayer: state.currentPlayer,
          message: (event as SendMessageEvent).message
        ));
        break;
      case RemoveListenerEvent:
        emit(RemovedListenerState(
          socket: state.socket,
          listeners: state.listeners,
            players: state.players,
            currentPlayer: state.currentPlayer,
          callback: (event as RemoveListenerEvent).callback
        ));
        break;
      case AddListenerEvent:
        emit(AddedListenerState(
          socket: state.socket,
          listeners: state.listeners,
            players: state.players,
            currentPlayer: state.currentPlayer,
          callback: (event as AddListenerEvent).callback
        ));
        break;
      case CloseSocketEvent:
        var nextState = ClosedListenerState(
          socket: state.socket,
          listeners: state.listeners,
          players: state.players,
          currentPlayer: state.currentPlayer,
        );
        await nextState.close();
        emit(nextState);
        break;
      case RefreshPlayersEvent:
        emit(
          RefreshedPlayersState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
            message: (event as RefreshPlayersEvent).message
          )
        );
        break;
      case UpdatePlayerEvent:
        emit(
          UpdatedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: Player.fromJson(jsonDecode((event as UpdatePlayerEvent).message.data))
          )
        );
        break;
      case NewGameEvent:
        emit(
          NewGameState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
            player: (event as NewGameEvent).player
          )
        );
        break;
      case ChallengedPlayerEvent:
        emit(
          ChallengedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
            message: (event as ChallengedPlayerEvent).message
          )
        );
        break;
      case WinPlayerEvent:
        emit(
          WonPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
          )
        );
        break;
      case ResignPlayerEvent:
        emit(
          ResignedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
          )
        );
        break;
      case PlayPlayerEvent:
        emit(
          PlayedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
            message: (event as PlayPlayerEvent).message
          )
        );
        break;
      case OpponentPlayPlayerEvent:
        emit(
          OpponentPlayedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
          )
        );
        break;
      case OpponentResignPlayerEvent:
        emit(
          OpponentResignedPlayerState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
          )
        );
        break;
      case PlayerLoseEvent:
        emit(
          PlayerLostState(
            listeners: state.listeners,
            socket: state.socket,
            players: state.players,
            currentPlayer: state.currentPlayer,
          )
        );
        break;
    }
  }
}