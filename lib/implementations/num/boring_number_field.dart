// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  MyNumberFormatter({
    required this.decimalSeparator,
    required this.thousandsSeparator,
    required this.decimalPlaces,
  });

  bool get onlyIntegers => decimalPlaces == 0;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // se il testo nuovo e' vuoto allora torno vuoto
    if (newValue.text.isEmpty) {
      return const TextEditingValue();
    }

    // prendo il testo e lo trasformo in un numero parsabile
    String valueText = newValue.text
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');

    final valueTextDivided = valueText.split('.');
    if (valueTextDivided.length > 1 && decimalPlaces > 0) {
      final decimals = valueTextDivided[1];
      if (decimals.length > decimalPlaces) {
        final cutDecimals = decimals.substring(0, decimalPlaces);
        valueText = "${valueTextDivided[0]}.$cutDecimals";
      }
    }

    // parso
    final valueNum = num.tryParse(valueText);

    if (valueNum == null) {
      // se fallisco il parsing allora ritorno quello che c'era prima

      if (valueText.contains('-') && valueText.length == 1) {
        return newValue;
      }

      return oldValue;
    }

    // calcolo il numero di tokens decimali da inserire
    final decimalPlacesFormat =
        List.generate(decimalPlaces, (index) => '#').join('');

    // creo il formatter (bisogna lasciare en_US)
    final myFormat = onlyIntegers
        ? NumberFormat('###,###', 'en_US')
        : NumberFormat('###,###.$decimalPlacesFormat', 'en_US');

    // formatto la stringa
    String result = myFormat
        .format(valueNum)
        .replaceAll('.', '#')
        .replaceAll(',', thousandsSeparator)
        .replaceAll('#', decimalSeparator);

    // controllo il numero dei separatori di migliaia che ho aggiunto in questa battitura
    final numberOfThousandsSeparatorAdded =
        (result.split(thousandsSeparator).length) -
            (oldValue.text.split(thousandsSeparator).length);

    int getNewOffset() {
      final newOffset =
          newValue.selection.extent.offset + numberOfThousandsSeparatorAdded;
      if (newOffset > result.length) {
        return newOffset - 1;
      }

      return newOffset;
    }

    // controllo se l'ultimo carattere inserito e' il separatore decimale
    final lastCharacterIsDecimalSeparator =
        newValue.text[newValue.text.length - 1] == decimalSeparator;

    // se lo e' allora lo appendo al risultato
    if (lastCharacterIsDecimalSeparator) {
      //controllo che effettivamente possa mettere dei separatori decimali
      if (decimalPlaces > 0) {
        result = '$result$decimalSeparator';
      } else {
        return TextEditingValue(
          text: result,
          selection: TextSelection.fromPosition(
            TextPosition(offset: getNewOffset()),
          ),
        );
      }
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
    this.decimalSeparator = defaultDecimalSeparator,
    this.thousandsSeparator = defaultThousandsSeparator,
    this.decimalPlaces = 0,
  })  : _numberFormatter = MyNumberFormatter(
          decimalPlaces: decimalPlaces,
          decimalSeparator: decimalSeparator,
          thousandsSeparator: thousandsSeparator,
        ),
        assert(decimalSeparator != thousandsSeparator,
            'Decimal and thousands separator can\'t be the same'),
        assert(
            (['.', ','].contains(decimalSeparator)) &&
                (['.', ','].contains(thousandsSeparator)),
            'Invalid value entered for decimalSeparator AND thousandsSeparator. Only valid characters are `,` or `.`');

  final TextEditingController _textEditingController = TextEditingController();

  final String decimalSeparator;
  final String thousandsSeparator;
  final int decimalPlaces;
  final MyNumberFormatter _numberFormatter;

  bool get _onlyIntegers => decimalPlaces == 0;

  static const defaultDecimalSeparator = ".";
  static const defaultThousandsSeparator = ",";
  static const nullSeparator = '_null_';
  final signed = false;

  bool hasSetInitialValue = false;

  @override
  Widget builder(BuildContext context, BoringFormStyle formTheme,
      BoringFormController formController, num? fieldValue, String? error) {
    // for initial value
    if (!hasSetInitialValue && fieldValue != null) {
      var cursorPos = _textEditingController.selection.base.offset;

      final formatter =
          NumberFormat('###,###.###', decimalSeparator == '.' ? 'en' : 'it');

      _textEditingController.text = _numberFormatter
          .formatEditUpdate(TextEditingValue.empty,
              TextEditingValue(text: formatter.format(fieldValue)))
          .text;

      _textEditingController.selection =
          TextSelection.collapsed(offset: cursorPos);

      hasSetInitialValue = true;
    }

    return TextField(
      readOnly: isReadOnly(formTheme),
      enabled: !isReadOnly(formTheme),
      controller: _textEditingController,
      textAlign: formTheme.textAlign,
      style: formTheme.textStyle,
      keyboardType: TextInputType.numberWithOptions(
          decimal: _onlyIntegers, signed: signed),
      inputFormatters: [_numberFormatter],
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
    if (fieldValue == null) {
      _textEditingController.text = "";
    }
  }
}
