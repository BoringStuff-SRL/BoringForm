import 'package:boring_form/boring_form.dart';

class BoringTextRegExpField extends BoringTextField {
  BoringTextRegExpField(
      {super.key,
      BoringFieldController<String>? fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      required String regExpError,
      super.displayCondition,
      required RegExp regExp,
      super.decoration})
      : super(
            fieldController:
                (fieldController ?? BoringFieldController<String>()).copyWith(
          validationFunction: (value) {
            if (value == null || value.isEmpty || !regExp.hasMatch(value)) {
              return regExpError;
            }
            return fieldController?.validationFunction?.call(value);
          },
        ));
}
