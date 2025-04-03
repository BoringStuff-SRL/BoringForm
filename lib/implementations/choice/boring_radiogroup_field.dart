// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringRadioGroupField<T> extends BFormField<T> {
  BoringRadioGroupField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    required this.items,
    this.itemsPerRow = 1,
    this.allowEmpty = false,
    super.onChanged,
    super.responsiveSize,
  });

  final List<BChoiceItem<T>> items;
  final int itemsPerRow;
  final bool allowEmpty;

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    T? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    final dec = getFieldDecoration(formController);
    final inputDecoration = getInputDecoration(
        formController, formStyle, fieldValue, fieldValidation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(dec?.label ?? ""),
        ),
        Wrap(
          children: items
              .map((item) => FractionallySizedBox(
                    widthFactor: 1 / itemsPerRow,
                    child: RadioListTile<T?>(
                        dense: true,
                        activeColor: inputDecoration.focusColor,
                        contentPadding:
                            inputDecoration.contentPadding ?? EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        toggleable: allowEmpty,
                        value: item.value,
                        title: Text(item.display),
                        groupValue: formController.getValue(fieldPath),
                        onChanged: fieldValidation.isReadOnly
                            ? null
                            : (value) =>
                                setChangedValue(formController, value)),
                  ))
              .toList(),
        ),
        if (dec?.helperText != null && dec!.helperText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(dec.helperText ?? ""),
          ),
      ],
    );
  }
}
