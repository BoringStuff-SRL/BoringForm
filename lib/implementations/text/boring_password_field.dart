// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
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
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, String? fieldValue, String? error) {
    final inputDecoration =
        getInputDecoration(formController, formStyle, error, fieldValue);
    assert(inputDecoration.suffixIcon == null,
        "You can't specify suffixIcon on BoringPasswordField!");
    return BoringPasswordTextField(
      focusNode: _focusNode,
      textEditingController: _textEditingController,
      formTheme: formStyle,
      readOnly: isReadOnly(formStyle),
      fieldPath: fieldPath,
      inputDecoration: inputDecoration,
      startsHidden: true,
      visibilityOnIcon: visibilityOnIcon,
      visibilityOffIcon: visibilityOffIcon,
      onChanged: (value) {
        setChangedValue(formController, value);
      },
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
      required this.readOnly,
      required this.fieldPath,
      required this.inputDecoration,
      required this.onChanged,
      this.visibilityOnIcon,
      this.visibilityOffIcon,
      required this.startsHidden});

  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final BoringFormStyle formTheme;

  final bool readOnly;
  final FieldPath fieldPath;
  final InputDecoration inputDecoration;
  final Widget? visibilityOnIcon;
  final Widget? visibilityOffIcon;
  final bool startsHidden;
  final Function(String value) onChanged;

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
      textAlign: widget.formTheme.textAlign,
      style: widget.formTheme.textStyle,
      decoration: widget.inputDecoration.copyWith(
          suffixIcon: IconButton(
              onPressed: () => setState(() {
                    hidden = !hidden;
                  }),
              icon: hidden ? _visibilityOffIcon : _visibilityOnIcon)),
      onChanged: widget.onChanged,
    );
  }
}
