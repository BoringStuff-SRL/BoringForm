// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:flutter/material.dart';

class BoringPasswordField extends BoringField<String> {
  BoringPasswordField(
      {super.key,
      super.fieldController,
      super.onChanged,
      required super.jsonKey,
      this.visibilityOffIcon,
      this.visibilityOnIcon,
      super.displayCondition,
      super.boringResponsiveSize,
      super.decoration})
      : assert(decoration?.suffixIcon == null,
            "You can't specify suffixIcon on BoringPasswordField!");

  final TextEditingController textEditingController = TextEditingController();
  final Widget? visibilityOnIcon;
  final Widget? visibilityOffIcon;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: PasswordTextField(
          textEditingController: textEditingController,
          decoration: getDecoration,
          visibilityOnIcon: visibilityOnIcon,
          visibilityOffIcon: visibilityOffIcon,
          controller: controller),
    );
  }

  @override
  void onValueChanged(String? newValue) {
    if (newValue != textEditingController.text) {
      textEditingController.text = newValue ?? '';
    }
  }

  @override
  BoringPasswordField copyWith(
      {BoringFieldController<String>? fieldController,
      void Function(String? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      Widget? visibilityOffIcon,
      Widget? visibilityOnIcon}) {
    return BoringPasswordField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      visibilityOffIcon: visibilityOffIcon ?? this.visibilityOffIcon,
      visibilityOnIcon: visibilityOnIcon ?? this.visibilityOnIcon,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key,
      required this.textEditingController,
      required this.decoration,
      required this.controller,
      this.visibilityOffIcon,
      this.visibilityOnIcon});

  final TextEditingController textEditingController;
  final InputDecoration Function(BuildContext, {bool haveError}) decoration;
  final BoringFieldController<String> controller;
  final Widget? visibilityOnIcon;
  final Widget? visibilityOffIcon;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool hidden = true;

  @override
  void initState() {
    super.initState();
    //hidden = startHidden
  }

  void toggleVisibility() {
    setState(() {
      hidden = !hidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.controller.hideError,
        builder: (BuildContext context, bool value, Widget? child) {
          return TextField(
            controller: widget.textEditingController,
            obscureText: hidden,
            enableSuggestions: false,
            autocorrect: false,
            decoration: widget.decoration
                .call(context, haveError: value)
                .copyWith(
                    suffixIcon: (widget.visibilityOffIcon == null ||
                            widget.visibilityOnIcon == null)
                        ? IconButton(
                            icon: Icon(
                              hidden ? Icons.visibility_off : Icons.visibility,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: toggleVisibility)
                        : GestureDetector(
                            onTap: () {
                              toggleVisibility();
                            },
                            child: hidden
                                ? widget.visibilityOffIcon
                                : widget.visibilityOnIcon,
                          )),
            // InputDecoration(
            onChanged: ((value) {
              widget.controller.value = value;
              widget.controller.isValid;
            }),
          );
        });
  }
}
