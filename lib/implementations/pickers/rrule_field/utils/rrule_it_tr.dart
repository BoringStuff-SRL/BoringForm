import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_ext.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

import 'enums.dart';

class RruleTrIt {
  final RecurrenceRule rrule;

  RruleTrIt({required this.rrule});

  final _days = [
    "lunedì",
    "martedì",
    "mercoledì",
    "giovedì",
    "venerdì",
    "sabato",
    "domenica",
  ];

  String translate() {
    String res = _basicRecurrence();
    String until = _untilRecurrence();
    switch (rrule.frequency) {
      case Frequency.weekly:
        res = res + _convertWeekly();
        break;
      case Frequency.monthly:
        res = res + _converterMonthly();
        break;
      case Frequency.yearly:
        res = res + _converterYearly();
        break;
      default:
        break;
    }
    return res + until;
  }

  String _basicRecurrence() {
    const every = "Ogni";

    if (rrule.interval == 1) {
      return "$every ${rrule.frequency.trForm()}";
    }
    return "$every ${rrule.interval} ${rrule.frequency.trForm(singular: false)}";
  }

  String _untilRecurrence() {
    if (rrule.count != null) {
      String times = rrule.count == 1 ? "volta" : "volte";

      return ", ${rrule.count} $times";
    } else if (rrule.until != null) {
      final until = rrule.until!.toLocal();
      final day = until.day;
      String article = "al ";
      if (day == 1 || day == 8 || day == 11) {
        article = "all'";
      }
      return ", fino $article${DateFormat.yMMMMd("it_IT").format(until)}";
    } else {
      return "";
    }
  }

  String _convertWeekly() {
    final days = rrule.byWeekDays..sort((a, b) => a.compareTo(b));
    final sortedDays = days.map((e) {
      return _days[e.day - 1];
    }).toList();

    if (sortedDays.length == 1) {
      return " di ${sortedDays.first}";
    }

    return " di ${sortedDays.sublist(0, sortedDays.length - 1).join(", ")} e ${sortedDays.last}";
  }

  String _converterSetPos() {
    String article = "il ";
    String daytr = rrule.bySetPosMonth!.tr;
    if (rrule.byMonthDaysOccurrence == ByMonthDayOccurrence.sunday) {
      daytr = rrule.bySetPosMonth!.trFem;
      article = "la ";
    }
    if (rrule.bySetPosMonth == BySetPos.last) {
      article = "l'";
    }

    return " $article${daytr.toLowerCase()} ${rrule.byMonthDaysOccurrence!.tr.toLowerCase()}";
  }

  String _converterMonthly() {
    switch (rrule.monthlyRecurrenceType) {
      case MonthlyRecurrenceType.days:
        final monthDays = rrule.byMonthDays..sort((a, b) => a.compareTo(b));
        if (monthDays.length == 1) {
          return " il giorno ${monthDays.first}";
        }
        return " i giorni ${monthDays.sublist(0, monthDays.length - 1).join(", ")} e ${monthDays.last}";
      case MonthlyRecurrenceType.dayOfMonthOccurrence:
        return _converterSetPos();
    }
  }

  String _converterYearly() {
    final sortedMonths = rrule.byMonths..sort((a, b) => a.compareTo(b));
    final months = sortedMonths
        .map((e) =>
            DateFormat.MMMM("it_IT").format(DateTime.now().copyWith(month: e)))
        .toList();
    String setPos = "";
    if (rrule.hasBySetPositions) {
      setPos = _converterSetPos();
    }
    if (months.length == 1) {
      return " a ${months.first}$setPos";
    }
    return " a ${months.sublist(0, months.length - 1).join(", ")} e ${months.last}$setPos";
  }
}
