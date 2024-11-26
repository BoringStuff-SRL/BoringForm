import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/cupertino.dart';

class BoringDeferredField<L extends Listenable, T> extends StatelessWidget {
  const BoringDeferredField({
    super.key,
    required this.fieldPath,
    required this.builder,
  });

  static String deferredLoaderFieldPath(FieldPath childPath) =>
      "${childPath.join('_')}_DEFERRED_LOADER";

  final FieldPath fieldPath;
  final Widget Function(FieldPath fieldPath) builder;

  @override
  Widget build(BuildContext context) {
    final formController = BoringFormController.of(context);

    final deferredValue =
        formController.getDeferredValue(fieldPath) as DeferredValue<L, T>?;

    if (deferredValue == null) return builder(fieldPath);

    final deferredLoaderPath = deferredLoaderFieldPath(fieldPath);

    return BoringRxWatcher(
      listenable: deferredValue.listenable,
      selector: deferredValue.selector,
      child: builder(fieldPath),
      builder: (context, child, selected) {
        if (selected.isLoading) {
          return BSkeleton.custom(
            child: BoringTextField(
              allowEmpty: true,
              fieldPath: [deferredLoaderPath],
              readOnly: true,
            ),
          );
        }

        formController.setFieldValue(fieldPath, selected.data, notify: false);

        return child!;
      },
    );
  }
}
