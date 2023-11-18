import 'package:flutter/foundation.dart';

extension LogEx on dynamic {
  void log() {
    if (kDebugMode) {
      print(this);
    }
  }
}

extension StringEx on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
