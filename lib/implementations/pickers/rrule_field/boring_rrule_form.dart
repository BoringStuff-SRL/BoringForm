import 'package:boring_form/implementations/pickers/rrule_field/utils/enums.dart';
import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_ext.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

import 'boring_rrule_form_controller.dart';

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
              fieldPath: const ["interval"],
              showIncrementDecrementButtons: true,
              validationFunction: (formController, value) {
                if (value == null) return "Campo richiesto";
                if (value < 1) return "Valore minimo 1";
                return null;
              },
            ),
          ),
          Expanded(
            child: BFormObserverWidget(
                observedFields: const [
                  ["interval"]
                ],
                builder: (context, fc, map) {
                  final interval =
                      formController.getValue(["interval"]) as num? ?? 1;
                  final singular = interval == 1.0;
                  return BoringDropdownField(
                    key: UniqueKey(),
                    fieldPath: const ["frequency"],
                    clearable: false,
                    getItems: (search) async {
                      final result = [
                        Frequency.daily,
                        Frequency.weekly,
                        Frequency.monthly,
                        Frequency.yearly,
                      ];

                      return result;
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
            fieldPath: const ["byDays"],
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
          BoringDropdownField<MonthlyRecurrenceType, MonthlyRecurrenceType>(
            fieldPath: const ["monthlyRecurrenceType"],
            getItems: (search) async {
              return MonthlyRecurrenceType.values.toList();
            },
            clearable: false,
            decoration: (formController) =>
                BoringFieldDecoration(label: "Tipo di ricorrenza mensile"),
            toBoringChoiceItem: (e) => BChoiceItem(value: e, display: e.tr),
          ),
          BFormObserverWidget(
            observedFields: const [
              ["monthlyRecurrenceType"]
            ],
            builder: (context, formController, map) {
              final monthlyRecurrenceType =
                  formController.getValue(["monthlyRecurrenceType"])
                      as MonthlyRecurrenceType?;
              return switch (monthlyRecurrenceType) {
                null => Container(),
                MonthlyRecurrenceType.days => BoringChipField(
                    fieldPath: const ["byMonthDays"],
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
                MonthlyRecurrenceType.dayOfMonthOccurrence =>
                  _setPos(context, "month")
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
            fieldPath: const ["byYear"],
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
            fieldPath: const ["yearlyRecurrence", "hasMonthOccurrence"],
            decoration: (formController) =>
                BoringFieldDecoration(label: "Ogni:"),
          ),
          BFormObserverWidget(
            observedFields: const [
              ["yearlyRecurrence", "hasMonthOccurrence"]
            ],
            builder: (context, formController, map) {
              final hasMonthOccurrence = formController
                      .getValue(["yearlyRecurrence", "hasMonthOccurrence"]) ??
                  false;

              return Opacity(
                  opacity: hasMonthOccurrence ? 1 : .5,
                  child: _setPos(context, "yearlyRecurrence",
                      readOnly: !hasMonthOccurrence));
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
                  fieldPath: const ["end_type"],
                  getItems: (search) async {
                    return RecurrenceEndType.values;
                  },
                  toBoringChoiceItem: (e) =>
                      BChoiceItem(value: e, display: e.tr),
                  clearable: false,
                ),
              ),
              Expanded(
                child: BFormObserverWidget(
                  observedFields: const [
                    ["end_type"]
                  ],
                  builder: (BuildContext context,
                      BFormController formController, map) {
                    final endType = formController.getValue(["end_type"])
                        as RecurrenceEndType?;

                    return switch (endType) {
                      RecurrenceEndType.never => Container(),
                      RecurrenceEndType.date => BoringDateField(
                          fieldPath: const ["end_date"],
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                          decoration: (formController) => BoringFieldDecoration(
                            hintText: "Seleziona data",
                            prefixIcon: const BIcon(BIcons.calendar),
                          ),
                        ),
                      RecurrenceEndType.after => BoringNumberField(
                          fieldPath: const ["end_value"],
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
            child: BoringDropdownField<BySetPos, BySetPos>(
              readOnly: readOnly,
              fieldPath: [path, "bySetPos"],
              getItems: (search) async {
                return BySetPos.values.toList();
              },
              clearable: false,
              decoration: (formController) =>
                  BoringFieldDecoration(label: "Ogni"),
              toBoringChoiceItem: (e) => BChoiceItem(value: e, display: e.tr),
            ),
          ),
          Expanded(
            child:
                BoringDropdownField<ByMonthDayOccurrence, ByMonthDayOccurrence>(
              readOnly: readOnly,
              fieldPath: [path, "byMonthDaysOccurrence"],
              getItems: (search) async {
                return ByMonthDayOccurrence.values;
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
        BFormObserverWidget(
          observedFields: const [
            ["frequency"]
          ],
          builder: (context, formController, map) {
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
