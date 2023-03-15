
import 'package:bloc/bloc.dart';

class PageManager extends Cubit<PageValue> {
  PageManager() : super(PageValue.empty());

  void change(PageValue value) => emit(value);
}

class PageValue {

  bool value;
  String name;

  bool call() => value;

  PageValue({required this.value, required this.name});

  PageValue.empty() :
      value = false,
      name = "";
}