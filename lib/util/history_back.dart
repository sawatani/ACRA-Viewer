library history_back_decorator;

import 'dart:html';

abstract class HistoryBack {
  void back() {
    window.history.back();
  }
}
