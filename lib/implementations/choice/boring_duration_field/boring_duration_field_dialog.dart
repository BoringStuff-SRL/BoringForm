part of 'boring_duration_field.dart';

class _BoringDurationFieldDialog extends BDialogInfo {
  _BoringDurationFieldDialog({
    required this.durationFieldTheme,
    required this.onSet,
    _BoringDurationDataHandler? dataHandler,
  }) : formController =
            _BoringDurationDialogFormController(dataHandler: dataHandler);

  final BDurationFieldTheme durationFieldTheme;
  final _BoringDurationDialogFormController formController;
  final Function(Duration duration) onSet;

  @override
  String get title => durationFieldTheme.insertDurationString;

  @override
  double get maxWidth => 600;

  @override
  String get confirmButtonText => durationFieldTheme.setString;

  @override
  Widget get content => _BoringDurationDialogForm(
        formController: formController,
        durationFieldTheme: durationFieldTheme,
      );

  @override
  FutureOr<void> onConfirm(BuildContext context) {
    if (formController.isValid) {
      final duration = formController.dataHandler.inDuration;
      onSet(duration);
      BDialog.pop(context);
    }
  }
}
