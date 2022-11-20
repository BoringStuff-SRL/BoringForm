import 'package:boring_form/form/theme/boring_responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'boring_field_controller.dart';

abstract class BoringField<T> extends StatelessWidget {
  BoringField(
      {super.key,
      this.label,
      required this.fieldController,
      this.onChanged,
      this.boringResponsiveSize = const BoringResponsiveSize(),
      required this.jsonKey});

  final BoringFieldController<T> fieldController;
  final void Function(T?)? onChanged;
  final String jsonKey;
  final BoringResponsiveSize boringResponsiveSize;
  final String? label;

  void _onChangedValue() {
    onChanged?.call(fieldController.value);
    onValueChanged(fieldController.value);
  }

  void onValueChanged(T? newValue);

  Widget builder(
    BuildContext context,
    BoringFieldController<T> controller,
    Widget? child,
  );

  @override
  Widget build(BuildContext context) {
    fieldController.addListener(_onChangedValue);
    onValueChanged(fieldController.value);
    return ChangeNotifierProvider(
        create: (context) => fieldController,
        child: Consumer<BoringFieldController<T>>(
          builder: builder,
        ));
  }
}
