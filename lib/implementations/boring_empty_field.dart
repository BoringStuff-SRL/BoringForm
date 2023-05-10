import 'package:boring_form/theme/boring_form_style.dart';
import 'package:flutter/material.dart';

import '../field/boring_field.dart';
import '../field/boring_field_controller.dart';
import '../theme/boring_field_decoration.dart';
import '../theme/boring_form_theme.dart';
import '../theme/boring_responsive_size.dart';

class BoringEmptyWidget extends BoringField {
  BoringEmptyWidget({
    required super.jsonKey,
    super.boringResponsiveSize,
    super.displayCondition,
  });

  @override
  Widget builder(
      BuildContext context, BoringFieldController controller, Widget? child) {
    final BoringFormStyle style = BoringFormTheme.of(context).style;
    return BoringField.boringFieldBuilder(style, "", child: Container());
  }

  @override
  BoringField copyWith(
      {BoringFieldController? fieldController,
      void Function(dynamic p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
