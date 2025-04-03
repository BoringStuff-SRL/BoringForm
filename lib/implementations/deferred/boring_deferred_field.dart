// import 'package:boring_form/form/boring_form_controller.dart';
// import 'package:boring_ui/boring_ui.dart';
// import 'package:flutter/cupertino.dart';

// class DeferredValue<L extends Listenable, T> {
//   DeferredValue({
//     required this.listenable,
//     required this.selector,
//   });

//   final L listenable;
//   final AsyncValue<T> Function(L listenable) selector;

//   AsyncValue<T> get asyncValue => selector(listenable);

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DeferredValue &&
//           runtimeType == other.runtimeType &&
//           listenable == other.listenable &&
//           selector == other.selector;

//   @override
//   int get hashCode => listenable.hashCode ^ selector.hashCode;
// }

// class BoringDeferredField<L extends Listenable, T> extends StatelessWidget {
//   const BoringDeferredField({
//     super.key,
//     required this.fieldPath,
//     required this.builder,
//   });

//   static String deferredLoaderFieldPath(FieldPath childPath) =>
//       "${childPath.join('_')}_DEFERRED_LOADER";

//   final FieldPath fieldPath;
//   final Widget Function(FieldPath fieldPath) builder;

//   @override
//   Widget build(BuildContext context) {
//     final formController = BoringFormController.of(context);

//     final deferredValue =
//         formController.getDeferredValue(fieldPath) as DeferredValue<L, T>?;

//     if (deferredValue == null) return builder(fieldPath);

//     final deferredLoaderPath = deferredLoaderFieldPath(fieldPath);

//     return BoringRxWatcher(
//       listenable: deferredValue.listenable,
//       selector: deferredValue.selector,
//       child: builder(fieldPath),
//       builder: (context, child, selected) {
//         if (selected.isLoading) {
//           return BSkeleton.custom(
//             child: BoringTextField(
//               required: false,
//               fieldPath: [deferredLoaderPath],
//               readOnly: true,
//             ),
//           );
//         }

//         WidgetsBinding.instance.addPostFrameCallback(
//           (timeStamp) {
//             formController.setFieldValue(fieldPath, selected.data,
//                 notify: true);
//           },
//         );

//         return child!;
//       },
//     );
//   }
// }
