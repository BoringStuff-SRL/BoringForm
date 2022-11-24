// ignore_for_file: overridden_fields

import 'package:boring_form/form/boring_form.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/section/boring_section_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/utils/expansion_card.dart';
import 'package:flutter/material.dart';

class BoringSection extends BoringField<Map<String, dynamic>> {
  BoringSection(
      {super.key,
      required this.fieldController,
      required super.jsonKey,
      super.onChanged,
      String? title,
      this.collapsible = false,
      this.collapseOnHeaderTap,
      super.decoration,
      required this.fields})
      : assert(BoringForm.checkJsonKey(fields),
            "Confict error: found duplicate jsonKeys in section with jsonKey '$jsonKey'"),
        assert(collapseOnHeaderTap == null ||
            collapseOnHeaderTap == false ||
            collapsible),
        super(fieldController: fieldController) {
    addFieldsListeners();
  }

  @override
  covariant BoringSectionController fieldController;

  final List<BoringField> fields;
  final double fieldsPadding = 0.0;
  final double sectionPadding = 0;
  final bool collapsible;
  final bool? collapseOnHeaderTap;

  void updateControllerValue() {
    Map<String, dynamic> mappedValues = {};
    for (var field in fields) {
      mappedValues[field.jsonKey] = field.fieldController.value;
    }
    fieldController.setValueSilently(mappedValues);
    onChanged?.call(mappedValues);
  }

  void onAnyChanged() {
    updateControllerValue();
  }

  void addFieldsListeners() {
    for (var field in fields) {
      fieldController.subControllers[field.jsonKey] = field.fieldController;
      field.fieldController.addListener(onAnyChanged);
    }
  }

  Widget _sectionContent() => LayoutBuilder(
        builder: (context, constraints) => Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(fields.length, (index) {
            return FractionallySizedBox(
              widthFactor: fields[index]
                      .boringResponsiveSize
                      .breakpointValue(constraints.maxWidth) /
                  12,
              child: Padding(
                padding: EdgeInsets.all(fieldsPadding),
                child: fields[index],
              ),
            );
          }),
        ),
      );

  @override
  Widget builder(context, controller, child) {
    if (decoration?.label != null) {
      return Padding(
        padding: EdgeInsets.all(sectionPadding),
        child: BoringExpandable(
          header: (toggleExpansion, animation) => ListTile(
            onTap: (collapseOnHeaderTap == true ||
                    (collapsible && collapseOnHeaderTap == null))
                ? () => toggleExpansion()
                : null,
            dense: true,
            title: Text(
              (decoration?.label)!,
              style: BoringFormTheme.of(context).style.sectionTitleStyle,
            ),
            trailing: collapsible
                ? IconButton(
                    splashRadius: 16,
                    icon: const Icon(Icons.expand_more),
                    onPressed: () => toggleExpansion(),
                  )
                : null,
          ),
          child: (toggleExpansion, animation) => _sectionContent(),
        ),
      );
    }
    return _sectionContent();
  }

  @override
  void onValueChanged(Map<String, dynamic>? newValue) {
    for (var field in fields) {
      field.fieldController.value =
          (newValue != null && newValue.containsKey(field.jsonKey))
              ? newValue[field.jsonKey]
              : null;
    }
  }
}
