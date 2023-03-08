// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
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
  bool setInitialValue(initialValue) {
    super.setInitialValue(initialValue);
    textEditingController.text = valueToString(fieldController.value);
    return true;
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
    final style = getStyle(context);
    final readOnly = isReadOnly(context);
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: InkWell(
        child: TextField(
          enabled: !readOnly,
          controller: textEditingController,
          readOnly: true,
          onTap: () => readOnly ? null : _selectValue(context),
          decoration: getDecoration(context),
        ),
      ),
    );
  }

  void onValueChanged(T? newValue) {}

  @override
  BoringPickerField copyWith(
      {BoringFieldController<T>? fieldController,
      void Function(T? value)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      String Function(dynamic)? valueToString,
      Future<dynamic> Function(BuildContext)? showPicker,
      bool? updateValueOnDismiss}) {
    return BoringPickerField(
      fieldController: fieldController ?? this.fieldController,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)?),
      decoration: decoration ?? this.decoration,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      displayCondition: displayCondition ?? this.displayCondition,
      valueToString: valueToString ??
          (this.valueToString as String Function(dynamic)),
      showPicker: showPicker ?? this.showPicker,
      updateValueOnDismiss: updateValueOnDismiss ?? this.updateValueOnDismiss,
    );
  }
}
