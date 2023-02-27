import 'package:boring_form/boring_form.dart';

class BoringPhoneNumberField extends BoringTextRegExpField {
  BoringPhoneNumberField(
      {super.key,
      BoringFieldController<String>? fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      super.canEmpty,
      super.displayCondition,
      required String invalidPhoneMessage,
      super.decoration})
      : super(
          regExp: RegExp(
              r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$'),
          regExpError: invalidPhoneMessage,
        );
}
