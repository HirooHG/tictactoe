
import 'package:bloc/bloc.dart';

class PageManager extends Cubit<bool> {
  PageManager() : super(false);

  void change(bool change) => emit(change);
}