import 'package:boring_form/field/bform_field.dart';
import 'package:boring_form/form/bform_controller.dart';
import 'package:boring_ui/bui/theme/components_themes/form/boring_form_style.dart';
import 'package:flutter/material.dart';

class BoringChipField<T> extends BFormField<List<T>> {
  BoringChipField({
    super.key,
    required super.fieldPath,
    required this.elements,
    required this.toLabel,
    this.toTooltip,
    super.onChanged,
    super.readOnly,
    this.canRemoveSelection,
  });

  final List<T> elements;
  final Widget Function(T element) toLabel;
  final String Function(T element)? toTooltip;
  final bool Function(BFormController formController, T element)?
      canRemoveSelection;

  @override
  Widget fieldBuilder(
      BuildContext context,
      BoringFormStyle formStyle,
      BFormController formController,
      List<T>? fieldValue,
      FieldValidation fieldValidation,
      void computedValue,
      bool readOnly) {
    const spacing = 5.0;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: elements.map(
        (e) {
          final isSelected = fieldValue?.contains(e) ?? false;
          return InputChip(
            selected: isSelected,
            tooltip: toTooltip?.call(e),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000)),
            label: toLabel(e),
            showCheckmark: false,
            onPressed: () {
              if (readOnly) return;
              if (isSelected) {
                final canRemove =
                    canRemoveSelection?.call(formController, e) ?? true;
                if (!canRemove) return;
                final newList = List<T>.from(fieldValue ?? [])..remove(e);
                setChangedValue(formController, newList);
              } else {
                setChangedValue(formController, [...fieldValue ?? [], e]);
              }
            },
          );
        },
      ).toList(),
    );
  }
}
