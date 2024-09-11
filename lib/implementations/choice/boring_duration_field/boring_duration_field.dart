import 'dart:async';

import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

part 'boring_duration_dialog_form.dart';
part 'boring_duration_field_dialog.dart';

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
      durationFieldTheme ?? BoringTheme.of(context).durationFieldTheme;

  @override
  Widget builder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    Duration? fieldValue,
    String? error,
  ) {
    final durationTheme = durationFieldThemeOf(context);

    final BoringDurationDataHandler? dataHandler = fieldValue != null
        ? BoringDurationDataHandler.fromDuration(fieldValue)
        : null;
    final textEditingController = TextEditingController(
        text: dataHandler?.readableString(durationTheme) ?? '');

    return TextField(
      readOnly: true,
      controller: textEditingController,
      decoration:
          getInputDecoration(formController, formStyle, error, fieldValue),
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
