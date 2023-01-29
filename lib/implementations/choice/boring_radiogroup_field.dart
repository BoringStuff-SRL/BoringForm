import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

class BoringChoiceItem<T> {
  const BoringChoiceItem({required this.display, required this.value});
  final String display;
  final T? value;
}

class BoringRadioGroupField<T> extends BoringField<T> {
  BoringRadioGroupField(
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
                      child: RadioListTile(
                          activeColor: style.inputDecoration.focusColor,
                          contentPadding: style.inputDecoration.contentPadding,
                          value: item.value,
                          title: Text(item.display),
                          groupValue: fieldController.value,
                          onChanged: (value) => fieldController.value = value),
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
