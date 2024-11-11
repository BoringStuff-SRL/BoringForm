import 'dart:async';

import 'package:boring_form/implementations/pickers/rrule_field/boring_rrule_form.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:rrule/rrule.dart';

class BoringRRuleDialog extends BDialogInfo {
  BoringRRuleDialog({RecurrenceRule? rrule})
      : formController = rrule == null
            ? BoringRRuleFormController()
            : BoringRRuleFormController.fromRRule(rrule);

  final BoringRRuleFormController formController;

  @override
  double get maxWidth => 400;

  @override
  String get confirmButtonText => "Seleziona";

  @override
  Widget get content => BoringRRuleForm(formController: formController);

  @override
  FutureOr<void> onConfirm(BuildContext context) {
    if (formController.isValid) {
      BDialog.pop(context, result: formController.rrule);
    }
  }
}
