
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/cubits.dart';
import 'package:test_websockets/bloc/bloc/tictactoe/tictacbloc.dart';
import 'package:test_websockets/bloc/view/connectview.dart';
import 'package:test_websockets/bloc/view/mainview.dart';

class TicTacApp extends MaterialApp {
  TicTacApp({super.key}) : super(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<TicTacBloc>(
          create: (_) => TicTacBloc()
        ),
        BlocProvider(
          create: (_) => PageManager()
        )
      ],
      child: const MainView()
    )
  );
}