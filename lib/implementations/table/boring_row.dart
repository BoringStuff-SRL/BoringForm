import 'package:boring_form/boring_form.dart';
import 'package:boring_table/models/models.dart';
import 'package:flutter/cupertino.dart';

import '../../field/boring_field.dart';

class BoringRow extends BoringTableRowElement {
  BoringRow({required this.items});

  BoringRow.cache({required this.items, bool isCopy = false}) {
    newItems = List.generate(
        items.length,
        (index) => items[index].copyWith(
            jsonKey: items[index].jsonKey,
            fieldController: items[index].fieldController.copyWith(
                initialValue:
                    isCopy ? items[index].fieldController.value : '')));
  }

  final List<BoringField> items;

  List<BoringField>? newItems;

  List<BoringField>? getItems() => newItems;

  static final tableHeader = [
    TableHeaderElement(label: "Colonna 1", flex: 1),
    TableHeaderElement(label: "Colonna 2", flex: 1),
  ];

  @override
  List<Widget> toTableRow() {
    return List.generate(newItems?.length ?? items.length,
        (index) => newItems?[index] ?? items[index]);
  }
}
