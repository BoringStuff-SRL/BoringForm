import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_ext.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

enum ByMonthDaysOccurrence {
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

  const ByMonthDaysOccurrence(this.value);

  final List<int> value;

  String get tr => switch (this) {
        ByMonthDaysOccurrence.monday => "Lunedì",
        ByMonthDaysOccurrence.tuesday => "Martedì",
        ByMonthDaysOccurrence.wednesday => "Mercoledì",
        ByMonthDaysOccurrence.thursday => "Giovedì",
        ByMonthDaysOccurrence.friday => "Venerdì",
        ByMonthDaysOccurrence.saturday => "Sabato",
        ByMonthDaysOccurrence.sunday => "Domenica",
        ByMonthDaysOccurrence.day => "Giorno",
        ByMonthDaysOccurrence.weekday => "Giorno feriale",
        ByMonthDaysOccurrence.weekendDay => "Giorno festivo",
      };

  factory ByMonthDaysOccurrence.fromList(List<int> list) {
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

enum EndType {
  never,
  date,
  after;

  String get tr => switch (this) {
        EndType.never => "Mai",
        EndType.date => "Data",
        EndType.after => "Dopo",
      };
}

enum MonthlyRecurrenceType {
  days,
  dayOfMonth;

  String get tr => switch (this) {
        MonthlyRecurrenceType.days => "Giorni nel mese",
        MonthlyRecurrenceType.dayOfMonth => "Ricorrenza nel mese",
      };
}

class BoringRRuleFormController extends BoringFormController {
  BoringRRuleFormController()
      : super(initialValue: {
          "interval": 1,
          "frequency": Frequency.weekly,
          "byDays": [ByWeekDayEntry(1)],
          "byYear": [DateTime.now().month],
          "end_type": EndType.never,
          "end_value": 1,
          "end_date": DateTime.now(),
          "monthlyRecurrenceType": MonthlyRecurrenceType.days,
          "byMonthDays": [DateTime.now().day],
          "monthlyRecurrence": {
            "bySetPosMonth": BySetPos.first,
            "byMonthDaysOccurrence": ByMonthDaysOccurrence.day,
          },
          "year": {
            "hasMonthOccurrence": false,
            "bySetPosMonth": BySetPos.first,
            "byMonthDaysOccurrence": ByMonthDaysOccurrence.day,
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
          "byMonthDays":
              rrule.hasByMonthDays ? rrule.byMonthDays : [DateTime.now().day],
          "monthlyRecurrenceType": rrule.monthlyRecurrenceType,
          "monthlyRecurrence": {
            "bySetPosMonth": rrule.bySetPosMonth ?? BySetPos.first,
            "byMonthDaysOccurrence":
                rrule.byMonthDaysOccurrence ?? ByMonthDaysOccurrence.day,
          },
          "year": {
            "hasMonthOccurrence": rrule.hasBySetPositions,
            "bySetPosMonth": rrule.bySetPosMonth ?? BySetPos.first,
            "byMonthDaysOccurrence":
                rrule.byMonthDaysOccurrence ?? ByMonthDaysOccurrence.day,
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
        case MonthlyRecurrenceType.dayOfMonth:
          rrule = rrule.copyWith(
            bySetPositions: [
              (value["monthlyRecurrence"]["bySetPosMonth"] as BySetPos).value
            ],
            byWeekDays: (value["monthlyRecurrence"]["byMonthDaysOccurrence"]
                    as ByMonthDaysOccurrence)
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
          value["year"]?["hasMonthOccurrence"] as bool? ?? false;

      if (hasMonthOccurrence) {
        rrule = rrule.copyWith(
          byMonths: byYear,
          bySetPositions: [(value["year"]["bySetPosMonth"] as BySetPos).value],
          byWeekDays:
              (value["year"]["byMonthDaysOccurrence"] as ByMonthDaysOccurrence)
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

    final endType = value["end_type"] as EndType;

    switch (endType) {
      case EndType.never:
        break;
      case EndType.date:
        rrule = rrule.copyWith(until: (value["end_date"] as DateTime).toUtc());
        break;
      case EndType.after:
        rrule = rrule.copyWith(count: value["end_value"] as int);
        break;
    }

    return rrule;
  }
}

class BoringRRuleForm extends BoringFormWidget {
  BoringRRuleForm({
    super.key,
    required BoringRRuleFormController super.formController,
  });

  @override
  BoringFormStyle styleManipulator(BoringFormStyle style) {
    return style.copyWith(fieldsPadding: EdgeInsets.zero);
  }

  final spacing = const SizedBox(
    height: 15,
    width: 15,
  );

  Widget _frequencyWidget(BuildContext context) => BRow(
        children: [
          const BText("Ripeti ogni"),
          SizedBox(
            width: 80,
            child: BoringNumberField(
              fieldPath: ["interval"],
              showIncrementDecrementButtons: true,
              validationFunction: (formController, value) {
                if (value == null) return "Campo richiesto";
                if (value < 1) return "Valore minimo 1";
              },
            ),
          ),
          Expanded(
            child: BoringFormChildWidget(
                observedFields: [
                  ["interval"]
                ],
                builder: (context, fc) {
                  final interval =
                      formController.getValue(["interval"]) as num? ?? 1;
                  final singular = interval == 1.0;
                  return BoringDropdownField(
                    key: UniqueKey(),
                    fieldPath: ["frequency"],
                    clearable: false,
                    getItems: (search) async {
                      final result = [
                        Frequency.daily,
                        Frequency.weekly,
                        Frequency.monthly,
                        Frequency.yearly,
                      ];

                      return result
                          .map((e) => BChoiceItem(
                              value: e, display: e.trForm(singular: singular)))
                          .toList();
                    },
                    toBoringChoiceItem: (e) => BChoiceItem(
                        value: e, display: e.trForm(singular: singular)),
                  );
                }),
          ),
        ],
      );

  Widget _weeklyRecurrence(BuildContext context) => BColumn(
        separator: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BText("Si ripete il"),
          BoringChipField(
            fieldPath: ["byDays"],
            elements: [
              DateTime.monday,
              DateTime.tuesday,
              DateTime.wednesday,
              DateTime.thursday,
              DateTime.friday,
              DateTime.saturday,
              DateTime.sunday
            ].map((e) => ByWeekDayEntry(e)).toList(),
            canRemoveSelection: (formController, element) {
              final value = formController.getValue(["byDays"])
                      as List<ByWeekDayEntry>? ??
                  [];

              return value.length > 1;
            },
            toLabel: (element) {
              return Text(element.trForm[0]);
            },
            toTooltip: (element) {
              return element.trForm;
            },
          ),
        ],
      );

  Widget _monthlyRecurrence(BuildContext context) => BColumn(
        separator: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoringDropdownField(
            fieldPath: ["monthlyRecurrenceType"],
            getItems: (search) async {
              return MonthlyRecurrenceType.values
                  .map((e) => BChoiceItem(value: e, display: e.tr))
                  .toList();
            },
            clearable: false,
            decoration: (formController) =>
                BoringFieldDecoration(label: "Tipo di ricorrenza mensile"),
            toBoringChoiceItem: (e) => BChoiceItem(value: e, display: e.tr),
          ),
          BoringFormChildWidget(
            observedFields: [
              ["monthlyRecurrenceType"]
            ],
            builder: (context, formController) {
              final monthlyRecurrenceType =
                  formController.getValue(["monthlyRecurrenceType"])
                      as MonthlyRecurrenceType?;
              return switch (monthlyRecurrenceType) {
                null => Container(),
                MonthlyRecurrenceType.days => BoringChipField(
                    fieldPath: ["byMonthDays"],
                    elements: List.generate(31, (index) => index + 1),
                    canRemoveSelection: (formController, element) {
                      final value = formController.getValue(["byMonthDays"])
                              as List<int>? ??
                          [];

                      return value.length > 1;
                    },
                    toLabel: (element) {
                      return SizedBox(
                        width: 20,
                        child: Center(
                          child: Text(
                            "$element",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                MonthlyRecurrenceType.dayOfMonth =>
                  _setPos(context, "monthlyRecurrence")
              };
            },
          ),
        ],
      );

  Widget _yearlyRecurrence(BuildContext context) => BColumn(
        separator: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BText("Si ripete il"),
          BoringChipField(
            fieldPath: ["byYear"],
            elements: List.generate(12, (index) => index + 1),
            canRemoveSelection: (formController, element) {
              final value =
                  formController.getValue(["byYear"]) as List<int>? ?? [];

              return value.length > 1;
            },
            toTooltip: (element) {
              final date = DateTime.now().copyWith(month: element);
              return DateFormat("MMMM", "it_IT").format(date);
            },
            toLabel: (element) {
              final date = DateTime.now().copyWith(month: element);
              return SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    DateFormat("MMMM", "it_IT")
                        .format(date)
                        .substring(0, 3)
                        .toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
          BoringCheckBoxField(
            fieldPath: ["year", "hasMonthOccurrence"],
            decoration: (formController) =>
                BoringFieldDecoration(label: "Ogni:"),
          ),
          BoringFormChildWidget(
            observedFields: [
              ["year", "hasMonthOccurrence"]
            ],
            builder: (context, formController) {
              final hasMonthOccurrence =
                  formController.getValue(["year", "hasMonthOccurrence"]) ??
                      false;

              return Opacity(
                  opacity: hasMonthOccurrence ? 1 : .5,
                  child:
                      _setPos(context, "year", readOnly: !hasMonthOccurrence));
            },
          ),
        ],
      );

  Widget _end(BuildContext context) => BColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        separator: spacing,
        children: [
          const BText("Fine"),
          BRow(
            separator: spacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BoringDropdownField(
                  fieldPath: ["end_type"],
                  getItems: (search) async {
                    return EndType.values
                        .map((e) => BChoiceItem(value: e, display: e.tr))
                        .toList();
                  },
                  toBoringChoiceItem: (e) =>
                      BChoiceItem(value: e, display: e.tr),
                  clearable: false,
                ),
              ),
              Expanded(
                child: BoringFormChildWidget(
                  observedFields: [
                    ["end_type"]
                  ],
                  builder: (
                    BuildContext context,
                    BoringFormController formController,
                  ) {
                    final endType =
                        formController.getValue(["end_type"]) as EndType?;

                    return switch (endType) {
                      EndType.never => Container(),
                      EndType.date => BoringDateField(
                          fieldPath: ["end_date"],
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                          decoration: (formController) => BoringFieldDecoration(
                            hintText: "Seleziona data",
                            prefixIcon: const BIcon(BIcons.calendar),
                          ),
                        ),
                      EndType.after => BoringNumberField(
                          fieldPath: ["end_value"],
                          showIncrementDecrementButtons: true,
                          decoration: (formController) {
                            final value =
                                formController.getValue(["end_value"]) as int?;
                            return BoringFieldDecoration(
                              suffixText:
                                  value == 1 ? "occorrenza" : "occorrenze",
                            );
                          },
                        ),
                      null => Container(),
                    };
                  },
                ),
              ),
            ],
          ),
        ],
      );

  Widget _setPos(BuildContext context, String path, {bool readOnly = false}) =>
      BRow(
        children: [
          Expanded(
            child: BoringDropdownField(
              readOnly: readOnly,
              fieldPath: [path, "bySetPosMonth"],
              getItems: (search) async {
                return BySetPos.values
                    .map(
                      (e) => BChoiceItem(value: e, display: e.tr),
                    )
                    .toList();
              },
              clearable: false,
              decoration: (formController) =>
                  BoringFieldDecoration(label: "Ogni"),
              toBoringChoiceItem: (e) => BChoiceItem(value: e, display: e.tr),
            ),
          ),
          Expanded(
            child: BoringDropdownField(
              readOnly: readOnly,
              fieldPath: [path, "byMonthDaysOccurrence"],
              getItems: (search) async {
                return ByMonthDaysOccurrence.values
                    .map(
                      (e) => BChoiceItem(value: e, display: e.tr),
                    )
                    .toList();
              },
              clearable: false,
              toBoringChoiceItem: (e) => BChoiceItem(value: e, display: e.tr),
            ),
          ),
        ],
      );

  @override
  Widget child(BuildContext context) {
    return BColumn(
      separator: const SizedBox(height: 20),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _frequencyWidget(context),
        BoringFormChildWidget(
          observedFields: [
            ["frequency"]
          ],
          builder: (context, formController) {
            final frequency =
                formController.getValue(["frequency"]) as Frequency?;

            if (frequency == Frequency.weekly) {
              return _weeklyRecurrence(context);
            }
            if (frequency == Frequency.monthly) {
              return _monthlyRecurrence(context);
            }

            if (frequency == Frequency.yearly) {
              return _yearlyRecurrence(context);
            }

            return Container();
          },
        ),
        _end(context),
      ],
    );
  }
}
