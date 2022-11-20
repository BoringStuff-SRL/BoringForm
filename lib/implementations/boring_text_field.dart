import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:flutter/material.dart';

class BoringTextField extends BoringField<String> {
  BoringTextField({
    super.key,
    required super.fieldController,
    super.onChanged,
    required super.jsonKey,
    super.boringResponsiveSize,
    super.label,
  });

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget builder(context, controller, child) {
    final style = BoringFormTheme.of(context).style;

    return Padding(
      padding: style.fieldsPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (style.labelOverField && label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Text(
                label!,
                style: style.inputDecoration.labelStyle,
              ),
            ),
          TextField(
            controller: textEditingController,
            decoration: style.inputDecoration.copyWith(
                errorText: controller.errorMessage,
                label: !style.labelOverField
                    ? Text(
                        label!,
                        style: style.inputDecoration.labelStyle,
                      )
                    : null), // InputDecoration(
            // ),
            onChanged: ((value) {
              controller.value = value;
            }),
          ),
        ],
      ),
    );
  }

  @override
  void onValueChanged(String? newValue) {
    if (newValue != textEditingController.text) {
      textEditingController.text = newValue ?? '';
    }
  }
}
