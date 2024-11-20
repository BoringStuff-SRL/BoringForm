import 'dart:async';

import 'package:boring_form/field/boring_form_field_with_async_calculations.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoiceField<T>
    extends BoringFormFieldWithAsyncCalculations<List<T>, List<T>> {
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

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<T> Function(T) toBoringChoiceItem;
  final void Function(BoringFormController formController, List<T>? fieldValue)?
      onChanged;

  final FutureOr<List<T>?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<T>>? initialItems;
  final Widget loadingIndicator;
  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formStyle,
      BoringFormController formController,
      List<T>? fieldValue,
      String? error,
      AsyncSnapshot<List<T>> calculations) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdownMultiChoice<T>(
      value: ValueNotifier(fieldValue),
      searchItems: getItems,
      onChanged: (values) => setChangedValue(formController, values),
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
      toDisplay: (T value) => toBoringChoiceItem(value).display,
    );
  }

  @override
  Future<List<T>> onObservedFieldsChange(BoringFormController formController) =>
      getItems("");

  @override
  void onSelfChange(BoringFormController formController, List<T>? fieldValue) {}
}
