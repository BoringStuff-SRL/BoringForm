// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringPickerField<T> extends BoringFormField<T> {
  final _textEditingController = TextEditingController();
  final bool updateValueOnDismiss;
  final String Function(T? value) valueToString;
  final bool showEraseValueButton;

  final Future<T?> Function(BuildContext context,
      BoringFormController formController, T? fieldValue) showPicker;

  BoringPickerField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.readOnly,
    super.validationFunction,
    required this.valueToString,
    required this.showPicker,
    this.updateValueOnDismiss = false,
    this.showEraseValueButton = false,
    super.onChanged,
  });

  @override
  Widget builder(BuildContext context, BoringFormStyle formTheme,
      BoringFormController formController, T? fieldValue, String? error) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: !isReadOnly(formTheme),
            readOnly: true,
            controller: _textEditingController,
            textAlign: formTheme.textAlign,
            style: formTheme.textStyle,
            decoration: getInputDecoration(
                formController, formTheme, error, fieldValue),
            onTap: () async {
              if (isReadOnly(formTheme)) {
                return;
              }

              T? value = await showPicker(context, formController, fieldValue);
              if (value != null || updateValueOnDismiss) {
                setChangedValue(formController, value);
                _textEditingController.text = valueToString(value);
              }
            },
          ),
        ),
        if (showEraseValueButton && fieldValue != null) ...[
          const SizedBox(width: 5),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setChangedValue(formController, null);
                _textEditingController.text = "";
              },
              child: formTheme.eraseValueWidget,
            ),
          ),
        ]
      ],
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {
    _textEditingController.text = valueToString(fieldValue);
  }

  // void onValueChanged(T? newValue) {}

  // @override
  // BoringPickerField<T> copyWith(
  //     {BoringFieldController<T>? fieldController,
  //     void Function(T? value)? onChanged,
  //     BoringFieldDecoration? decoration,
  //     BoringResponsiveSize? boringResponsiveSize,
  //     String? jsonKey,
  //     bool Function(Map<String, dynamic> p1)? displayCondition,
  //     String Function(T?)? valueToString,
  //     Future<T> Function(BuildContext)? showPicker,
  //     bool? updateValueOnDismiss}) {
  //   return BoringPickerField(
  //     fieldController: fieldController ?? this.fieldController,
  //     onChanged: onChanged ?? this.onChanged,
  //     decoration: decoration ?? this.decoration,
  //     boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
  //     jsonKey: jsonKey ?? this.jsonKey,
  //     displayCondition: displayCondition ?? this.displayCondition,
  //     valueToString: valueToString ?? this.valueToString,
  //     showPicker: showPicker ?? this.showPicker,
  //     updateValueOnDismiss: updateValueOnDismiss ?? this.updateValueOnDismiss,
  //   );
  // }
}
