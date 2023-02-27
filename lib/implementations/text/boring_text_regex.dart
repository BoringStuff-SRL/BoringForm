import 'package:boring_form/boring_form.dart';

class BoringTextRegExpField extends BoringTextField {
  BoringTextRegExpField(
      {super.key,
      BoringFieldController<String>? fieldController,
      super.onChanged,
      required super.jsonKey,
      this.canEmpty = false,
      super.boringResponsiveSize,
      required String regExpError,
      super.displayCondition,
      required RegExp regExp,
      super.decoration})
      : super(
            fieldController:
                (fieldController ?? BoringFieldController<String>()).copyWith(
          validationFunction: (value) {
            if (!canEmpty) {
              if (value == null || value.isEmpty || !regExp.hasMatch(value)) {
                return regExpError;
              }
            } else {
              if (value != null && value.isNotEmpty) {
                if (!regExp.hasMatch(value)) {
                  return regExpError;
                }
              }
            }

            return fieldController?.validationFunction?.call(value);
          },
        ));

  final bool canEmpty;
}
