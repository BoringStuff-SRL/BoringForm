import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_ext.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

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

class BoringRRuleFormController extends BoringFormController {
  BoringRRuleFormController()
      : super(initialValue: {
          "interval": 1,
          "frequency": Frequency.weekly,
          "byDays": [ByWeekDayEntry(1)],
          "byMonth": DateTime.now().day,
          "byYear": DateTime.now(),
          "end_type": EndType.never,
          "end_value": 1,
          "end_date": DateTime.now(),
        });

  BoringRRuleFormController.fromRRule(RecurrenceRule rrule)
      : super(initialValue: {
          "interval": rrule.interval,
          "frequency": rrule.frequency,
          "byDays": rrule.byWeekDays,
          "byMonth": rrule.hasByMonthDays
              ? rrule.byMonthDays.first
              : DateTime.now().day,
          "byYear": rrule.hasByMonthDays && rrule.hasByMonths
              ? DateTime(
                  DateTime.now().year,
                  rrule.byMonths.first,
                  rrule.byMonthDays.first,
                )
              : DateTime.now(),
          "end_type": rrule.endType,
          "end_date": rrule.until,
          "end_value": rrule.count,
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
      rrule = rrule.copyWith(byMonthDays: [
        value["byMonth"],
      ]);
    }

    if (frequency == Frequency.yearly) {
      final byYear = value["byYear"] as DateTime;

      rrule =
          rrule.copyWith(byMonths: [byYear.month], byMonthDays: [byYear.day]);
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
                      formController.getValue(["interval"]) as int? ?? 1;
                  final singular = interval == 1;
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

  Widget _byDays(BuildContext context) => BColumn(
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

  Widget _byYear(BuildContext context) => BColumn(
        separator: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BText("Si ripete il"),
          BoringDateField(
            fieldPath: ["byYear"],
            dateToString: (date) =>
                date == null ? "" : DateFormat("d MMMM", "it_IT").format(date),
            decoration: (formController) => BoringFieldDecoration(
                hintText: "Seleziona data",
                prefixIcon: const BIcon(BIcons.calendar)),
            validationFunction: (formController, value) {
              if (value == null) return "Campo richiesto";
            },
            firstDate: DateTime(DateTime.now().year, DateTime.january),
            lastDate: DateTime(DateTime.now().year, DateTime.december, 31),
          )
        ],
      );

  Widget _byMonth(BuildContext context) => BColumn(
        separator: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BText("Il giorno del mese numero"),
          BoringNumberField(
            fieldPath: ["byMonth"],
            showIncrementDecrementButtons: true,
            decoration: (formController) =>
                BoringFieldDecoration(hintText: "Inserisci il giorno del mese"),
            validationFunction: (formController, value) {
              if (value == null) return "Campo richiesto";
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
                            label: "Seleziona data",
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

            if (frequency == Frequency.weekly) return _byDays(context);
            if (frequency == Frequency.monthly) return _byMonth(context);

            if (frequency == Frequency.yearly) return _byYear(context);

            return Container();
          },
        ),
        _end(context),
      ],
    );
  }
}
