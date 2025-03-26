// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

// extension on List<String> {
//   List<List<String>> nest(String splitter) =>
//       map((e) => e.split(splitter)).toList();
// }

class BoringForm extends BoringFormWidget {
  BoringForm(
      {super.key, super.formController, super.style, required Widget child})
      : _child = child;

  BoringForm.responsive({
    super.key,
    super.formController,
    required List<Widget> children,
    BResponsiveSize responsiveSize = const BResponsiveSize.defaultSizes(),
    super.style,
  }) : _child = BWrap(
          spacing: 0,
          children: children,
        );

  final Widget _child;

  @override
  Widget child(context) => _child;

  @override
  BoringFormStyle styleManipulator(BoringFormStyle style) => style;
}

abstract class BoringResponsiveFormWidget extends BoringFormWidget {
  BoringResponsiveFormWidget({
    super.key,
    super.formController,
    super.style,
    BResponsiveSize responsiveSize = const BResponsiveSize.defaultSizes(),
  }) : _responsiveSize = responsiveSize;

  final BResponsiveSize _responsiveSize;

  List<Widget> get children;

  @override
  Widget child(context) => BWrap(spacing: 0, children: children);
}

abstract class BoringFormWidget extends StatelessWidget {
  final BoringFormController formController;
  Widget child(BuildContext context);
  final BoringFormStyle Function(BuildContext context)? style;
  BoringFormStyle styleManipulator(BoringFormStyle style) => style;

  BoringFormWidget(
      {super.key, BoringFormController? formController, this.style})
      : formController = formController ?? BoringFormController();

  @override
  Widget build(BuildContext context) {
    final BoringFormStyle formStyle = styleManipulator(
        style?.call(context) ?? BoringTheme.of(context).boringFormStyle);

    return BShimmer(
      child: FocusTraversalGroup(
        child: BoringFormTheme(
          style: formStyle,
          child: BFormControllerProvider(
            formController: formController,
            child: child(context),
          ),
        ),
      ),
    );
  }
}
