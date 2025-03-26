import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringDropdownMultiChoiceField<V, T>
    extends BFormFieldAsync<List<V>, List<T>> {
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
    super.responsiveSize,
  });

  final Future<List<T>> Function(String search) getItems;
  final BChoiceItem<V> Function(T) toBoringChoiceItem;
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
    List<V>? fieldValue,
    FieldValidation fieldValidation,
    List<T>? computedValue,
  ) {
    final dropdownStyle =
        boringDropdownStyle ?? BoringTheme.of(context).bDropdownTheme;

    return BDropdownMultiChoice<V, T>(
      value: fieldValue ?? [],
      valueNotifier: ValueNotifier([]),
      searchItems: (searchedValue) async {
        return computedValue ?? <T>[];
      },
      onChanged: (values) => setChangedValue(formController, values),
      readOnly: fieldValidation.isReadOnly,
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
      elemToValue: (T elem) => toBoringChoiceItem(elem).value,
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
    return const BShimmer(child: BSkeleton.custom(child: Text("loading")));
  }
}
