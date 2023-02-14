import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/table/boring_row.dart';
import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

typedef Bre = BoringTableRowElement;

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
    this.items = items
        .map((e) => e.copyWith(
            jsonKey: e.jsonKey, onChanged: (value) => anyFieldChange()))
        .toList();
  }

  final ValueNotifier<List<Bre>> _tableRows = ValueNotifier([]);

  final List<List<BoringField>> _cacheRowItem = [];

  late final List<BoringField> items;

  void anyFieldChange() {
    var json = _cacheRowItem
        .map((row) => {
              for (var field in row)
                (field).jsonKey: (field).fieldController.value
            })
        .toList();

    fieldController.setValueSilently(json);
  }

  @override
  bool setInitialValue(val) {
    super.setInitialValue(val);
    return true;
  }

  @override
  Widget builder(context, controller, child) {
    final style = getStyle(context);

    _cacheRowItem.add(BoringRow.cache(items: items).getItems()!);
    _tableRows.value.add(BoringRow(items: _cacheRowItem.first));

    return BoringField.boringFieldBuilder(style, decoration?.label,
        child: SizedBox(
          height: 600,
          child: ValueListenableBuilder(
            valueListenable: _tableRows,
            builder: (BuildContext context, List<Bre> value, Widget? child) {
              return BoringTable.fromList(
                headerRow: BoringRow.tableHeader,
                items: value,
                rowActions: [
                  BoringRowAction(
                      onTap: (val) => _onAddAction(val),
                      icon: const Icon(Icons.add)),
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

  _onAddAction(int value) {
    var tempList = List.generate(_tableRows.value.length,
        (index) => BoringRow(items: _cacheRowItem.elementAt(index)));

    _cacheRowItem.add(BoringRow.cache(items: items).getItems()!);

    tempList.add(BoringRow(items: _cacheRowItem.last));

    _tableRows.value = tempList;
  }

  _onDeleteAction(int value) {
    var tempList = List.generate(_tableRows.value.length,
        (index) => BoringRow(items: _cacheRowItem.elementAt(index)));

    _cacheRowItem.removeAt(value);

    tempList.removeAt(value);

    _tableRows.value = tempList;
  }

  _onCopyAction(int value) {
    var tempList = List.generate(_tableRows.value.length,
        (index) => BoringRow(items: _cacheRowItem.elementAt(index)));

    _cacheRowItem.add(
        BoringRow.cache(items: _cacheRowItem.elementAt(value), isCopy: true)
            .getItems()!);

    tempList.add(BoringRow(items: _cacheRowItem.last));

    _tableRows.value = tempList;
  }

  @override
  BoringField copyWith(
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
