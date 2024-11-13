import 'package:boring_form/implementations/pickers/rrule_field/utils/enums.dart';
import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_ext.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:rrule/rrule.dart';

class BoringRRuleFormController extends BoringFormController {
  BoringRRuleFormController()
      : super(initialValue: {
          "interval": 1,
          "frequency": Frequency.weekly,
          "byDays": [ByWeekDayEntry(1)],
          "byYear": [DateTime.now().month],
          "end_type": RecurrenceEndType.never,
          "end_value": 1,
          "end_date": DateTime.now(),
          "monthlyRecurrenceType": MonthlyRecurrenceType.days,
          "byMonthDays": [DateTime.now().day],
          "monthlyRecurrence": {
            "bySetPos": BySetPos.first,
            "byMonthDaysOccurrence": ByMonthDayOccurrence.day,
          },
          "yearlyRecurrence": {
            "hasMonthOccurrence": false,
            "bySetPos": BySetPos.first,
            "byMonthDaysOccurrence": ByMonthDayOccurrence.day,
          },
        });

  BoringRRuleFormController.fromRRule(RecurrenceRule rrule)
      : super(initialValue: {
          "interval": rrule.interval,
          "frequency": rrule.frequency,
          "byDays": rrule.byWeekDays,
          "byYear": rrule.hasByMonths ? rrule.byMonths : [DateTime.now().month],
          "end_type": rrule.endType,
          "end_date": rrule.until,
          "end_value": rrule.count,
          "monthlyRecurrenceType": rrule.monthlyRecurrenceType,
          "byMonthDays":
              rrule.hasByMonthDays ? rrule.byMonthDays : [DateTime.now().day],
          "monthlyRecurrence": {
            "bySetPos": rrule.bySetPosMonth ?? BySetPos.first,
            "byMonthDaysOccurrence":
                rrule.byMonthDaysOccurrence ?? ByMonthDayOccurrence.day,
          },
          "yearlyRecurrence": {
            "hasMonthOccurrence": rrule.hasBySetPositions,
            "bySetPos": rrule.bySetPosMonth ?? BySetPos.first,
            "byMonthDaysOccurrence":
                rrule.byMonthDaysOccurrence ?? ByMonthDayOccurrence.day,
          },
        });

  RecurrenceRule get rrule {
    final frequency = value["frequency"] as Frequency;

    final interval = value["interval"] as int;

    final byWeekDays = value["byDays"] as List<ByWeekDayEntry>?;

    var rrule = RecurrenceRule(
      frequency: frequency,
      interval: interval,
    );

    if (frequency == Frequency.weekly) {
      rrule = rrule.copyWith(byWeekDays: byWeekDays ?? []);
    }

    if (frequency == Frequency.monthly) {
      final monthlyRecurrenceType =
          value["monthlyRecurrenceType"] as MonthlyRecurrenceType;

      switch (monthlyRecurrenceType) {
        case MonthlyRecurrenceType.days:
          rrule = rrule.copyWith(
            byMonthDays: value["byMonthDays"],
          );
          break;
        case MonthlyRecurrenceType.dayOfMonthOccurrence:
          rrule = rrule.copyWith(
            bySetPositions: [
              (value["monthlyRecurrence"]["bySetPos"] as BySetPos).value
            ],
            byWeekDays: (value["monthlyRecurrence"]["byMonthDaysOccurrence"]
                    as ByMonthDayOccurrence)
                .value
                .map((e) => ByWeekDayEntry(e))
                .toList(),
          );
          break;
      }
    }

    if (frequency == Frequency.yearly) {
      final byYear = value["byYear"] as List<int>;

      final hasMonthOccurrence =
          value["yearlyRecurrence"]?["hasMonthOccurrence"] as bool? ?? false;

      if (hasMonthOccurrence) {
        rrule = rrule.copyWith(
          byMonths: byYear,
          bySetPositions: [
            (value["yearlyRecurrence"]["bySetPos"] as BySetPos).value
          ],
          byWeekDays: (value["yearlyRecurrence"]["byMonthDaysOccurrence"]
                  as ByMonthDayOccurrence)
              .value
              .map((e) => ByWeekDayEntry(e))
              .toList(),
        );
      } else {
        rrule = rrule.copyWith(
          byMonths: byYear,
        );
      }
    }

    final endType = value["end_type"] as RecurrenceEndType;

    switch (endType) {
      case RecurrenceEndType.never:
        break;
      case RecurrenceEndType.date:
        rrule = rrule.copyWith(until: (value["end_date"] as DateTime).toUtc());
        break;
      case RecurrenceEndType.after:
        rrule = rrule.copyWith(count: value["end_value"] as int);
        break;
    }

    return rrule;
  }
}
