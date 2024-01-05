// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/boring_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension on List<String> {
  List<List<String>> nest(String splitter) =>
      map((e) => e.split(splitter)).toList();
}

class BoringForm extends StatelessWidget {
  final BoringFormController formController;
  final Widget child;
  final BoringFormStyle? style;
  BoringForm(
      {super.key,
      BoringFormController? formController,
      required this.child,
      this.style})
      : formController = formController ?? BoringFormController();

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: BoringFormTheme(
          style: style ?? BoringFormStyle(),
          child: ChangeNotifierProvider.value(
            value: formController,
            child: child,
          )),
    );
  }
}

class BoringFormChildWidget extends StatelessWidget {
  final List<List<String>> observedFields;
  final bool observeAllFields;
  final Widget Function(BuildContext context,
          BoringFormController formController /*TODO expose changed fields*/)
      builder;

  const BoringFormChildWidget(
      {super.key,
      this.observedFields = const [],
      required this.builder,
      this.observeAllFields = false});
  // BoringFormChildWidget.plain(
  //     {super.key,
  //     List<String> observedFields = const [],
  //     required this.builder})
  //     : observedFields = observedFields.nest(NESTING_CHAR);

  @override
  Widget build(BuildContext context) {
    return Selector<BoringFormController, List<dynamic>>(
        selector: (_, formController) {
      return observeAllFields
          ? [
              false,
              ...formController.valuePlain.entries.map((e) => e.value).toList()
            ]
          : formController.selectPaths(observedFields, includeError: false);
    }, builder: (context, _, __) {
      // final formController = context.read<BoringFormController>();
      final formController =
          Provider.of<BoringFormController>(context, listen: false);
      return builder(context, formController);
    });
  }
}

typedef DecorationBuilder<T> = BoringFieldDecoration<T>? Function(
    BoringFormController formController);
