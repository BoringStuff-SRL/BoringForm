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
  bool setInitialValue(String? val) {
    final v = super.setInitialValue(val);
    if (v) {
      textEditingController.text = val ?? "";
    }
    return v;
  }

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: TextField(
        readOnly: isReadOnly(context),
        enabled: !isReadOnly(context),
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
