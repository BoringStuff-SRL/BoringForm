// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/fields_group.dart/boring_fields_group.dart';
import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/field_change_notification.dart';
import 'package:boring_form/field/filtered_fields_provider.dart';
import 'package:boring_form/theme/boring_form_style.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:flutter/material.dart';

import 'package:boring_form/form/boring_form_controller.dart';
import 'package:provider/provider.dart';

class BoringForm extends BoringFieldsGroup<BoringFormController> {
  BoringForm(
      {super.key,
      required BoringFormController formController,
      super.onChanged,
      this.title,
      this.style,
      this.includeNotDisplayedInValidation = false,
      required super.fields})
      : assert(BoringFieldsGroup.checkJsonKey(fields),
            "Conflict error: found duplicate jsonKeys in form"),
        super(controller: formController, jsonKey: "");

  final BoringFormStyle? style;
  final double fieldsPadding = 8.0;
  final double sectionPadding = 8.0;
  final String? title;
  final bool includeNotDisplayedInValidation;

  void init() {
    updateFilteredFieldsList();
  }

  @override
  void onAnyChanged() {
    // TODO: implement onAnyChanged
    super.onAnyChanged();
    controller.sendNotification();
    formChanged();
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
            child: ChangeNotifierProvider(
                create: (context) => fieldsListProvider,
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
    return ChangeNotifierProvider(
        create: (context) => controller,
        child: Consumer<BoringFormController>(
          builder: builder,
        ));
  }
}
