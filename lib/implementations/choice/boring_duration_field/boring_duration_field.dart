import 'dart:async';

import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

part 'boring_duration_data_handler.dart';
part 'boring_duration_dialog_form.dart';
part 'boring_duration_field_dialog.dart';

class BDurationFieldTheme {
  final String setString;

  final String Function(int value)? _yearsString;
  final String Function(int value)? _monthsString;
  final String Function(int value)? _daysString;
  final String Function(int value)? _hoursString;
  final String Function(int value)? _minutesString;

  String yearsString(int val) =>
      _yearsString?.call(val) ?? _defYearsString(val);

  String monthsString(int val) =>
      _monthsString?.call(val) ?? _defMonthsString(val);

  String daysString(int val) => _daysString?.call(val) ?? _defDaysString(val);

  String hoursString(int val) =>
      _hoursString?.call(val) ?? _defHoursString(val);

  String minutesString(int val) =>
      _minutesString?.call(val) ?? _defMinutesString(val);

  String _defYearsString(int value) => value == 1 ? "Anno" : "Anni";
  String _defMonthsString(int value) => value == 1 ? "Mese" : "Mesi";
  String _defDaysString(int value) => value == 1 ? "Giorno" : "Giorni";
  String _defHoursString(int value) => value == 1 ? "Ora" : "Ore";
  String _defMinutesString(int value) => value == 1 ? "Minuto" : "Minuti";

  final String insertDurationString;

  final String fieldRequiredString;

  const BDurationFieldTheme({
    this.fieldRequiredString = 'Campo richiesto',
    this.insertDurationString = 'Inserisci durata',
    this.setString = "Imposta",
    String Function(int)? daysString,
    String Function(int)? yearsString,
    String Function(int)? monthsString,
    String Function(int)? hoursString,
    String Function(int)? minutesString,
  })  : _minutesString = minutesString,
        _hoursString = hoursString,
        _daysString = daysString,
        _monthsString = monthsString,
        _yearsString = yearsString;
}

class BoringDurationField extends BoringFormField<Duration> {
  const BoringDurationField({
    super.key,
    required super.fieldPath,
    super.decoration,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.validationFunction,
    this.durationFieldTheme,
  });

  final BDurationFieldTheme? durationFieldTheme;

  BDurationFieldTheme durationFieldThemeOf(BuildContext context) =>
      durationFieldTheme ?? const BDurationFieldTheme();

  @override
  Widget builder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    Duration? fieldValue,
    String? error,
  ) {
    final durationTheme = durationFieldThemeOf(context);

    final _BoringDurationDataHandler? dataHandler = fieldValue != null
        ? _BoringDurationDataHandler.fromDuration(fieldValue)
        : null;
    final textEditingController = TextEditingController(
        text: dataHandler?.readableString(durationTheme) ?? '');

    return TextField(
      readOnly: true,
      controller: textEditingController,
      decoration: formStyle.inputDecoration,
      onTap: () {
        _BoringDurationFieldDialog(
          dataHandler: dataHandler,
          durationFieldTheme: durationTheme,
          onSet: (duration) {
            formController.setFieldValue(fieldPath, duration);
          },
        ).show(context);
      },
    );
  }

  @override
  void onSelfChange(
      BoringFormController formController, Duration? fieldValue) {}
}
