import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boringcore/boring_dropdown.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoicheField<T>
    extends BoringFormFieldWithAsyncCalculations<List<T>,
        List<BoringChoiceItem<T>>> {
  const BoringDropdownMultiChoicheField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    required this.toBoringChoicheItem,
  });

  final Future<List<BoringChoiceItem<T>>> Function(String search) getItems;
  final BoringChoiceItem<T> Function(T) toBoringChoicheItem;
  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      List<T>? fieldValue,
      String? errror,
      AsyncSnapshot<List<BoringChoiceItem<T>>> calculations) {
    return BoringDropdownMultichoice(
      value: fieldValue?.map((e) => toBoringChoicheItem(e)).toList(),
      searchItems: getItems,
      onChanged: (values) =>
          setChangedValue(formController, values?.map((e) => e.value).toList()),
    );
  }

  @override
  Future<List<BoringChoiceItem<T>>> onObservedFieldsChange(
          BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, List<T>? fieldValue) {}
}
