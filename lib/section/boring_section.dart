// ignore_for_file: overridden_fields

import 'dart:developer';

import 'package:boring_form/fields_group.dart/boring_fields_group.dart';
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

class BoringSection extends BoringFieldsGroup {
  // BoringField<Map<String, dynamic>> {
  BoringSection(
      {super.key,
      BoringSectionController? sectionController,
      required super.jsonKey,
      super.onChanged,
      this.collapsible = false,
      this.collapseOnHeaderTap,
      super.decoration,
      super.displayCondition,
      required super.fields})
      : assert(collapseOnHeaderTap == null ||
            collapseOnHeaderTap == false ||
            collapsible),
        super(controller: sectionController ?? BoringSectionController());

  final double sectionPadding = 0;
  final bool collapsible;
  final bool? collapseOnHeaderTap;

  // Widget _sectionContent() => LayoutBuilder(
  //       builder: (context, constraints) =>
  //           NotificationListener<FieldChangeNotification>(
  //         onNotification: (notification) {
  //           onAnyChanged();
  //           return false;
  //         },
  //         child: ChangeNotifierProvider(
  //             create: (context) => fieldsListProvider,
  //             child: Consumer<FieldsListProvider>(
  //                 builder: (context, value, _) => Wrap(
  //                       crossAxisAlignment: WrapCrossAlignment.center,
  //                       children: List.generate(fields.length, (index) {
  //                         return Offstage(
  //                           offstage: !fieldsListProvider
  //                               .isFieldOnStage(fields[index]),
  //                           child: FractionallySizedBox(
  //                             widthFactor: fields[index]
  //                                     .boringResponsiveSize
  //                                     .breakpointValue(constraints.maxWidth) /
  //                                 12,
  //                             child: Padding(
  //                               padding: EdgeInsets.all(fieldsPadding),
  //                               child: fields[index],
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ))),
  //       ),
  //     );

  //Updates the context on every build
  //to retrieve the form controller
  void _setFormContext(BuildContext context) {
    BoringFormController formController =
        Provider.of<BoringFormController>(context);
    formController.removeListener(formChanged);
    formController.addListener(formChanged);
    contextHolder.value = context;
  }

  @override
  Widget buildWidget(BuildContext context,
      BoringFieldsGroupController controller, Widget content) {
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
          child: (toggleExpansion, animation) => content,
        ),
      );
    }
    return content;
  }
}
