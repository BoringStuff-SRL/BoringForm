// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFieldDecoration {
  final String? label;
  final Widget? icon;
  final String? helperText;
  final String? hintText;
  final Widget? Function(dynamic value)? counter;

  final Widget? prefix;
  final Widget? prefixIcon;
  final String? prefixText;

  final Widget? suffix;
  final Widget? suffixIcon;
  final String? suffixText;

  BoringFieldDecoration({
    this.label,
    this.icon,
    this.helperText,
    this.hintText,
    this.counter,
    this.prefix,
    this.prefixIcon,
    this.prefixText,
    this.suffix,
    this.suffixIcon,
    this.suffixText,
  });
}
