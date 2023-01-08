import 'package:boring_form/boring_form.dart';

class BoringEmailField extends BoringTextRegExpField {
  BoringEmailField(
      {super.key,
      BoringFieldController<String>? fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      super.displayCondition,
      required String invalidEmailMessage,
      super.decoration})
      : super(
          regExp: RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'),
          regExpError: invalidEmailMessage,
        );
}
