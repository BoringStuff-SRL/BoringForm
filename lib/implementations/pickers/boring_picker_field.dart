import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:flutter/material.dart';

class BoringPickerField<T> extends BoringField<T> {
  BoringPickerField(
      {super.key,
      required super.fieldController,
      super.onChanged,
      required super.jsonKey,
      required this.valueToString,
      required this.showPicker,
      super.boringResponsiveSize,
      this.updateValueOnDismiss = false,
      super.decoration});

  late final TextEditingController textEditingController =
      TextEditingController(text: valueToString(fieldController.initialValue));

  final bool updateValueOnDismiss;

  final String Function(T? value) valueToString;

  final Future<T?> Function(BuildContext context) showPicker;

  Future _selectValue(BuildContext context) async {
    T? v = await showPicker(context);
    fieldController.value = v;
    if (v != null || updateValueOnDismiss) {
      textEditingController.text = valueToString(v);
    }
  }

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: InkWell(
        child: TextField(
          controller: textEditingController,
          readOnly: true,
          onTap: () => _selectValue(context),
          decoration: getDecoration(context),
        ),
      ),
    );
  }

  @override
  void onValueChanged(T? newValue) {}
}
