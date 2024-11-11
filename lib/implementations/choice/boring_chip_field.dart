import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/bui/theme/components_themes/form/boring_form_style.dart';
import 'package:flutter/material.dart';

import '../../form/boring_form_controller.dart';

class BoringChipField<T> extends BoringFormField<List<T>> {
  const BoringChipField({
    super.key,
    required this.elements,
    required this.toLabel,
    this.toTooltip,
    required super.fieldPath,
    super.onChanged,
    super.readOnly,
    this.canRemoveSelection,
  });

  final List<T> elements;
  final Widget Function(T element) toLabel;
  final String Function(T element)? toTooltip;
  final bool Function(BoringFormController formController, T element)?
      canRemoveSelection;

  @override
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, List<T>? fieldValue, String? error) {
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
              if (isReadOnly(formStyle)) return;
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

  @override
  void onSelfChange(BoringFormController formController, List<T>? fieldValue) {}
}
