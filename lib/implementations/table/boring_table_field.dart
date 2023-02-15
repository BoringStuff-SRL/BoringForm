import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/table/boring_table_field_row.dart';
import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

import 'boring_table_field_controller.dart';



class BoringTableField extends BoringField<List<Map<String, dynamic>>> {
  BoringTableField(
      {super.key,
      BoringTableFieldController? tableFieldController,
      super.onChanged,
      required super.jsonKey,
      required this.items,
      super.boringResponsiveSize,
      super.displayCondition,
      super.decoration})
      : super(
            fieldController:
                tableFieldController ?? BoringTableFieldController());

  final _tableRows = RowsListener([]);

  final List<BoringField> items;

  @override
  bool setInitialValue(List<Map<String, dynamic>>? initialValue) {
    final v = super.setInitialValue(initialValue);

    if (v) {
      if (fieldController.initialValue != null) {
        _setRowFieldsInitialValues();
      }
    }
    return false;
  }

  void _setRowFieldsInitialValues() {
    for (int i = 0; i < (fieldController.initialValue?.toList())!.length; i++) {
      List<BoringField> tempList = [];
      for (var item in items) {
        tempList.add(item.copyWith(
            fieldController: item.fieldController.copyWith(
                initialValue: fieldController.initialValue![i][item.jsonKey])));
      }
      _onAddAction(initItems: tempList);
    }
  }

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);

    return BoringField.boringFieldBuilder(style, decoration?.label,
        child: SizedBox(
          height: 600,
          child: ValueListenableBuilder(
            valueListenable: _tableRows,
            builder: (BuildContext context, List<BoringTableFieldRow> tableRows,
                Widget? child) {
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

  void _onAddAction({List<BoringField>? initItems}) {
    final newRow = BoringTableFieldRow.fromItems(items: initItems ?? items);
    _tableRows.addValue(newRow);
    (fieldController as BoringTableFieldController)
        .addControllers(newRow.items);
  }

  _onDeleteAction(int index) {
    _tableRows.deleteValue(index);
    (fieldController as BoringTableFieldController).removeController(index);
  }

  _onCopyAction(int index) {
    final toCopy = _tableRows.value.elementAt(index);
    final newRow = BoringTableFieldRow.fromItems(items: toCopy.items);
    _tableRows.addValue(newRow);
    (fieldController as BoringTableFieldController)
        .addControllers(newRow.items);
  }

  @override
  BoringTableField copyWith(
      {BoringFieldController<List<Map<String, dynamic>>>? fieldController,
      void Function(List<Map<String, dynamic>>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition,
      List<BoringField>? items,
      BoringTableFieldController? tableFieldController}) {
    return BoringTableField(
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)),
      displayCondition: displayCondition ?? this.displayCondition,
      items: items ?? this.items,
    );
  }
}

class RowsListener extends ValueNotifier<List<BoringTableFieldRow>> {
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
