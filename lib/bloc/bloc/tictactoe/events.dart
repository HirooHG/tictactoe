
import 'package:flutter/cupertino.dart';

abstract class TicTacEvent {
  const TicTacEvent();
}

class InitTicTacEvent extends TicTacEvent {
  const InitTicTacEvent({required this.context});

  final BuildContext context;
}