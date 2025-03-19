// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoringTextField extends BFormField<String> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatter;

  BoringTextField({
    super.key,
    this.minLines = 1,
    this.maxLines = 1,
    super.required,
    this.inputFormatter,
    required super.fieldPath,
    super.observedFields,
    ValidationFunction<String>? validationFunction,
    String errorMessage = "Value cannot be empty",
    super.decoration,
    super.onChanged,
    super.readOnly,
    // super.forceHideRequiredFieldLabel,
  });

  bool get obscuredText => false;

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    String? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    _textEditingController.text = fieldValue ?? "";
    return TextField(
      focusNode: _focusNode,
      readOnly: fieldValidation.isReadOnly,
      enabled: !fieldValidation.isReadOnly,
      controller: _textEditingController,
      inputFormatters: inputFormatter,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: formStyle.textAlign,
      style: formStyle.textStyle,
      obscureText: obscuredText,
      decoration: getInputDecoration(
          formController, formStyle, fieldValue, fieldValidation),
      onChanged: (value) {
        setChangedValue(formController, value);
      },
    );
  }
}
