part of 'boring_duration_field.dart';

class _BoringDurationDialogFormController extends BoringFormController {
  _BoringDurationDialogFormController({_BoringDurationDataHandler? dataHandler})
      : super(initialValue: dataHandler?.toMap());

  _BoringDurationDataHandler get dataHandler =>
      _BoringDurationDataHandler.fromMap(value);
}

class _BoringDurationDialogForm extends BoringFormWidget {
  _BoringDurationDialogForm({
    super.key,
    required super.formController,
    required this.durationFieldTheme,
  });

  final BDurationFieldTheme durationFieldTheme;

  @override
  Widget child(BuildContext context) {
    final bCardTheme = BoringTheme.of(context).bCardTheme;

    final overriddenTheme = bCardTheme.copyWith(
      bCardDecoration: bCardTheme.bCardDecoration.copyWith(boxShadow: []),
    );

    return Column(
      children: [
        BCard(
          bCardTheme: overriddenTheme,
          content: BResponsiveWrap.automatic(
            bResponsiveTheme: const BResponsiveTheme(spacing: 0),
            responsiveSize: const BResponsiveSize(xs: 4),
            children: [
              BoringNumberField(
                fieldPath: ['years'],
                decoration: (formController) => BoringFieldDecoration(
                    label: durationFieldTheme.yearsString(2)),
              ),
              BoringNumberField(
                fieldPath: ['months'],
                decoration: (formController) => BoringFieldDecoration(
                    label: durationFieldTheme.monthsString(2)),
              ),
              BoringNumberField(
                fieldPath: ['days'],
                decoration: (formController) => BoringFieldDecoration(
                    label: durationFieldTheme.daysString(2)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        BCard(
          bCardTheme: overriddenTheme,
          content: BResponsiveWrap.automatic(
            bResponsiveTheme: const BResponsiveTheme(spacing: 0),
            responsiveSize: const BResponsiveSize(xs: 6),
            children: [
              BoringNumberField(
                fieldPath: ['hours'],
                decoration: (formController) => BoringFieldDecoration(
                    label: durationFieldTheme.hoursString(2)),
              ),
              BoringNumberField(
                fieldPath: ['minutes'],
                decoration: (formController) => BoringFieldDecoration(
                    label: durationFieldTheme.minutesString(2)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
