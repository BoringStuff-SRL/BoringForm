import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:flutter/material.dart';

class BoringPickerField<T> extends BoringField<T> {
  BoringPickerField(
      {super.key,
      super.fieldController,
      super.onChanged,
      required super.jsonKey,
      required this.valueToString,
      required this.showPicker,
      super.boringResponsiveSize,
      super.displayCondition,
      this.updateValueOnDismiss = false,
      super.decoration});

  late final textEditingController = TextEditingController();

  final bool updateValueOnDismiss;

  final String Function(T? value) valueToString;

  final Future<T?> Function(BuildContext context) showPicker;

  @override
  void setInitalValue(val) {
    super.setInitalValue(val);
    textEditingController.text = valueToString(val);
  }

  Future _selectValue(BuildContext context) async {
    T? v = await showPicker(context);
    if (v != null || updateValueOnDismiss) {
      fieldController.value = v;
      textEditingController.text = valueToString(v);
    }
  }

  @override
  Widget builder(context, controller, child) {
    print("BUILD VAL: ${controller.value}");
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
