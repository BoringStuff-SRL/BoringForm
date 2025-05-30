import 'dart:async';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/cupertino.dart';

typedef EditCallback<T> = Future<T?> Function(BuildContext context, T item);
typedef DeleteCallback<T> = void Function(BuildContext context, T item);
typedef AddCallback<T> = Future<T?> Function(BuildContext context);

typedef WidgetBuilder<T> = Widget Function(
  BuildContext context,
  List<T> items,
  ItemBuilder<T> itemBuilder,
  FutureOr<void> Function() handleAdd,
  FutureOr<void> Function(T item) handleEdit,
  FutureOr<void> Function(T item) handleDelete,
);

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T item,
  bool readOnly,
  EditCallback<T> onEdit,
  DeleteCallback<T> onDelete,
);

class BMultiElementFormField<T> extends BFormField<List<T>> {
  BMultiElementFormField({
    required super.fieldPath,
    required this.onAdd,
    required this.onEdit,
    required this.itemBuilder,
    super.onChanged,
    super.required,
    super.readOnly,
    this.title,
    this.additionalActions,
    super.validationFunction,
    WidgetBuilder<T>? builder,
    super.key,
    this.unique = true,
    FutureOr<bool> Function()? showAddButton,
  })  : _builder = builder,
        showAddButton = showAddButton ?? (() async => true);

  final FutureOr<bool> Function() showAddButton;

  /// wether or not the added element is unique in the list
  /// true -> if the users inserts the same element twice, it will not be added
  final bool unique;
  final String? title;
  final Future<T?> Function(BuildContext context) onAdd;
  final EditCallback<T> onEdit;
  final List<Widget>? additionalActions;
  final ItemBuilder<T> itemBuilder;
  final WidgetBuilder<T>? _builder;

  Future<void> _handleAdd(
    BuildContext context,
    BFormController formController,
    List<T> fieldValue,
  ) async {
    final result = await onAdd(context);
    if (result == null) return;

    if (unique && fieldValue.contains(result)) return;

    setChangedValue(formController, [
      ...fieldValue,
      result,
    ]);
  }

  Future<void> _handleEdit(
    BuildContext context,
    BFormController formController,
    List<T> fieldValue,
    T oldItem,
  ) async {
    final result = await onEdit(context, oldItem);
    if (result == null) return;
    final indexOfOldItem = fieldValue.indexOf(oldItem);
    if (indexOfOldItem == -1) return;
    final newValue = List<T>.from(fieldValue);
    newValue[indexOfOldItem] = result;
    setChangedValue(
      formController,
      newValue,
    );
  }

  Future<void> _handleRemove(
    BFormController formController,
    List<T> fieldValue,
    T removedItem,
  ) async {
    final result = List<T>.from(fieldValue);

    result.remove(removedItem);

    setChangedValue(
      formController,
      result,
    );
  }

  @override
  void onSelfChange(BFormController formController, List<T>? fieldValue) {}

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    List<T>? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    if (_builder != null) {
      return _builder.call(
        context,
        fieldValue ?? [],
        itemBuilder,
        (() async {
          await _handleAdd(context, formController, fieldValue ?? []);
        }),
        ((item) async {
          await _handleEdit(context, formController, fieldValue ?? [], item);
        }),
        ((item) async {
          await _handleRemove(formController, fieldValue ?? [], item);
        }),
      );
    }

    final cardTheme = BoringTheme.of(context).bCardTheme;

    final errorCardTheme = cardTheme.copyWith(
      bCardDecoration: cardTheme.bCardDecoration.copyWith(
        border: Border.all(
          color: BColor.error.toColorFromContext(context),
        ),
      ),
    );

    final error = fieldValidation.error;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BCard(
          bCardTheme: error != null ? errorCardTheme : null,
          header: BCardHeader(
            title: title,
            actions: [
              ...(additionalActions ?? []),
              if (!readOnly)
                BFutureBuilder(
                  future: () async => showAddButton(),
                  loader: BSkeleton.text(),
                  builder: (context, snapshot) {
                    if (snapshot.data ?? false) {
                      return BButton(
                        onPressed: () async {
                          _handleAdd(context, formController, fieldValue ?? []);
                        },
                        text: "Aggiungi",
                        leadingIcon: const BIcon(BIcons.add),
                      );
                    }
                    return Container();
                  },
                ),
            ],
          ),
          content: (fieldValue?.isEmpty ?? true)
              ? Center(
                  child: Text("Nessun elemento presente."),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => itemBuilder(
                    context,
                    index,
                    fieldValue[index],
                    readOnly,
                    (context, item) async {
                      _handleEdit(
                        context,
                        formController,
                        fieldValue,
                        fieldValue[index],
                      );
                      return null;
                    },
                    (context, item) {
                      _handleRemove(formController, fieldValue, item);
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  itemCount: fieldValue!.length,
                ),
        ),
        if (error != null) ...[
          BText(error, color: BColor.error),
          const SizedBox(height: 5),
        ],
      ],
    );
  }
}
