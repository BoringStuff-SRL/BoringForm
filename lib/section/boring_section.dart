// ignore_for_file: overridden_fields

import 'package:boring_form/field/boring_field.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:boring_form/fields_group.dart/boring_fields_group.dart';
import 'package:boring_form/form/boring_form_controller.dart';
import 'package:boring_form/section/boring_section_controller.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:boring_form/utils/expansion_card.dart';
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
      this.startExpanded = true,
      super.autoValidate = false,
      super.decoration,
      super.displayCondition,
      required super.fields})
      : assert(collapseOnHeaderTap == null ||
            collapseOnHeaderTap == false ||
            collapsible),
        super(controller: sectionController ?? BoringSectionController());

  final bool collapsible;
  final bool? collapseOnHeaderTap;
  final bool startExpanded;

  void _formChanged() {
    updateFilteredFieldsList();
  }

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
    formController.removeListener(_formChanged);
    formController.addListener(_formChanged);
    contextHolder.value = context;
  }

  Widget _wrap({required BuildContext context, required Widget child}) {
    final formStyle = BoringFormTheme.of(context).style;
    return Container(
      padding: formStyle.sectionPadding,
      decoration: formStyle.sectionBoxDecoration,
      margin: formStyle.sectionMargin,
      child: child,
    );
  }

  @override
  Widget buildWidget(BuildContext context,
      BoringFieldsGroupController controller, Widget content) {
    _setFormContext(context);

    return _wrap(
      context: context,
      child: (decoration?.label != null)
          ? BoringExpandable(
              startExpanded: startExpanded,
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
            )
          : content,
    );
  }

  @override
  BoringSection copyWith(
      {BoringFieldController<Map<String, dynamic>>? fieldController,
      void Function(Map<String, dynamic>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      BoringSectionController? sectionController,
      bool? collapsible,
      bool? collapseOnHeaderTap,
      bool? autoValidate,
      List<BoringField<dynamic>>? fields}) {
    return BoringSection(
      jsonKey: jsonKey ?? this.jsonKey,
      autoValidate: autoValidate ?? this.autoValidate,
      decoration: decoration ?? this.decoration,
      onChanged: onChanged ?? this.onChanged,
      displayCondition: displayCondition ?? this.displayCondition,
      collapseOnHeaderTap: collapseOnHeaderTap ?? this.collapseOnHeaderTap,
      collapsible: collapsible ?? this.collapsible,
      fields: fields ?? this.fields,
      sectionController: sectionController,
    );
  }
}
