import 'package:boring_form/boring_form.dart';

class BoringPhoneNumberField extends BoringTextRegExpField {
  BoringPhoneNumberField(
      {super.key,
      BoringFieldController<String>? fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      required String invalidPhoneMessage,
      super.decoration})
      : super(
          regExp: RegExp(
              r'/^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$'),
          regExpError: invalidPhoneMessage,
        );
}
