import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_ui/bui/theme/components_themes/form/boring_form_style.dart';
import 'package:flutter/material.dart';

class BoringDurationField extends BoringFormField<Duration> {
  const BoringDurationField({
    super.key,
    required super.fieldPath,
    super.decoration,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.validationFunction,
  });

  @override
  Widget builder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    Duration? fieldValue,
    String? error,
  ) {
    return TextField(
      readOnly: true,
      decoration: formStyle.inputDecoration.copyWith(),
    );
  }

  @override
  void onSelfChange(
      BoringFormController formController, Duration? fieldValue) {}
}
