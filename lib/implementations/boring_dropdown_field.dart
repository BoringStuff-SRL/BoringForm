import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

class BoringDropDownField<T> extends BoringField<T> {
  const BoringDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      required super.fieldController,
      super.decoration,
      super.boringResponsiveSize,
      super.onChanged});

  final List<DropdownMenuItem<T?>> items;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: DropdownButtonFormField(
        decoration: getDecoration(context),
        onChanged: ((value) {
          controller.value = value;
        }),
        value: controller.value,
        items: items,
      ),
    );
  }

  @override
  void onValueChanged(T? newValue) {}
}
