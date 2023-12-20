// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:flutter/material.dart';

class BoringPasswordField extends BoringFormField<String> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  BoringPasswordField(
      {super.key,
      required super.fieldPath,
      super.observedFields,
      required super.validationFunction,
      super.decoration,
      this.visibilityOnIcon,
      this.visibilityOffIcon,
      super.readOnly});

  final Widget? visibilityOnIcon;
  final Widget? visibilityOffIcon;

  @override
  Widget builder(BuildContext context, BoringFormTheme formTheme,
      BoringFormController formController, String? fieldValue, String? errror) {
    final inputDecoration =
        getInputDecoration(formController, formTheme, errror, fieldValue);
    assert(inputDecoration.suffixIcon == null,
        "You can't specify suffixIcon on BoringPasswordField!");
    return BoringPasswordTextField(
      focusNode: _focusNode,
      textEditingController: _textEditingController,
      formTheme: formTheme,
      formController: formController,
      readOnly: isReadOnly(formTheme),
      fieldPath: fieldPath,
      inputDecoration: inputDecoration,
      startsHidden: true,
      visibilityOnIcon: visibilityOnIcon,
      visibilityOffIcon: visibilityOffIcon,
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, String? fieldValue) {
    if (!_focusNode.hasFocus) {
      _textEditingController.text = (fieldValue ?? "").trim();
    }
  }
}

class BoringPasswordTextField extends StatefulWidget {
  const BoringPasswordTextField(
      {super.key,
      required this.focusNode,
      required this.textEditingController,
      required this.formTheme,
      required this.formController,
      required this.readOnly,
      required this.fieldPath,
      required this.inputDecoration,
      this.visibilityOnIcon,
      this.visibilityOffIcon,
      required this.startsHidden});

  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final BoringFormTheme formTheme;
  final BoringFormController formController;
  final bool readOnly;
  final FieldPath fieldPath;
  final InputDecoration inputDecoration;
  final Widget? visibilityOnIcon;
  final Widget? visibilityOffIcon;
  final bool startsHidden;

  @override
  State<BoringPasswordTextField> createState() =>
      _BoringPasswordTextFieldState();
}

class _BoringPasswordTextFieldState extends State<BoringPasswordTextField> {
  bool hidden = true;

  @override
  void initState() {
    hidden = widget.startsHidden;
    super.initState();
  }

  Widget get _visibilityOnIcon =>
      widget.visibilityOnIcon ?? const Icon(Icons.visibility);
  Widget get _visibilityOffIcon =>
      widget.visibilityOffIcon ?? const Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      obscureText: hidden,
      enableSuggestions: false,
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      enabled: !widget.readOnly,
      textAlign: widget.formTheme.style.textAlign,
      style: widget.formTheme.style.textStyle,
      decoration: widget.inputDecoration.copyWith(
          suffixIcon: IconButton(
              onPressed: () => setState(() {
                    hidden = !hidden;
                  }),
              icon: hidden ? _visibilityOffIcon : _visibilityOnIcon)),
      onChanged: (value) {
        widget.formController.setFieldValue(widget.fieldPath, value);
      },
    );
  }
}
