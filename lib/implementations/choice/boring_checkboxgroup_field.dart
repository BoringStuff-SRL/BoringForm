import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

import 'boring_radiogroup_field.dart';

class BoringCheckBoxGroupField<T> extends BoringField<T> {
  BoringCheckBoxGroupField(
      {super.key,
      required super.jsonKey,
      required this.items,
      super.fieldController,
      super.decoration,
      this.itemsPerRow = 1,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final List<BoringChoiceItem<T>> items;
  final int itemsPerRow;

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(decoration?.label ?? ""),
          ),
          Wrap(
            children: items
                .map((item) => FractionallySizedBox(
                      widthFactor: 1 / itemsPerRow,
                      child: CheckboxListTile(
                          activeColor: style.inputDecoration.focusColor,
                          contentPadding: style.inputDecoration.contentPadding,
                          value: (fieldController.value as bool?) ?? false,
                          title: Text(item.display),
                         tristate: true,
                          onChanged: style.readOnly
                              ? null
                              : (value) => fieldController.value = value as T?),
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(decoration?.helperText ?? ""),
          ),
        ],
      ),
    );
  }

  @override
  void onValueChanged(T? newValue) {}
}
