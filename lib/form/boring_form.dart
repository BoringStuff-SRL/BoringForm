// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/field_change_notification.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:boring_form/fields_group.dart/boring_fields_group.dart';
import 'package:flutter/material.dart';

class BoringForm extends BoringFieldsGroup<BoringFormController> {
  BoringForm(
      {super.key,
      required BoringFormController formController,
      super.onChanged,
      this.title,
      this.style,
      this.haveStepper = false,
      this.includeNotDisplayedInValidation = false,
      required super.fields})
      : super(controller: formController, jsonKey: "") {
    assert(BoringFieldsGroup.checkJsonKey(fields),
        "Conflict error: found duplicate jsonKeys in form");
    if (haveStepper) {
      assert(
          fields.length == 1, "Boring Form with stepper can have only 1 item");
      assert(fields.first.runtimeType == BoringFormStepper);
    }
  }

  final BoringFormStyle? style;
  final double fieldsPadding = 8.0;
  final double sectionPadding = 8.0;
  final String? title;
  final bool includeNotDisplayedInValidation;
  final bool haveStepper;

  void init() {
    updateFilteredFieldsList();
  }

  @override
  void onAnyChanged() {
    // TODO: implement onAnyChanged
    super.onAnyChanged();
    formChanged();
    controller.sendNotification();
  }

  @override
  bool get blockNotificationPropagation => true;

  @override
  Widget buildWidget(BuildContext context,
      BoringFieldsGroupController controller, Widget content) {
    return BoringFormTheme(
      style: style ?? BoringFormStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Text(
              title!,
              style: style?.formTitleStyle,
            ),
          NotificationListener<FieldChangeNotification>(
            onNotification: (notification) {
              onAnyChanged();
              return true;
            },
            child: ChangeNotifierProvider.value(
                value: fieldsListProvider,
                child: Consumer<FieldsListProvider>(
                  builder: (context, value, _) {
                    return Column(
                      children: fields
                          .map((field) => Offstage(
                                offstage: !value.isFieldOnStage(field),
                                child: field,
                              ))
                          .toList(),
                    );
                  },
                )),
          ),
          //...filteredFields(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) => Consumer<BoringFormController>(
        builder: builder,
      ),
    );
  }

  @override
  BoringForm copyWith(
      {BoringFieldController<Map<String, dynamic>>? fieldController,
      void Function(Map<String, dynamic>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      bool? includeNotDisplayedInValidation,
      List<BoringField<dynamic>>? fields,
      BoringFormController? controller}) {
    return BoringForm(
      onChanged: onChanged ?? this.onChanged,
      fields: fields ?? this.fields,
      includeNotDisplayedInValidation: includeNotDisplayedInValidation ??
          this.includeNotDisplayedInValidation,
      formController: controller ?? this.controller,
    );
  }
}
