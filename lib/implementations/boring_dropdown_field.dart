import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class BoringDropDownField<T> extends BoringField<T> {
  BoringDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      required super.fieldController,
      super.boringResponsiveSize,
      super.onChanged});

  final List<DropdownMenuItem<T?>> items;

  @override
  Widget builder(context, controller, child) {
    return DropdownButtonFormField(
      decoration: InputDecoration(errorText: controller.errorMessage),
      onChanged: ((value) {
        controller.value = value;
      }),
      value: controller.value,
      items: items,
    );
  }

  @override
  void onValueChanged(T? newValue) {}
}
