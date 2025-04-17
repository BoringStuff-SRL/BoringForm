// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
// import 'package:boring_form/field/boring_field.dart';
// import 'package:boring_form/field/boring_field_controller.dart';
// import 'package:boring_form/theme/boring_field_decoration.dart';
// import 'package:boring_form/theme/boring_form_theme.dart';
// import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MyNumberFormatter extends TextInputFormatter {
  final String decimalSeparator;
  final String thousandsSeparator;
  final int decimalPlaces;
  final bool allowNegative;

  MyNumberFormatter({
    required this.decimalSeparator,
    required this.thousandsSeparator,
    required this.decimalPlaces,
    this.allowNegative = true,
  });

  bool get onlyIntegers => decimalPlaces == 0;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    String valueText = newValue.text
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');

    // Verifica se è negativo solo se `allowNegative` è abilitato
    if (allowNegative && valueText.startsWith('-')) {
      if (valueText == '-') {
        return newValue; // Consenti "-" temporaneamente
      }
    } else {
      // Rimuovi il segno negativo se non è permesso
      valueText = valueText.replaceAll('-', '');
    }

    // Rimuovi eventuali segni negativi duplicati
    valueText = valueText.replaceAll(RegExp(r'-+'), '-');

    final valueTextDivided = valueText.split('.');
    if (valueTextDivided.length > 1 && decimalPlaces > 0) {
      final decimals = valueTextDivided[1];
      if (decimals.length > decimalPlaces) {
        final cutDecimals = decimals.substring(0, decimalPlaces);
        valueText = "${valueTextDivided[0]}.$cutDecimals";
      }
    }

    final valueNum = num.tryParse(valueText);

    if (valueNum == null) {
      if (valueText.contains('-') && valueText.length == 1) {
        return newValue;
      }
      return oldValue;
    }

    final decimalPlacesFormat =
        List.generate(decimalPlaces, (index) => '#').join('');

    final myFormat = onlyIntegers
        ? NumberFormat('###,###', 'en_US')
        : NumberFormat('###,###.$decimalPlacesFormat', 'en_US');

    String result = myFormat
        .format(valueNum)
        .replaceAll('.', '¤')
        .replaceAll(',', thousandsSeparator)
        .replaceAll('¤', decimalSeparator);

    int getNewOffset() {
      int newOffset = newValue.selection.baseOffset;
      int offsetCorrection = result.length - valueText.length;

      if (newOffset + offsetCorrection > result.length) {
        newOffset = result.length;
      } else if (newOffset + offsetCorrection < 0) {
        newOffset = 0;
      } else {
        newOffset += offsetCorrection;
      }

      return newOffset;
    }

    final lastCharacterIsDecimalSeparator = newValue.text.isNotEmpty &&
        newValue.text[newValue.text.length - 1] == decimalSeparator;

    if (lastCharacterIsDecimalSeparator && decimalPlaces > 0) {
      result = '$result$decimalSeparator';
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.fromPosition(
        TextPosition(offset: getNewOffset()),
      ),
    );
  }
}

class BoringNumberField extends BoringFormField<num> {
  BoringNumberField({
    super.key,
    super.onChanged,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    super.forceHideRequiredFieldLabel,
    this.decimalSeparator,
    this.thousandsSeparator,
    this.decimalPlaces = 0,
    this.allowNegative = true,
    this.showIncrementDecrementButtons = false,
  })  : assert(
            decimalSeparator == null ||
                thousandsSeparator == null ||
                decimalSeparator != thousandsSeparator,
            'Decimal and thousands separator can\'t be the same'),
        assert(
          (decimalSeparator == null || ['.', ','].contains(decimalSeparator)) &&
              (thousandsSeparator == null ||
                  ['.', ','].contains(thousandsSeparator)),
          'Invalid value entered for decimalSeparator AND thousandsSeparator. Only valid characters are `,` or `.`',
        );

  final TextEditingController _textEditingController = TextEditingController();

  final String? decimalSeparator;
  final String? thousandsSeparator;
  final int decimalPlaces;
  final bool allowNegative;
  MyNumberFormatter? _numberFormatter;
  final bool showIncrementDecrementButtons; // Nuova proprietà aggiunta

  bool get _onlyIntegers => decimalPlaces == 0;

  static const defaultDecimalSeparator = ".";
  static const defaultThousandsSeparator = ",";

  static const nullSeparator = '_null_';
  final signed = false;

  bool hasSetInitialValue = false;

  @override
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, num? fieldValue, String? error) {
    const iconConstraints = BoxConstraints(
      minWidth: 24,
      minHeight: 24,
    );
    const iconPadding = EdgeInsets.all(2);

    const iconSize = 16.0;

    final locale = Localizations.localeOf(context);

print(locale);

    final finalDecimalSeparator = decimalSeparator ??
        (locale.countryCode == 'it' ? ',' : defaultDecimalSeparator);
    final finalThousandsSeparator = thousandsSeparator ??
        (locale.countryCode == 'it' ? '.' : defaultThousandsSeparator);

    _numberFormatter = MyNumberFormatter(
      decimalPlaces: decimalPlaces,
      decimalSeparator: finalDecimalSeparator,
      thousandsSeparator: finalThousandsSeparator,
      allowNegative: allowNegative,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            readOnly: isReadOnly(formController, formStyle),
            enabled: !isReadOnly(formController, formStyle),
            controller: _textEditingController,
            textAlign: formStyle.textAlign,
            style: formStyle.textStyle,
            keyboardType: TextInputType.numberWithOptions(
              decimal: _onlyIntegers,
              signed: signed,
            ),
            inputFormatters: [_numberFormatter!],
            decoration: getInputDecoration(
              formController,
              formStyle,
              error,
              fieldValue,
            ),
            onChanged: (value) {
              String checkString = value
                  .replaceAll(finalDecimalSeparator, "")
                  .replaceAll(finalThousandsSeparator, ".");
              try {
                setChangedValue(formController, num.parse(checkString));
              } catch (e) {
                setChangedValue(formController, null);
              }
            },
          ),
        ),
        // Mostra i pulsanti solo se il flag è true
        if (showIncrementDecrementButtons &&
            !isReadOnly(formController, formStyle))
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                onPressed: () {
                  _incrementValue(formController);
                },
                constraints: iconConstraints,
                padding: iconPadding,
                iconSize: iconSize,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down),
                onPressed: () {
                  _decrementValue(formController);
                },
                constraints: iconConstraints,
                padding: iconPadding,
                iconSize: iconSize,
              ),
            ],
          ),
      ],
    );
  }

  void _incrementValue(BoringFormController formController) {
    int currentValue = int.tryParse(_textEditingController.text) ?? 0;
    currentValue++;
    _textEditingController.text = currentValue.toString();
    setChangedValue(formController, currentValue);
  }

  void _decrementValue(BoringFormController formController) {
    int currentValue = int.tryParse(_textEditingController.text) ?? 1;
    if (currentValue > 1) {
      currentValue--;
      _textEditingController.text = currentValue.toString();
      setChangedValue(formController, currentValue);
    }
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, num? fieldValue) {
    if (fieldValue == null) {
      _textEditingController.text = '';
      return;
    }

    var cursorPos = _textEditingController.selection.base.offset;

    final formatter =
        NumberFormat('###,###.###', decimalSeparator == '.' ? 'en' : 'it');

    if (_numberFormatter != null) {
      _textEditingController.text = _numberFormatter!
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(
              text: formatter.format(fieldValue),
            ),
          )
          .text;
    }

    _textEditingController.selection = TextSelection.collapsed(
      offset: min(
        cursorPos,
        _textEditingController.text.length,
      ),
    );
  }
}
