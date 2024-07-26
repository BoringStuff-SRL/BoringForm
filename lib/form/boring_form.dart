// ignore_for_file: public_member_api_docs, sort_constructors_first, overridden_fields, must_be_immutable
import 'package:boring_form/theme/boring_form_theme.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension on List<String> {
  List<List<String>> nest(String splitter) =>
      map((e) => e.split(splitter)).toList();
}

class BoringForm extends BoringFormWidget {
  BoringForm(
      {super.key,
      BoringFormController? formController,
      super.style,
      required Widget child})
      : _child = child,
        super(formController: formController);

  BoringForm.responsive({
    super.key,
    BoringFormController? formController,
    required List<Widget> children,
    BResponsiveSize responsiveSize = const BResponsiveSize.defaultSizes(),
    super.style,
  })  : _child = BResponsiveWrap.automatic(
          responsiveSize: responsiveSize,
          children: children,
        ),
        super(formController: formController);

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
  Widget child(context) => BResponsiveWrap(
        children: children
            .map(
              (e) => e is BResponsiveChild
                  ? e
                  : BResponsiveChild.size(
                      responsiveSize: _responsiveSize,
                      child: e,
                    ),
            )
            .toList(),
      );
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

    return FocusTraversalGroup(
      child: BoringFormTheme(
        style: formStyle,
        child: ChangeNotifierProvider.value(
          value: formController,
          child: child(context),
        ),
      ),
    );
  }
}

class BoringFormChildWidget extends StatelessWidget {
  final List<List<String>> observedFields;
  final bool observeAllFields;
  final Widget Function(BuildContext context,
          BoringFormController formController /*TODO expose changed fields*/)?
      _builder;

  final FieldPath? childFieldPath;
  final Widget Function(
      BuildContext context,
      BoringFormController formController,
      FieldPath childFieldPath)? _withChildFieldPathBuilder;

  const BoringFormChildWidget(
      {super.key,
      this.observedFields = const [],
      required Widget Function(
        BuildContext context,
        BoringFormController formController,
      ) builder,
      this.observeAllFields = false})
      : childFieldPath = null,
        _withChildFieldPathBuilder = null,
        _builder = builder;

  const BoringFormChildWidget.withChildFieldPath(
      {super.key,
      this.observedFields = const [],
      required Widget Function(
        BuildContext context,
        BoringFormController formController,
        FieldPath childFieldPath,
      ) builder,
      required this.childFieldPath,
      this.observeAllFields = false})
      : _withChildFieldPathBuilder = builder,
        _builder = null;
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
      final formController =
          Provider.of<BoringFormController>(context, listen: false);

      if (_withChildFieldPathBuilder != null) {
        formController.setFieldValue(childFieldPath!, null);
        formController.removeValidationFunction(childFieldPath!);
        return _withChildFieldPathBuilder(
            context, formController, childFieldPath!);
      }

      return _builder!.call(context, formController);
    });
  }
}

typedef DecorationBuilder<T> = BoringFieldDecoration<T>? Function(
    BoringFormController formController);
