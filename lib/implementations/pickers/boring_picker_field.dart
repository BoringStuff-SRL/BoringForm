// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringPickerField<T> extends BFormField<T> {
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
    super.required,
  });

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    T? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            enabled: fieldValidation.isReadOnly,
            readOnly: true,
            controller: _textEditingController,
            textAlign: formStyle.textAlign,
            style: formStyle.textStyle,
            decoration: getInputDecoration(
                formController, formStyle, fieldValue, fieldValidation),
            onTap: () async {
              if (fieldValidation.isReadOnly) {
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
              child: formStyle.eraseValueWidget,
            ),
          ),
        ]
      ],
    );
  }

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {
    _textEditingController.text = valueToString(fieldValue);
  }
}
