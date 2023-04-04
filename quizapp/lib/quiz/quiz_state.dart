import 'package:flutter/material.dart';
import 'package:quizapp/services/models.dart';

class QuizState with ChangeNotifier {
  double _val = 0;
  Option? _opt;

  final PageController con = PageController();

  double get value => _val;
  Option? get option => _opt;

  set value(double newval) {
    _val = newval;
    notifyListeners();
  }

  set option(Option? newval) {
    _opt = newval;
    notifyListeners();
  }

  void nextpage() async {
    await con.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
