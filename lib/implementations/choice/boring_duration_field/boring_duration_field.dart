import 'dart:async';

import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/bform_controller.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

part 'boring_duration_dialog_form.dart';
part 'boring_duration_field_dialog.dart';

class BoringDurationField extends BFormField<Duration> {
  BoringDurationField({
    super.key,
    required super.fieldPath,
    super.decoration,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.validationFunction,
    this.durationFieldTheme,
    this.fieldsToShow,
  });

  final BDurationFieldTheme? durationFieldTheme;
  final List<DurationField>? fieldsToShow;

  BDurationFieldTheme durationFieldThemeOf(BuildContext context) =>
      durationFieldTheme ?? BoringTheme.of(context).durationFieldTheme;

  @override
  Widget fieldBuilder(
      BuildContext context,
      BoringFormStyle formStyle,
      BFormController formController,
      Duration? fieldValue,
      FieldValidation fieldValidation,
      void computedValue,
      bool readOnly) {
    final durationTheme = durationFieldThemeOf(context);

    final BoringDurationDataHandler? dataHandler = fieldValue != null
        ? BoringDurationDataHandler.fromDuration(fieldValue)
        : null;
    final textEditingController = TextEditingController(
        text: dataHandler?.readableString(durationTheme) ?? '');

    return TextField(
      readOnly: true,
      enabled: !readOnly,
      controller: textEditingController,
      decoration: getInputDecoration(
          formController, formStyle, fieldValue, fieldValidation),
      onTap: () {
        _BoringDurationFieldDialog(
          dataHandler: dataHandler,
          durationFieldTheme: durationTheme,
          onSet: (duration) {
            formController.setFieldValue(fieldPath, duration);
          },
          fieldsToShow: fieldsToShow,
        ).show(context);
      },
    );
  }
}

enum DurationField {
  timeFields,
  dateFields;
}
