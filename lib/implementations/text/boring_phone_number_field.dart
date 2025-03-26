import 'package:boring_form/implementations/text/boring_text_regex.dart';

class BoringPhoneNumberField extends BoringTextRegExpField {
  BoringPhoneNumberField({
    super.key,
    super.minLines = 1,
    super.maxLines = 1,
    super.required,
    super.responsiveSize,
    required super.fieldPath,
    super.observedFields,
    super.decoration,
    super.onChanged,
    super.readOnly,
    super.validationFunction,
    required String invalidPhoneMessage,
    //
    super.mustMatch,
  }) : super(
          regExp: RegExp(
              r'^(\+\d{1,3}\s?)?1?\-?\.?\s?\(?\d{2,4}\)?[\s.-]?\d{2,4}[\s.-]?\d{2,4}$'),
          regExpError: invalidPhoneMessage,
        );
}
