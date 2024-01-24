import 'package:boring_form/implementations/text/boring_text_regex.dart';

class BoringPhoneNumberField extends BoringTextRegExpField {
  BoringPhoneNumberField({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    super.maxLines,
    super.minLines,
    super.allowEmpty,
    required String invalidPhoneMessage,
  }) : super(
          regExp: RegExp(
              r'^(\+\d{1,3}\s?)?1?\-?\.?\s?\(?\d{2,4}\)?[\s.-]?\d{2,4}[\s.-]?\d{2,4}$'),
          regExpError: invalidPhoneMessage,
        );
}
