// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:boring_form/theme/boring_form_style.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

import 'package:boring_form/form/boring_form_controller.dart';
import 'package:provider/provider.dart';

class BoringForm extends StatelessWidget {
  BoringForm(
      {super.key,
      required this.formController,
      this.onChanged,
      this.title,
      this.style,
      required this.fields})
      : assert(checkJsonKey(fields),
            "Conflict error: found duplicate jsonKeys in form") {
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

  final void Function(Map<String, dynamic>?)? onChanged;
  final BoringFormController formController;
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
    formController.setValueSilently(mappedValues);
    fieldsListProvider.fields = filterFields(fields, formController.value);
  }

  static List<BoringField> filterFields(
          List<BoringField> fields, Map<String, dynamic>? checkValue) =>
      fields
          .where((element) =>
              element.displayCondition?.call(checkValue ?? {}) ?? true)
          .toList();

  void onAnyChanged() {
    updateControllerValue();
    onChanged?.call(formController.value);
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

  void _onChangedValue() {
    onChanged?.call(formController.value);
    onValueChanged(formController.value);
  }

  @override
  Widget build(BuildContext context) {
    formController.addListener(_onChangedValue);
    onValueChanged(formController.value);

    return ChangeNotifierProvider(
        create: (context) => formController,
        child: Consumer<BoringFormController>(
          builder: builder,
        ));
  }

  void onValueChanged(Map<String, dynamic>? newValue) {
    for (var field in fields) {
      field.fieldController.value =
          (newValue != null && newValue.containsKey(field.jsonKey))
              ? newValue[field.jsonKey]
              : null;
    }
  }
}
