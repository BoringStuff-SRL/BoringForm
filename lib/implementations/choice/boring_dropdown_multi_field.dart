import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoiceField<T>
    extends BoringFormFieldWithAsyncCalculations<List<T>,
        List<BChoiceItem<T>>> {
  const BoringDropdownMultiChoiceField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    required this.toBoringChoiceItem,
    this.onChanged,
    this.onAdd,
    this.loadingIndicator = const CircularProgressIndicator(),
    this.clearable = true,
    this.searchable = true,
    this.callFutureOnStopWriting = true,
    this.boringDropdownStyle,
    this.boringDropdownLoadingMode = BDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
  });

  final Future<List<BChoiceItem<T>>> Function(String search) getItems;
  final BChoiceItem<T> Function(T) toBoringChoiceItem;
  final void Function(BoringFormController formController, List<T>? fieldValue)?
      onChanged;

  final FutureOr<List<BChoiceItem<T>>?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<BChoiceItem<T>>>? initialItems;
  final Widget loadingIndicator;
  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formStyle,
      BoringFormController formController,
      List<T>? fieldValue,
      String? error,
      AsyncSnapshot<List<BChoiceItem<T>>> calculations) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdownMultiChoice(
      value: ValueNotifier(
          (fieldValue ?? []).map((e) => toBoringChoiceItem(e)).toList()),
      searchItems: getItems,
      onChanged: (values) =>
          setChangedValue(formController, values?.map((e) => e.value).toList()),
      readOnly: isReadOnly(formStyle),
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: dropdownStyle.copyWith(
          inputDecoration:
              getInputDecoration(formController, formStyle, error, fieldValue),
          onClearIcon: formStyle.eraseValueWidget,
          choiceItemDisplayTextStyle: formStyle.textStyle),
      clearable: clearable,
      errorMessage: error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
    );
  }

  @override
  Future<List<BChoiceItem<T>>> onObservedFieldsChange(
          BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, List<T>? fieldValue) {}
}
