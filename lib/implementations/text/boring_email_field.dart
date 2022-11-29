import 'package:boring_form/boring_form.dart';

class BoringEmailField extends BoringTextField {
  BoringEmailField(
      {super.key,
      required BoringFieldController<String> fieldController,
      super.onChanged,
      required super.jsonKey,
      super.boringResponsiveSize,
      required String invalidEmailMessage,
      super.decoration})
      : super(fieldController: fieldController.copyWith(
          validationFunction: (value) {
            String pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern);
            if (value == null || value.isEmpty || !regex.hasMatch(value)) {
              return invalidEmailMessage;
            }
            return fieldController.validationFunction?.call(value);
          },
        ));
}
