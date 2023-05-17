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
              r'^(\+\d{1,3}\s?)?1?\-?\.?\s?\(?\d{2,4}\)?[\s.-]?\d{2,4}[\s.-]?\d{2,4}$'),
          regExpError: invalidPhoneMessage,
        );
}
