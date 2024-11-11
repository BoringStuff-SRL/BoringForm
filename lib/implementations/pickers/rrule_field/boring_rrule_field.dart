import 'package:boring_form/implementations/pickers/boring_picker_field.dart';
import 'package:boring_form/implementations/pickers/rrule_field/boring_rrule_dialog.dart';
import 'package:boring_form/implementations/pickers/rrule_field/utils/rrule_l10n_it.dart';
import 'package:rrule/rrule.dart';

class BoringRRuleField extends BoringPickerField<RecurrenceRule> {
  BoringRRuleField({
    super.key,
    required super.fieldPath,
    super.decoration,
    super.forceHideRequiredFieldLabel,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.showEraseValueButton,
    super.validationFunction,
  }) : super(
          valueToString: (value) {
            return value?.toText(l10n: const RruleL10nIt()) ?? "";
          },
          showPicker: (context, formController, fieldValue) async {
            final result =
                await BoringRRuleDialog(rrule: fieldValue).show(context);

            return result;
          },
        );
}
