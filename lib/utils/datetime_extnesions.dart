import 'package:flutter/material.dart';

extension DateComparison on DateTime {
  bool operator >(other) => compareTo(other) > 0;

  bool operator <(other) => compareTo(other) < 0;

  bool operator >=(other) => compareTo(other) >= 0;

  bool operator <=(other) => compareTo(other) <= 0;
}

extension TimeComparison on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  bool operator >(other) => compareTo(other) > 0;

  bool operator <(other) => compareTo(other) < 0;

  bool operator >=(other) => compareTo(other) >= 0;

  bool operator <=(other) => compareTo(other) <= 0;
}
