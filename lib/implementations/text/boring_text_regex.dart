import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/form/boring_form_controller_OLD.dart';
import 'package:boring_form/implementations/text/boring_text_field.dart';
import 'package:flutter/services.dart';

class RegexInputFormatter extends TextInputFormatter {
  final RegExp regex;

  RegexInputFormatter({required this.regex});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (regex.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class BoringTextRegExpField extends BoringTextField {
  BoringTextRegExpField({
    super.key,
    super.minLines = 1,
    super.maxLines = 1,
    super.required,
    super.responsiveSize,
    required super.fieldPath,
    super.observedFields,
    String errorMessage = "Value cannot be empty",
    super.decoration,
    super.onChanged,
    super.readOnly,
    ValidationFunction<String>? validationFunction,
    //
    required RegExp regExp,
    required String regExpError,
    bool mustMatch = false,
  }) : super(
            inputFormatter:
                mustMatch ? [RegexInputFormatter(regex: regExp)] : null,
            validationFunction: validationFunction == null && !required
                ? null
                : (BoringFormController formController, String? value) {
                    final error =
                        validationFunction?.call(formController, value);
                    if (error != null) {
                      return error;
                    }
                    if (!regExp.hasMatch(value ?? '')) {
                      if (!required && (value ?? '').isEmpty) {
                        return null;
                      }
                      return regExpError;
                    }
                    return null;
                  });
}
