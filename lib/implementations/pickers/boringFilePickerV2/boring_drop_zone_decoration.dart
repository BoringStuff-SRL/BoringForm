// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:flutter/material.dart';

class BoringFilePickerDecoration {
  final EdgeInsetsGeometry? dropZonePadding;
  final BorderRadius? borderRadius;
  final Border? border;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Icon? hintIcon;
  final Color inActiveColor;
  final Color activeColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  const BoringFilePickerDecoration(
      {this.dropZonePadding,
      this.borderRadius,
      this.border,
      this.hintText,
      this.hintTextStyle,
      this.hintIcon,
      this.crossAxisAlignment,
      this.mainAxisAlignment,
      this.inActiveColor = Colors.grey,
      this.activeColor = Colors.green});
}
