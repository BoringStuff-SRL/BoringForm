import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:flutter/material.dart';

class BoringPasswordField extends BoringField<String> {
  BoringPasswordField(
      {super.key,
      super.fieldController,
      super.onChanged,
      required super.jsonKey,
      super.displayCondition,
      super.boringResponsiveSize,
      super.decoration})
      : assert(decoration?.suffixIcon == null,
            "You can't specify suffixIcon on BoringPasswordField!");

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;
    return BoringField.boringFieldBuilder(
      style,
      decoration?.label,
      child: PasswordTextField(
          textEditingController: textEditingController,
          decoration: getDecoration(context),
          controller: controller),
    );
  }

  @override
  void onValueChanged(String? newValue) {
    if (newValue != textEditingController.text) {
      textEditingController.text = newValue ?? '';
    }
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key,
      required this.textEditingController,
      required this.decoration,
      required this.controller});

  final TextEditingController textEditingController;
  final InputDecoration decoration;
  final BoringFieldController<String> controller;

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
    return TextField(
      controller: widget.textEditingController,
      obscureText: hidden,
      enableSuggestions: false,
      autocorrect: false,
      decoration: widget.decoration.copyWith(
        suffixIcon: IconButton(
            icon: Icon(
              hidden ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: toggleVisibility),
      ), // InputDecoration(
      onChanged: ((value) {
        widget.controller.value = value;
      }),
    );
  }
}
