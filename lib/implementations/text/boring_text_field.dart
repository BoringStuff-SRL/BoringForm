// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/bform_controller.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoringTextField extends BFormField<String, void> {
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
    BFormController formController,
    String? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
    bool readOnly,
  ) {
    return TextField(
      focusNode: _focusNode,
      readOnly: readOnly,
      enabled: !readOnly,
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

  @override
  Widget onError(BuildContext context) => throw UnimplementedError();

  @override
  Widget onLoading(BuildContext context) => throw UnimplementedError();
}
