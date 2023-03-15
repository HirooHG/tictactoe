
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_websockets/bloc/bloc/cubits.dart';
import 'package:test_websockets/bloc/view/connectview.dart';
import 'package:test_websockets/bloc/view/homeview.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageManager, PageValue>(
      builder: (context, page) => (page()) ? const HomeView() : ConnectView()
    );
  }
}