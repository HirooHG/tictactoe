// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/events.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:test_websockets/bloc/bloc/message.dart';
import 'package:flutter/material.dart';

void main() {
  test("test listeners", () {
    TicTacBloc bloc = TicTacBloc();
    bloc.add(const InitTicTacEvent());

    //bloc.add(AddListenerEvent(callback: (message) {
    //  print(message);
    //}));
    //
    //var message = Message(action: "connect", data: "aya");
    //bloc.add(SendMessageEvent(message: message));
  });

  //testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //  // Build our app and trigger a frame.
  //  //await tester.pumpWidget(TicTacApp());

  //  // Verify that our counter starts at 0.
  //  expect(find.text('0'), findsOneWidget);
  //  expect(find.text('1'), findsNothing);

  //  // Tap the '+' icon and trigger a frame.
  //  await tester.tap(find.byIcon(Icons.add));
  //  await tester.pump();

  //  // Verify that our counter has incremented.
  //  expect(find.text('0'), findsNothing);
  //  expect(find.text('1'), findsOneWidget);
  //});
}
