import 'package:boring_form/boring_form.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:flutter/material.dart';

class BoringTextField extends BoringField<String> {
  BoringTextField(
      {super.key,
      super.fieldController,
      super.onChanged,
      required super.jsonKey,
      super.displayCondition,
      super.boringResponsiveSize,
      super.decoration});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;
    textEditingController.text = fieldController.value ?? '';
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: TextField(
        controller: textEditingController,
        decoration: getDecoration(context), // InputDecoration(
        // ),
        onChanged: ((value) {
          controller.value = value;
        }),
      ),
    );
  }

  @override
  void onValueChanged(String? newValue) {
    if (newValue != textEditingController.text) {
      textEditingController.text = newValue ?? '';
    }
  }
}
