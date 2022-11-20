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
  }) : assert(inputDecoration.label == null,
            "InputDecoration label property not allowed inside BoringFormStyle: the label will be inherited from each field!");
}
