// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
// import 'package:boring_form/field/boring_field.dart';
// import 'package:boring_form/field/boring_field_controller.dart';
// import 'package:boring_form/theme/boring_field_decoration.dart';
// import 'package:boring_form/theme/boring_form_theme.dart';
// import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BoringNumberField extends BoringFormField<num> {
  final _focusNode = FocusNode();
  BoringNumberField({
    super.key,
    // super.fieldController,
    // super.onChanged,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    // super.boringResponsiveSize,
    // super.decoration,
    this.decimalSeparator = defaultDecimalSeparator,
    this.thousandsSeparator = defaultThousandsSeparator,
    this.decimalPlaces = 0,
    this.fieldFormatter,
    // bool? readOnly,
    // this.onlyIntegers = false,
    // super.displayCondition,
  })  : assert(decimalSeparator != thousandsSeparator,
            'Decimal and thousands separator can\'t be the same'),
        assert(
            (['.', ','].contains(decimalSeparator)) &&
                (['.', ','].contains(thousandsSeparator)),
            'Invalid value entered for decimalSeparator AND thousandsSeparator. Only valid characters are `,` or `.`');

  final TextEditingController _textEditingController = TextEditingController();

  final String decimalSeparator;
  final String thousandsSeparator;
  final int decimalPlaces;
  final NumberFormat? fieldFormatter;
  bool get _onlyIntegers => decimalPlaces == 0;

  // InputDecoration getEnhancedDecoration(BuildContext context) {
  //   return getDecoration(context).copyWith();
  // }

  // @override
  // bool setInitialValue(num? initialValue) {
  //   final v = super.setInitialValue(initialValue);
  //   if (v) {
  //     textEditingController.text =
  //         fieldController.value != null ? "${fieldController.value}" : "";
  //   }
  //   return v;
  // }
  //TODO get those values from the theme
  static const defaultDecimalSeparator = ".";
  static const defaultThousandsSeparator = ",";
  static const nullSeparator = '_null_';
  final signed = false;

  RegExp get dotThousandsSeparatorRegex =>
      RegExp(r'[0-9]+([.]?[0-9])*([,][0-9]*)?');

  RegExp get commaThousandsSeparatorRegex =>
      RegExp(r'[0-9]+([,]?[0-9])*([.][0-9]*)?');

  RegExp get dotThousandsSeparatorRegexOnlyIntegers =>
      RegExp(r'[0-9]+([.][0-9])*');

  RegExp get commaThousandsSeparatorRegexOnlyIntegers =>
      RegExp(r'[0-9]+(,[0-9])*');

  FilteringTextInputFormatter get requestedNumberFilterFormat =>
      FilteringTextInputFormatter.allow(_onlyIntegers
          ? (thousandsSeparator == ','
              ? commaThousandsSeparatorRegexOnlyIntegers
              : dotThousandsSeparatorRegexOnlyIntegers)
          : (thousandsSeparator == ','
              ? commaThousandsSeparatorRegex
              : dotThousandsSeparatorRegex));

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, num? fieldValue, String? error) {
    return TextField(
      focusNode: _focusNode,
      readOnly: isReadOnly(formTheme),
      enabled: !isReadOnly(formTheme),
      controller: _textEditingController,
      textAlign: formTheme.style.textAlign,
      style: formTheme.style.textStyle,
      keyboardType: TextInputType.numberWithOptions(
          decimal: _onlyIntegers, signed: signed),
      inputFormatters: [requestedNumberFilterFormat],
      decoration:
          getInputDecoration(formController, formTheme, error, fieldValue),
      onChanged: (value) {
        String checkString = value
            .replaceAll(thousandsSeparator, "")
            .replaceAll(decimalSeparator, ".");

        try {
          setChangedValue(formController, num.parse(checkString));
        } catch (e) {
          setChangedValue(formController, null);
        }
      },
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, num? fieldValue) {
    if (fieldValue != null) {
      // creating the string for the NumberFormat
      final decimalPlacesFormat =
          List.generate(decimalPlaces, (index) => '#').join('');

      // creating the formatter (must leave en_US)
      final myFormat = _onlyIntegers
          ? NumberFormat('###,###', 'en_US')
          : NumberFormat('###,###.$decimalPlacesFormat', 'en_US');

      const decimalSeparatorTemporary = '#';

      // replacing the characters for the correct visualization
      final tempString = myFormat
          .format(fieldValue)
          .replaceAll('.', decimalSeparatorTemporary)
          .replaceAll(',', thousandsSeparator)
          .replaceAll(decimalSeparatorTemporary, decimalSeparator);

      _textEditingController.text = tempString;
    } else {
      _textEditingController.text = "";
    }
  }
}
