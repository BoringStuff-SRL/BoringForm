import 'package:rrule/rrule.dart';

import '../boring_rrule_form.dart';

extension RecurrenceRuleExt on RecurrenceRule {
  MonthlyRecurrenceType get monthlyRecurrenceType {
    if (hasBySetPositions) {
      return MonthlyRecurrenceType.dayOfMonth;
    }

    return MonthlyRecurrenceType.days;
  }

  BySetPos? get bySetPosMonth {
    if (hasBySetPositions) {
      return BySetPos.fromValue(bySetPositions.first);
    }
    return null;
  }

  ByMonthDaysOccurrence? get byMonthDaysOccurrence {
    if (hasByWeekDays) {
      try {
        return ByMonthDaysOccurrence.fromList(
            byWeekDays.map((e) => e.day).toList());
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  EndType get endType {
    if (count != null) return EndType.after;
    if (until != null) return EndType.date;
    return EndType.never;
  }
}

extension FrequencyExt on Frequency {
  String trForm({bool singular = true}) {
    if (this == Frequency.daily) {
      return singular ? "giorno" : "giorni";
    }
    if (this == Frequency.weekly) {
      return singular ? "settimana" : "settimane";
    }
    if (this == Frequency.monthly) {
      return singular ? "mese" : "mesi";
    }
    if (this == Frequency.yearly) {
      return singular ? "anno" : "anni";
    }
    return "NOT_DEFINED";
  }
}

extension ByWeekDayEntryExt on ByWeekDayEntry {
  String get trForm {
    if (day == 1) {
      return "Lunedì";
    }
    if (day == 2) {
      return "Martedì";
    }
    if (day == 3) {
      return "Mercoledì";
    }
    if (day == 4) {
      return "Giovedì";
    }
    if (day == 5) {
      return "Venerdì";
    }
    if (day == 6) {
      return "Sabato";
    }
    if (day == 7) {
      return "Domenica";
    }

    return "NOT_DEFINED";
  }
}
