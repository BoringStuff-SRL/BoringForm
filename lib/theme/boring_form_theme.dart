import 'package:boring_form/theme/boring_form_style.dart';
import 'package:flutter/material.dart';

class BoringFormTheme extends InheritedWidget {
  final BoringFormStyle style;

  const BoringFormTheme({super.key, required super.child, required this.style});

  static BoringFormTheme? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BoringFormTheme>();

  static BoringFormTheme of(BuildContext context) =>
      maybeOf(context) as BoringFormTheme;

  @override
  bool updateShouldNotify(covariant BoringFormTheme oldWidget) => false;
}
