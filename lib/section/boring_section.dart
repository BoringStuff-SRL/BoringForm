// ignore_for_file: overridden_fields

import 'package:boring_form/field/field_change_notification.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:boring_form/form/boring_form.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/section/boring_section_controller.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/utils/expansion_card.dart';
import 'package:boring_form/utils/value_holder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoringSection extends BoringField<Map<String, dynamic>> {
  BoringSection(
      {super.key,
      BoringSectionController? sectionController,
      required super.jsonKey,
      super.onChanged,
      this.collapsible = false,
      this.collapseOnHeaderTap,
      super.decoration,
      super.displayCondition,
      required this.fields})
      : assert(BoringForm.checkJsonKey(fields),
            "Confict error: found duplicate jsonKeys in section with jsonKey '$jsonKey'"),
        assert(collapseOnHeaderTap == null ||
            collapseOnHeaderTap == false ||
            collapsible),
        super(fieldController: sectionController ?? BoringSectionController()) {
    init();
  }

  final List<BoringField> fields;
  final double fieldsPadding = 0.0;
  final double sectionPadding = 0;
  final bool collapsible;
  final bool? collapseOnHeaderTap;
  final fieldsListProvider = FieldsListProvider();

  void _onAnyChanged() {
    _updateFilteredFieldsList();
    onChanged?.call(fieldController.value);
  }

  void _updateFilteredFieldsList() {
    if (contextHolder.value != null) {
      BoringFormController formController = Provider.of<BoringFormController>(
          contextHolder.value!,
          listen: false);
      fieldsListProvider.notifyIfDifferentFields(
          fields, formController.value ?? {});
    }
  }

  void _formChanged() {
    _updateFilteredFieldsList();
  }

  void addInitialValueToSubFields() {}

  @override
  void setInitalValue(Map<String, dynamic>? val) {
    super.setInitalValue(val);
    for (var field in fields) {
      if (fieldController.initialValue?[field.jsonKey] != null) {
        field.setInitalValue(fieldController.initialValue?[field.jsonKey]);
      }
    }
  }

  void _addFieldsSubcontrollers() {
    for (var field in fields) {
      //so fieldController.value get all values from fields controllers
      (fieldController as BoringSectionController)
          .subControllers[field.jsonKey] = field.fieldController;
    }
  }

  void init() {
    _addFieldsSubcontrollers();
  }

  Widget _sectionContent() => LayoutBuilder(
        builder: (context, constraints) =>
            NotificationListener<FieldChangeNotification>(
          onNotification: (notification) {
            _onAnyChanged();
            return false;
          },
          child: ChangeNotifierProvider(
              create: (context) => fieldsListProvider,
              child: Consumer<FieldsListProvider>(
                  builder: (context, value, _) => Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: List.generate(fields.length, (index) {
                          return Offstage(
                            offstage: !fieldsListProvider
                                .isFieldOnStage(fields[index]),
                            child: FractionallySizedBox(
                              widthFactor: fields[index]
                                      .boringResponsiveSize
                                      .breakpointValue(constraints.maxWidth) /
                                  12,
                              child: Padding(
                                padding: EdgeInsets.all(fieldsPadding),
                                child: fields[index],
                              ),
                            ),
                          );
                        }),
                      ))),
        ),
      );

  @override
  Widget builder(context, controller, child) {
    _setFormContext(context);
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

  //Updates the context on every build
  //to retrieve the form controller
  void _setFormContext(BuildContext context) {
    BoringFormController formController =
        Provider.of<BoringFormController>(context);
    formController.removeListener(_formChanged);
    formController.addListener(_formChanged);

    contextHolder.value = context;
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
