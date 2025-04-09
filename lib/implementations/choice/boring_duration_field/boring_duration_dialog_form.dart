part of 'boring_duration_field.dart';

class _BoringDurationDialogFormController extends BFormController {
  _BoringDurationDialogFormController({BoringDurationDataHandler? dataHandler})
      : super(initialValue: dataHandler?.toMap());

  BoringDurationDataHandler get dataHandler =>
      BoringDurationDataHandler.fromMap(value);
}

class _BoringDurationDialogForm extends BoringFormWidget {
  _BoringDurationDialogForm({
    super.key,
    required super.formController,
    required this.durationFieldTheme,
    List<DurationField>? fieldsToShow,
  }) : fieldsToShow = fieldsToShow ?? DurationField.values;

  final BDurationFieldTheme durationFieldTheme;
  //If empty will be considered full
  final List<DurationField> fieldsToShow;

  @override
  Widget child(BuildContext context) {
    final bCardTheme = BoringTheme.of(context).bCardTheme;

    final overriddenTheme = bCardTheme.copyWith(
      bCardDecoration: bCardTheme.bCardDecoration.copyWith(boxShadow: []),
    );

    if (fieldsToShow.isEmpty) fieldsToShow.addAll(DurationField.values);
    final dateFields = fieldsToShow.contains(DurationField.dateFields);
    final timeFields = fieldsToShow.contains(DurationField.timeFields);

    return BColumn(
      separator: const SizedBox(height: 20),
      children: [
        dateFields
            ? BCard(
                bCardTheme: overriddenTheme,
                content: BWrap(
                  spacing: 0,
                  // defaultSize: const BResponsiveSize(xs: 4), //TODO responsive
                  children: [
                    BoringNumberField(
                      responsiveSize: const BResponsiveSize(xs: 4),
                      fieldPath: const ['years'],
                      required: false,
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.yearsString(2)),
                    ),
                    BoringNumberField(
                      responsiveSize: const BResponsiveSize(xs: 4),
                      fieldPath: const ['months'],
                      required: false,
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.monthsString(2)),
                    ),
                    BoringNumberField(
                      responsiveSize: const BResponsiveSize(xs: 4),
                      fieldPath: const ['days'],
                      required: false,
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.daysString(2)),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        timeFields
            ? BCard(
                bCardTheme: overriddenTheme,
                content: BWrap(
                  spacing: 0,
                  // defaultSize: const BResponsiveSize(xs: 6), //TODO responsive
                  children: [
                    BoringNumberField(
                      responsiveSize: const BResponsiveSize(xs: 6),
                      fieldPath: const ['hours'],
                      required: false,
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.hoursString(2)),
                    ),
                    BoringNumberField(
                      responsiveSize: const BResponsiveSize(xs: 6),
                      fieldPath: const ['minutes'],
                      required: false,
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.minutesString(2)),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
