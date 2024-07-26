// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

abstract class BoringFormFieldBase<T, TT> extends StatelessWidget {
  final FieldPath fieldPath;
  final List<FieldPath> observedFields;
  final ValidationFunction<T> validationFunction;
  final DecorationBuilder<T>? _decorationBuilder;
  final bool? _readOnly;
  final Function(BoringFormController formController, T? fieldValue)? onChanged;

  const BoringFormFieldBase({
    super.key,
    required this.fieldPath,
    this.observedFields = const [],
    this.onChanged,
    // required this.builder,
    this.validationFunction,
    DecorationBuilder<T>? decoration,
    bool? readOnly,
  })  : _readOnly = readOnly,
        _decorationBuilder = decoration;

  bool isReadOnly(BoringFormStyle style) => _readOnly ?? style.readOnly;

  void setChangedValue(BoringFormController formController, T? newValue) {
    formController.setFieldValue<T?>(fieldPath, newValue);
    onChanged?.call(formController, newValue);
  }

  TT onObservedFieldsChange(BoringFormController formController);

  void onSelfChange(BoringFormController formController, T? fieldValue);

  Widget labelOverField(
    BoringFieldDecoration fieldDecoration,
    BoringFormController formController,
    BoringFormStyle style,
  ) {
    return Padding(
      padding: style.labelOverFieldPadding ?? const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: style.labelOverFieldAlignment,
        child: _label(fieldDecoration, formController, style),
      ),
    );
  }

  Widget _label(
    BoringFieldDecoration fieldDecoration,
    BoringFormController formController,
    BoringFormStyle style,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            fieldDecoration.label!,
            style: style.inputDecoration.labelStyle,
          ),
          _buildRequiredFieldLabelOverField(style, formController),
        ],
      );

  Widget _buildRequiredFieldLabelOverField(
      BoringFormStyle formStyle, BoringFormController formController) {
    if (validationFunction == null) return Container();

    final label = formStyle.fieldRequiredLabelWidget ??
        const Text(' *', style: TextStyle(color: Colors.red));

    switch (formController.fieldRequiredLabelBehaviour) {
      case FieldRequiredLabelBehaviour.always:
        return label;
      case FieldRequiredLabelBehaviour.hiddenWhenValid:
        final valFunValue = validationFunction?.call(
            formController, formController.getValue(fieldPath));
        if (valFunValue == null) {
          return const Text(' *');

        }
        return label;
      case FieldRequiredLabelBehaviour.never:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context);

  BoringFieldDecoration<T>? getFieldDecoration(
          BoringFormController formController) =>
      _decorationBuilder?.call(formController);

  InputDecoration getInputDecoration(BoringFormController formController,
      BoringFormStyle style, String? errorMessage, T? value) {
    final formStyle = style;

    final decoration = getFieldDecoration(formController);

    return formStyle.inputDecoration.copyWith(
        label: (formStyle.labelOverField ||
                decoration == null ||
                decoration.label == null)
            ? null
            : _label(decoration, formController, formStyle),
        icon: decoration?.icon,
        errorText: errorMessage,
        helperText: decoration?.helperText,
        hintText: decoration?.hintText,
        prefix: decoration?.prefix,
        prefixIcon: decoration?.prefixIcon,
        prefixText: decoration?.prefixText,
        suffix: decoration?.suffix,
        suffixIcon: decoration?.suffixIcon,
        suffixText: decoration?.suffixText,
        counter: decoration?.counter?.call(value));
  }
}
