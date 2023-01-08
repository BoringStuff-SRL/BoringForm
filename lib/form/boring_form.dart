// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:boring_form/theme/boring_form_style.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

import 'package:boring_form/form/boring_form_controller.dart';
import 'package:provider/provider.dart';

class BoringForm extends BoringField<Map<String, dynamic>> {
  BoringForm(
      {super.key,
      required this.formController,
      super.onChanged,
      this.title,
      this.style,
      required this.fields})
      : assert(checkJsonKey(fields),
            "Conflict error: found duplicate jsonKeys in form"),
        super(fieldController: formController, jsonKey: "") {
    init();
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
  covariant BoringFormController formController;

  final BoringFormStyle? style;

  final List<BoringField> fields;
  final double fieldsPadding = 8.0;
  final double sectionPadding = 8.0;
  final String? title;
  final fieldsListProvider = FieldsListProvider();

  void updateControllerValue() {
    Map<String, dynamic> mappedValues = {};
    for (var field in fields) {
      mappedValues[field.jsonKey] = field.fieldController.value;
    }
    fieldController.setValueSilently(mappedValues);
    fieldsListProvider.fields = filterFields();
  }

  List<BoringField> filterFields() => fields
      .where((element) =>
          element.displayCondition?.call(formController.value ?? {}) ?? true)
      .toList();

  void onAnyChanged() {
    updateControllerValue();
    onChanged?.call(fieldController.value);
  }

  void addFieldsListeners() {
    for (var field in fields) {
      formController.subControllers[field.jsonKey] = field.fieldController;
      field.fieldController.addListener(onAnyChanged);
    }
  }

  void init() {
    addFieldsListeners();
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
          ChangeNotifierProvider(
              create: (context) => fieldsListProvider,
              child: Consumer<FieldsListProvider>(
                builder: (context, value, _) => Column(
                  children: value.fields,
                ),
              )),
          //...filteredFields(),
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
