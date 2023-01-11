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

  late final textEditingController = TextEditingController();

  @override
  void setInitalValue(String? val) {
    super.setInitalValue(val);
    textEditingController.text = val ?? "";
  }

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;
    //textEditingController.text = fieldController.value ?? '';
    print("HERE REB");
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: TextField(
        controller: textEditingController,
        decoration: getDecoration(context),
        onChanged: ((value) {
          controller.value = value;
        }),
      ),
    );
  }

  @override
  void onValueChanged(String? newValue) {}
}
