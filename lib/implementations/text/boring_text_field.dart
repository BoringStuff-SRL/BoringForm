// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoringTextField extends BFormField<String> {
  final TextEditingController textEditingController;
  final FocusNode focusNode;

  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatter;

  BoringTextField(
      {super.key,
      this.minLines = 1,
      this.maxLines = 1,
      super.required,
      super.responsiveSize,
      this.inputFormatter,
      required super.fieldPath,
      super.observedFields,
      super.validationFunction,
      String errorMessage = "Value cannot be empty",
      super.decoration,
      super.onChanged,
      super.readOnly,
      TextEditingController? textEditingController,
      FocusNode? focusNode
      // super.forceHideRequiredFieldLabel,
      })
      : focusNode = focusNode ?? FocusNode(),
        textEditingController =
            textEditingController ?? TextEditingController();

  bool get obscuredText => false;

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    String? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    return TextField(
      focusNode: focusNode,
      readOnly: fieldValidation.isReadOnly,
      enabled: !fieldValidation.isReadOnly,
      controller: textEditingController,
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
  void onSelfChange(BFormController formController, String? fieldValue) {
    var cursorPos = textEditingController.selection.base.offset;
    textEditingController.text = (fieldValue ?? "");
    if (fieldValue != null) {
      textEditingController.selection =
          TextSelection.collapsed(offset: min(cursorPos, fieldValue.length));
    }
  }
}
