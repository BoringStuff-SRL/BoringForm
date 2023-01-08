// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';

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
class NumberFormatter extends TextInputFormatter {
  final String? decimalSeparator;
  final String thousandsSeparator;
  final int? decimalPlaces;
  NumberFormatter({
    this.thousandsSeparator = ",",
    this.decimalPlaces,
    this.decimalSeparator = ".",
  });
  NumberFormatter.integer({
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
    super.displayCondition,
  });

  final TextEditingController textEditingController = TextEditingController();

  InputDecoration getEnhancedDecoration(BuildContext context) {
    return getDecoration(context).copyWith();
  }

  final String? decimalSeparator;
  final String thousandsSeparator;
  final int? decimalPlaces;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    final formatter = NumberFormatter(thousandsSeparator: thousandsSeparator);

    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [formatter],
        decoration: getEnhancedDecoration(context),
        onChanged: ((value) {
          controller.value = formatter.parseString(value);
        }),
      ),
    );
  }

  @override
  void onValueChanged(num? newValue) {
    // aaadfg45544455
  }
}
