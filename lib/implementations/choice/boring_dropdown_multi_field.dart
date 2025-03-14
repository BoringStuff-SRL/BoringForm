import 'dart:async';

import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoiceField<T>
    extends BFormFieldAsync<List<T>, List<T>> {
  BoringDropdownMultiChoiceField({
    super.key,
    required super.fieldPath,
    required this.getItems,
    super.decoration,
    super.observedFields,
    super.readOnly,
    super.validationFunction,
    required this.toBoringChoiceItem,
    super.onChanged,
    this.onAdd,
    this.loadingIndicator = const CircularProgressIndicator(),
    this.clearable = true,
    this.searchable = true,
    this.callFutureOnStopWriting = true,
    this.boringDropdownStyle,
    this.boringDropdownLoadingMode = BDropdownLoadingMode.onOpen,
    this.debouncingTime = const Duration(milliseconds: 300),
    this.initialItems,
    super.required,
  });

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<T> Function(T) toBoringChoiceItem;
  final FutureOr<T?> Function(String)? onAdd;
  final bool callFutureOnStopWriting;
  final bool searchable;
  final BDropdownTheme? boringDropdownStyle;
  final BDropdownLoadingMode boringDropdownLoadingMode;
  final bool clearable;
  final Duration debouncingTime;
  final AsyncSnapshot<List<T>>? initialItems;
  final Widget loadingIndicator;

  @override
  Widget fieldBuilder(
      BuildContext context,
      BoringFormStyle formStyle,
      BoringFormController formController,
      List<T>? fieldValue,
      FieldValidation fieldValidation,
      List<T>? computedValue,
      bool readOnly) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdownMultiChoice<T>(
      value: ValueNotifier(fieldValue),
      searchItems: (searchedValue) async {
        return computedValue ?? <T>[];
      },
      onChanged: (values) => setChangedValue(formController, values),
      readOnly: readOnly,
      onAdd: onAdd,
      callFutureOnStopWriting: callFutureOnStopWriting,
      boringDropdownLoadingMode: boringDropdownLoadingMode,
      searchable: searchable,
      boringDropdownStyle: dropdownStyle.copyWith(
          inputDecoration: getInputDecoration(
              formController, formStyle, fieldValue, fieldValidation),
          onClearIcon: formStyle.eraseValueWidget,
          choiceItemDisplayTextStyle: formStyle.textStyle),
      clearable: clearable,
      errorMessage: fieldValidation.error,
      debouncingTime: debouncingTime,
      initialItems: initialItems,
      loadingIndicator: loadingIndicator,
      toDisplay: (T value) => toBoringChoiceItem(value).display,
    );
  }

  @override
  Future<List<T>?> asyncComputations(Map<FieldPath, dynamic> observedValues) {
    return getItems("");
  }

  @override
  Widget onError(BuildContext context) {
    return const Text("ERRORE!");
  }

  @override
  Widget onLoading(BuildContext context) {
    return BShimmer(child: BSkeleton.custom(child: Text("loading")));
  }
}
