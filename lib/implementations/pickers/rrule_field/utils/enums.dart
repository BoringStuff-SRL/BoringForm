import 'package:flutter/foundation.dart';

enum ByMonthDayOccurrence {
  monday([1]),
  tuesday([2]),
  wednesday([3]),
  thursday([4]),
  friday([5]),
  saturday([6]),
  sunday([7]),
  day([1, 2, 3, 4, 5, 6, 7]),
  weekday([1, 2, 3, 4, 5]),
  weekendDay([6, 7]);

  const ByMonthDayOccurrence(this.value);

  final List<int> value;

  String get tr => switch (this) {
        ByMonthDayOccurrence.monday => "Lunedì",
        ByMonthDayOccurrence.tuesday => "Martedì",
        ByMonthDayOccurrence.wednesday => "Mercoledì",
        ByMonthDayOccurrence.thursday => "Giovedì",
        ByMonthDayOccurrence.friday => "Venerdì",
        ByMonthDayOccurrence.saturday => "Sabato",
        ByMonthDayOccurrence.sunday => "Domenica",
        ByMonthDayOccurrence.day => "Giorno",
        ByMonthDayOccurrence.weekday => "Giorno feriale",
        ByMonthDayOccurrence.weekendDay => "Giorno festivo",
      };

  factory ByMonthDayOccurrence.fromList(List<int> list) {
    list.sort((a, b) => a.compareTo(b));
    return values.firstWhere(
      (element) => listEquals(element.value, list),
    );
  }
}

enum BySetPos {
  first(1),
  second(2),
  third(3),
  fourth(4),
  last(-1);

  const BySetPos(this.value);

  final int value;

  String get tr => switch (this) {
        BySetPos.first => "Primo",
        BySetPos.second => "Secondo",
        BySetPos.third => "Terzo",
        BySetPos.fourth => "Quarto",
        BySetPos.last => "Ultimo",
      };

  String get trFem => switch (this) {
        BySetPos.first => "Prima",
        BySetPos.second => "Seconda",
        BySetPos.third => "Terza",
        BySetPos.fourth => "Quarta",
        BySetPos.last => "Ultima",
      };

  factory BySetPos.fromValue(int value) =>
      values.firstWhere((element) => element.value == value);
}

enum RecurrenceEndType {
  never,
  date,
  after;

  String get tr => switch (this) {
        RecurrenceEndType.never => "Mai",
        RecurrenceEndType.date => "Data",
        RecurrenceEndType.after => "Dopo",
      };
}

enum MonthlyRecurrenceType {
  days,
  dayOfMonthOccurrence;

  String get tr => switch (this) {
        MonthlyRecurrenceType.days => "Giorni nel mese",
        MonthlyRecurrenceType.dayOfMonthOccurrence => "Ricorrenza nel mese",
      };
}
