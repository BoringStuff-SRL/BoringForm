// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/field_change_notification.dart';
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

  void _updateFilteredFieldsList() {
    fieldsListProvider.notifyIfDifferentFields(
        fields, formController.value ?? {});
  }

  void _onAnyChanged() {
    _updateFilteredFieldsList();
    onChanged?.call(formController.value);
    formController.sendNotification();
  }

  void _addFieldsSubcontrollers() {
    for (var field in fields) {
      //so formController.value get all values from fields controllers
      formController.subControllers[field.jsonKey] = field.fieldController;
    }
  }

  //TODO syncs all fields values with the one in the newValue
  //use this method to set a value Globally for the form
  // void _syncFieldsValue(Map<String, dynamic>? newValue) {
  //   for (var field in fields) {
  //     field.fieldController.value =
  //         (newValue != null && newValue.containsKey(field.jsonKey))
  //             ? newValue[field.jsonKey]
  //             : null;
  //   }
  // }

  void init() {
    _addFieldsSubcontrollers();
    _updateFilteredFieldsList();
  }

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
          NotificationListener<FieldChangeNotification>(
            onNotification: (notification) {
              _onAnyChanged();
              return true;
            },
            child: ChangeNotifierProvider(
                create: (context) => fieldsListProvider,
                child: Consumer<FieldsListProvider>(
                  builder: (context, value, _) {
                    return Column(
                      children: fields
                          .map((field) => Offstage(
                                offstage: !value.isFieldOnStage(field),
                                child: field,
                              ))
                          .toList(),
                    );
                  },
                )),
          ),
          //...filteredFields(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => formController,
        child: Consumer<BoringFormController>(
          builder: builder,
        ));
  }
}
