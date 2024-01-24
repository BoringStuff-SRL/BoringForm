// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringFieldDecoration<T> {
  final String? label;
  final Widget? icon;
  final String? helperText;
  final String? hintText;
  final Widget? Function(T? value)? counter;

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

  BoringFieldDecoration copyWith({
    String? label,
    Widget? icon,
    String? helperText,
    String? hintText,
    Widget? Function(T? value)? counter,
    Widget? prefix,
    Widget? prefixIcon,
    String? prefixText,
    Widget? suffix,
    Widget? suffixIcon,
    String? suffixText,
  }) {
    return BoringFieldDecoration<T>(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      helperText: helperText ?? this.helperText,
      hintText: hintText ?? this.hintText,
      counter: counter ?? this.counter,
      prefix: prefix ?? this.prefix,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefixText: prefixText ?? this.prefixText,
      suffix: suffix ?? this.suffix,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      suffixText: suffixText ?? this.suffixText,
    );
  }
}
