
import 'package:bloc/bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:test_websockets/ressources.dart';

import 'events.dart';
import 'states.dart';

class TicTacBloc extends Bloc<TicTacEvent, TicTacState> {
  TicTacBloc() : super(InitTicTacState(
      socket: IO.io(Ressources.address)
  )) {
    on<TicTacEvent>(onTicTacEvent);
  }

  void onTicTacEvent(TicTacEvent event, Emitter<TicTacState> emit) {
    switch(event.runtimeType) {
      case InitTicTacEvent:
        var nstate = InitTicTacState(
          socket: state.socket
        );
        nstate.init((event as InitTicTacEvent).context);
        emit(nstate);
        break;
    }
  }
}