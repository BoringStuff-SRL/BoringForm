// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringRadioGroupField<T> extends BoringFormField<T> {
  const BoringRadioGroupField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,

    ///
    // required super.jsonKey,
    required this.items,
    // super.fieldController,
    // super.decoration,
    this.itemsPerRow = 1,
    // super.displayCondition,
    // super.boringResponsiveSize,
    // super.onChanged
  });

  final List<BChoiceItem<T>> items;
  final int itemsPerRow;

  @override
  Widget builder(BuildContext context, BoringFormStyle formTheme,
      BoringFormController formController, T? fieldValue, String? errror) {
    final dec = getFieldDecoration(formController);
    final inputDecoration =
        getInputDecoration(formController, formTheme, errror, fieldValue);
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
                        activeColor: inputDecoration.focusColor,
                        contentPadding: inputDecoration.contentPadding,
                        value: item.value,
                        title: Text(item.display),
                        groupValue: formController.getValue(fieldPath),
                        onChanged: isReadOnly(formTheme)
                            ? null
                            : (value) =>
                                setChangedValue(formController, value)),
                  ))
              .toList(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(dec?.helperText ?? ""),
        ),
      ],
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {}

  // @override
  // Widget builder(context, controller, child) {
  //   final style = BoringFormTheme.of(context).style;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 8.0),
  //         child: Text(decoration?.label ?? ""),
  //       ),
  //       Wrap(
  //         children: items
  //             .map((item) => FractionallySizedBox(
  //                   widthFactor: 1 / itemsPerRow,
  //                   child: RadioListTile<T?>(
  //                       activeColor: style.inputDecoration.focusColor,
  //                       contentPadding: style.inputDecoration.contentPadding,
  //                       value: item.value,
  //                       title: Text(item.display),
  //                       groupValue: fieldController.value,
  //                       onChanged: style.readOnly
  //                           ? null
  //                           : (value) => fieldController.value = value),
  //                 ))
  //             .toList(),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(left: 8.0),
  //         child: Text(decoration?.helperText ?? ""),
  //       ),
  //     ],
  //   );
  // }
}
