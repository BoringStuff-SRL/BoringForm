import 'package:boring_form/theme/boring_form_style.dart';
import 'package:flutter/material.dart';

class BoringFormTheme extends InheritedWidget {
  final BoringFormStyle style;

  const BoringFormTheme({super.key, required super.child, required this.style});

  static BoringFormTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BoringFormTheme>()
          as BoringFormTheme;

  @override
  bool updateShouldNotify(covariant BoringFormTheme oldWidget) => false;
}
