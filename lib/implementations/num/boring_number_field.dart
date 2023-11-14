// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:universal_io/io.dart';

TextEditingValue formatFunction(
    TextEditingValue oldValue,
    TextEditingValue newValue,
    FilteringTextInputFormatter? formatter,
    String Function(String s)? formatPatern) {
  String originalUserInput = newValue.text;
  newValue = formatter != null
      ? formatter.formatEditUpdate(oldValue, newValue)
      : newValue;
  int selectionIndex = newValue.selection.end;

  String newText =
      formatPatern != null ? formatPatern(newValue.text) : newValue.text;

  if (newText == newValue.text) {
    return newValue;
  }

  int insertCount = 0;
  int inputCount = 0;

  // ignore: no_leading_underscores_for_local_identifiers
  bool _isUserInput(String s) {
    return formatter == null
        ? originalUserInput.contains(s)
        : newValue.text.contains(s);
  }

  for (int i = 0; i < newText.length && inputCount < selectionIndex; i++) {
    final character = newText[i];
    if (_isUserInput(character)) {
      inputCount++;
    } else {
      insertCount++;
    }
  }

  selectionIndex += insertCount;
  selectionIndex = min(selectionIndex, newText.length);
  if (selectionIndex - 1 >= 0 &&
      selectionIndex - 1 < newText.length &&
      !_isUserInput(newText[selectionIndex - 1])) {
    selectionIndex--;
  }

  return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty);
}

//https://github.com/hnvn/flutter_pattern_formatter
class NumberFormatter2 extends TextInputFormatter {
  final String? decimalSeparator;
  final String thousandsSeparator;
  final int? decimalPlaces;

  NumberFormatter2({
    this.thousandsSeparator = ",",
    this.decimalPlaces,
    this.decimalSeparator = ".",
  });

  NumberFormatter2.integer({
    this.thousandsSeparator = "",
  })  : decimalPlaces = 0,
        decimalSeparator = null;

  final formatter = NumberFormat("#,###");

  String removeAllExceptFirst(String source, String pattern) {
    int i = source.indexOf(pattern);
    if (i < 0) return source;
    String target = source.replaceAll(pattern, "");
    return "${target.substring(0, i)}$pattern${target.substring(i)}";
  }

  num? parseString(String s) => num.tryParse(s
      .replaceAll(thousandsSeparator, "")
      .replaceAll(decimalSeparator ?? "", decimalSeparator != null ? "." : ""));

  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    if (newValue.text.isEmpty) return newValue;

    Pattern regex = RegExp("[^0-9$decimalSeparator]");

    String newInputText = newValue.text.replaceAll(regex, "");
    if (decimalSeparator != null) {
      newInputText = removeAllExceptFirst(newInputText, decimalSeparator!);
    }

    if (newInputText.isEmpty) {
      return newValue.copyWith(
          text: newInputText,
          selection: TextSelection.collapsed(offset: newInputText.length),
          composing: TextRange.empty);
    }

    //NOW THE CURSOR SHOULD BE AFTER THE CHAR AT POSITION index
    int offset = 0;
    final splitted = decimalSeparator != null
        ? newInputText.split(decimalSeparator!)
        : [newInputText, ""];
    String integerPart = splitted[0].replaceAll(thousandsSeparator, "");
    if (integerPart.isEmpty) {
      integerPart = "0";
      offset++;
    }

    String decimalPart = splitted.length > 1 ? splitted[1] : "";
    if (decimalPlaces != null && decimalPart.length > decimalPlaces!) {
      decimalPart = decimalPart.substring(0, decimalPlaces!);
    }
    int? parsed = int.tryParse(integerPart);
    if (parsed == null && newValue.text.length > oldValue.text.length) {
      return oldValue;
    }
    //TODO fix paste a too big number
    integerPart = formatter.format(parsed).replaceAll(',', thousandsSeparator);
    String newText = decimalSeparator != null
        ? "$integerPart${newInputText.contains(decimalSeparator!) ? decimalSeparator : ''}$decimalPart"
        : integerPart;

    int rcp = 0;
    for (var i = 0;
        i < min(newValue.text.length, newValue.selection.baseOffset);
        i++) {
      if (newValue.text[i] != thousandsSeparator) {
        rcp++;
      }
    }

    int dec = rcp;
    for (var i = 0; i < newText.length && dec > 0; i++) {
      if (newText[i] != thousandsSeparator) {
        dec--;
      }
      offset++;
    }

    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
        composing: TextRange.empty);
  }
}

class BoringNumberField extends BoringField<num> {
  BoringNumberField({
    super.key,
    super.fieldController,
    super.onChanged,
    required super.jsonKey,
    super.boringResponsiveSize,
    super.decoration,
    this.decimalSeparator = ".",
    this.thousandsSeparator = ",",
    this.decimalPlaces,
    this.fieldFormatter,
    bool? readOnly,
    this.onlyIntegers = false,
    super.displayCondition,
  })  : assert(decimalSeparator != thousandsSeparator,
            'Decimal and thousands separator must be defference'),
        assert(
            (decimalSeparator == '.' || decimalSeparator == ',') &&
                (thousandsSeparator == '.' || thousandsSeparator == ','),
            'Invalid value entered for decimalSeparator AND thousandsSeparator. Consider only these characters valid [,] or [.]'),
        super(readOnly: readOnly);

  final TextEditingController textEditingController = TextEditingController();

  final String? decimalSeparator;
  final String? thousandsSeparator;
  final int? decimalPlaces;
  final NumberFormat? fieldFormatter;
  final bool onlyIntegers;

  InputDecoration getEnhancedDecoration(BuildContext context) {
    return getDecoration(context).copyWith();
  }

  @override
  bool setInitialValue(num? initialValue) {
    final v = super.setInitialValue(initialValue);
    if (v) {
      textEditingController.text =
          fieldController.value != null ? "${fieldController.value}" : "";
    }
    return v;
  }

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;
    final dSeparator = decimalSeparator ??
        numberFormatSymbols[Platform.localeName.split('_').first]?.DECIMAL_SEP;
    final tSeparator = thousandsSeparator ??
        numberFormatSymbols[Platform.localeName.split('_').first]?.GROUP_SEP;
    final formatter = NumberFormatter2(
        decimalPlaces: decimalPlaces,
        decimalSeparator: dSeparator,
        thousandsSeparator: tSeparator);

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: ValueListenableBuilder(
          valueListenable: controller.autoValidate
              ? ValueNotifier(false)
              : controller.hideError,
          builder: (BuildContext context, bool value, Widget? child) {
            return TextField(
              readOnly: isReadOnly(context),
              enabled: !isReadOnly(context),
              controller: textEditingController,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: onlyIntegers),
              inputFormatters: [
                onlyIntegers
                    ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    : formatter
              ],
              decoration: getDecoration(context, haveError: value),
              onChanged: ((value) {
                try {
                  if (tSeparator == ',') {
                    value = value.replaceAll(",", "");
                  } else if (tSeparator == '.') {
                    value = value.replaceAll(".", "");
                    value = value.replaceAll(",", ".");
                  }

                  controller.value = num.parse(value);
                } catch (e) {
                  print(e);
                  controller.value = null;
                }
              }),
            );
          }),
    );
  }

  @override
  void onValueChanged(num? newValue) {
    // aaadfg45544455
  }

  @override
  BoringNumberField copyWith(
      {BoringFieldController<num>? fieldController,
      void Function(num? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      String? decimalSeparator,
      String? thousandsSeparator,
      int? decimalPlaces}) {
    return BoringNumberField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
    );
  }
}
