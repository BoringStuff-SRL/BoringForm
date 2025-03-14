import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_ui/boring_ui.dart';
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

class BFormControllerProvider extends InheritedWidget {
  final BoringFormController formController;

  const BFormControllerProvider(
      {super.key, required super.child, required this.formController});

  static BoringFormController controllerOf(BuildContext context) {
    final inheritedWidget =
        context.getInheritedWidgetOfExactType<BFormControllerProvider>();
    assert(inheritedWidget != null,
        "BFormControllerProvider not found in context");
    return inheritedWidget!.formController;
  }

  @override
  bool updateShouldNotify(covariant BFormControllerProvider oldWidget) => false;
}
