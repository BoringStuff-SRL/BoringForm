// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_style.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

import 'package:boring_form/form/boring_form_controller.dart';

class BoringForm extends BoringField<Map<String, dynamic>> {
  BoringForm(
      {super.key,
      required this.fieldController,
      super.onChanged,
      this.title,
      this.style,
      required this.fields})
      : assert(checkJsonKey(fields),
            "Confict error: found duplicate jsonKeys in form"),
        super(fieldController: fieldController, jsonKey: "") {
    addFieldsListeners();
  }

  static bool checkJsonKey(List<BoringField> fields) {
    List<String> keys = [];
    for (var field in fields) {
      if (keys.contains(field.jsonKey)) {
        return false;
      }
      keys.add(field.jsonKey);
    }
    return true;
  }

  @override
  covariant BoringFormController fieldController;

  final BoringFormStyle? style;

  final List<BoringField> fields;
  final double fieldsPadding = 8.0;
  final double sectionPadding = 8.0;
  final String? title;

  void updateControllerValue() {
    Map<String, dynamic> mappedValues = {};
    for (var field in fields) {
      mappedValues[field.jsonKey] = field.fieldController.value;
    }
    fieldController.setValueSilently(mappedValues);
    onChanged?.call(mappedValues);
  }

  void onAnyChanged() {
    updateControllerValue();
  }

  void addFieldsListeners() {
    for (var field in fields) {
      fieldController.subControllers[field.jsonKey] = field.fieldController;
      field.fieldController.addListener(onAnyChanged);
    }
  }

  @override
  Widget builder(context, controller, child) {
    return BoringFormTheme(
      style: style ?? BoringFormStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Text(
              title!,
              style: style?.formTitleStyle,
            ),
          ...fields,
        ],
      ),
    );
  }

  @override
  void onValueChanged(Map<String, dynamic>? newValue) {
    for (var field in fields) {
      field.fieldController.value =
          (newValue != null && newValue.containsKey(field.jsonKey))
              ? newValue[field.jsonKey]
              : null;
    }
  }
}
