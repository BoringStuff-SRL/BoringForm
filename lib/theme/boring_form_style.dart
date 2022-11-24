import 'package:flutter/material.dart';

class BoringFormStyle {
  final InputDecoration inputDecoration;
  final bool labelOverField;
  final TextStyle sectionTitleStyle;
  final EdgeInsetsGeometry fieldsPadding;
  final TextStyle formTitleStyle;
  BoringFormStyle({
    this.fieldsPadding = const EdgeInsets.all(8),
    this.sectionTitleStyle = const TextStyle(),
    this.formTitleStyle = const TextStyle(),
    this.inputDecoration = const InputDecoration(),
    this.labelOverField = false,
  })  : assert(inputDecoration.label == null, _getFieldAssertionError("label")),
        assert(inputDecoration.icon == null, _getFieldAssertionError("icon")),
        assert(inputDecoration.helperText == null,
            _getFieldAssertionError("helperText")),
        assert(inputDecoration.hintText == null,
            _getFieldAssertionError("hintText")),
        assert(inputDecoration.counter == null,
            _getFieldAssertionError("counter")),
        assert(
            inputDecoration.prefix == null, _getFieldAssertionError("prefix")),
        assert(inputDecoration.prefixIcon == null,
            _getFieldAssertionError("prefixIcon")),
        assert(inputDecoration.prefixText == null,
            _getFieldAssertionError("prefixText")),
        assert(
            inputDecoration.suffix == null, _getFieldAssertionError("suffix")),
        assert(inputDecoration.suffixIcon == null,
            _getFieldAssertionError("suffixIcon")),
        assert(inputDecoration.suffixText == null,
            _getFieldAssertionError("suffixText"));

  static String _getFieldAssertionError(String field) =>
      "InputDecoration '$field' property not allowed inside BoringFormStyle: the '$field' property will be inherited from each field!";
}
