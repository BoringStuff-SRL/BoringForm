import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/table/boring_table_field_row.dart';
import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

typedef Bre = BoringTableFieldRow;

class BoringTableFieldController
    extends BoringFieldController<List<Map<String, dynamic>>> {
  List<Map<String, BoringFieldController>> controllers = [];
  void addControllers(List<BoringField> fields);
  void removeControllers(int index);

  @override
  // TODO: implement value
  List<Map<String, dynamic>>? get value => super.value;

  @override
  void setValueSilently(List<Map<String, dynamic>>? newValue) {
    // TODO: implement setValueSilently
    super.setValueSilently(newValue);
  }
}

class RowsListener extends ValueNotifier<List<Bre>> {
  RowsListener(super.value);

  void addValue(BoringTableFieldRow newRow) {
    value.add(newRow);
    notifyListeners();
  }

  void deleteValue(int index) {
    value.removeAt(index);
    notifyListeners();
  }
}

class BoringTableField extends BoringField<List<Map<String, dynamic>>> {
  BoringTableField(
      {super.key,
      super.fieldController,
      super.onChanged,
      required super.jsonKey,
      required List<BoringField> items,
      super.boringResponsiveSize,
      super.displayCondition,
      super.decoration}) {
    this.items = items;
  }

  final _tableRows = RowsListener([]);

  late final List<BoringField> items;

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);

    return BoringField.boringFieldBuilder(style, decoration?.label,
        child: SizedBox(
          height: 600,
          child: ValueListenableBuilder(
            valueListenable: _tableRows,
            builder:
                (BuildContext context, List<Bre> tableRows, Widget? child) {
              return BoringTable.fromList(
                title: BoringTableTitle(
                  title: "TEST",
                  actions: [
                    ElevatedButton.icon(
                        onPressed: _onAddAction,
                        icon: const Icon(Icons.add),
                        label: const Text("AGGIUNGI"))
                  ],
                ),
                headerRow: BoringTableFieldRow.tableHeader,
                items: tableRows,
                rowActions: [
                  BoringRowAction(
                      onTap: (val) => _onDeleteAction(val),
                      icon: const Icon(Icons.delete)),
                  BoringRowAction(
                      onTap: (val) => _onCopyAction(val),
                      icon: const Icon(Icons.copy))
                ],
              );
            },
          ),
        ));
  }

  void _onAddAction() {
    final newRow = BoringTableFieldRow.fromItems(items: items);
    _tableRows.addValue(newRow);
  }

  _onDeleteAction(int index) {
    _tableRows.deleteValue(index);
  }

  _onCopyAction(int index) {
    final toCopy = _tableRows.value.elementAt(index);
    final newRow = BoringTableFieldRow.fromItems(items: toCopy.items);
    _tableRows.addValue(newRow);
  }

  @override
  BoringTableField copyWith(
      {BoringFieldController<List<Map<String, dynamic>>>? fieldController,
      void Function(List<Map<String, dynamic>>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      List<BoringField>? items}) {
    return BoringTableField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)),
      displayCondition: displayCondition ?? this.displayCondition,
      fieldController: fieldController ?? this.fieldController,
      items: items ?? this.items,
    );
  }
}
