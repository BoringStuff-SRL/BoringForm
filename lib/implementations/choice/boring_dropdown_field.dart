import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BoringDropDownField<T> extends BoringField<T> {
  BoringDropDownField(
      {super.key,
      required super.jsonKey,
      required this.items,
      this.radius = 0,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final List<DropdownMenuItem<T?>> items;
  final double radius;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final newStyle = getDecoration(context)
        .copyWith(contentPadding: const EdgeInsets.all(0));

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: DropdownButtonFormField2<T?>(
        dropdownOverButton: false,
        dropdownElevation: 0,
        decoration: newStyle,
        buttonHeight: 50,
        itemHeight: 50,
        dropdownMaxHeight: 250,
        items: items,
        value: controller.value,
        hint: Text(decoration?.hintText ?? ''),
        dropdownDecoration: _boxDecoration(newStyle),
        onChanged: isReadOnly(context)
            ? null
            : ((value) {
                controller.value = value;
              }),
      ),
    );
  }

  _boxDecoration(newStyle) => BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: newStyle.fillColor,
      border: Border.all(
          color: newStyle.border?.borderSide.color,
          width: newStyle.border?.borderSide.width));

  @override
  void onValueChanged(T? newValue) {}
}
