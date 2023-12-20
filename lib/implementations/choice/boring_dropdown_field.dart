import 'package:boring_dropdown/boring_dropdown.dart';
import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/implementations/choice/boring_radiogroup_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

class BoringDropdownField<T>
    extends BoringFormFieldWithAsyncCalculations<T, List<BoringChoiceItem<T>>> {
  const BoringDropdownField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
  });

  final Future<List<BoringChoiceItem<T>>> getItems;

  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      T? fieldValue,
      String? errror,
      AsyncSnapshot<List<BoringChoiceItem<T>>> calculations) {
    return BoringDropdown<T>(
      items: calculations.data!
          .map((e) => DropdownMenuItem(value: e.value, child: Text(e.display)))
          .toList(),
      multichoice: false,
      convertItemToString: (element) =>
          calculations.data!.firstWhere((el) => element == el).display,
      onChanged: (val) {
        setChangedValue(formController, val);
      },
      value: fieldValue,
    );
  }

  @override
  Future<List<BoringChoiceItem<T>>> onObservedFieldsChange(
          BoringFormController formController) =>
      getItems;

  @override
  void onSelfChange(BoringFormController formController, T? fieldValue) {}
}
