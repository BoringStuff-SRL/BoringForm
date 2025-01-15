part of 'boring_duration_field.dart';

class _BoringDurationDialogFormController extends BoringFormController {
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
    required List<DurationField>? fieldsToShow,
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
                content: BResponsiveWrap.automatic(
                  bResponsiveTheme: const BResponsiveTheme(spacing: 0),
                  responsiveSize: const BResponsiveSize(xs: 4),
                  children: [
                    BoringNumberField(
                      fieldPath: const ['years'],
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.yearsString(2)),
                    ),
                    BoringNumberField(
                      fieldPath: const ['months'],
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.monthsString(2)),
                    ),
                    BoringNumberField(
                      fieldPath: const ['days'],
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
                content: BResponsiveWrap.automatic(
                  bResponsiveTheme: const BResponsiveTheme(spacing: 0),
                  responsiveSize: const BResponsiveSize(xs: 6),
                  children: [
                    BoringNumberField(
                      fieldPath: const ['hours'],
                      decoration: (formController) => BoringFieldDecoration(
                          label: durationFieldTheme.hoursString(2)),
                    ),
                    BoringNumberField(
                      fieldPath: const ['minutes'],
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
