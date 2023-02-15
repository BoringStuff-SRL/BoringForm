import 'package:boring_form/boring_form.dart';
import 'package:boring_table/models/models.dart';
import 'package:flutter/cupertino.dart';

import '../../field/boring_field.dart';

class BoringTableFieldRow extends BoringTableRowElement {
  //BoringTableFieldRow({required this.items});

  BoringTableFieldRow.fromItems({required List<BoringField> items})
      : _items = items
            .map((item) =>
                item.copyWith(fieldController: item.fieldController.copyWith()))
            .toList();

  // List.generate(
  //     items.length,
  //     (index) => items[index].copyWith(
  //         fieldController: items[index].fieldController.copyWith()));

  // BoringTableFieldRow.cache({required this.items, bool isCopy = false}) {
  //   newItems = List.generate(
  //       items.length,
  //       (index) => items[index].copyWith(
  //           jsonKey: items[index].jsonKey,
  //           fieldController: items[index].fieldController.copyWith(
  //               initialValue:
  //                   isCopy ? items[index].fieldController.value : '')));
  // }

  final List<BoringField> _items;
  List<BoringField> get items => _items;

  static final tableHeader = [
    TableHeaderElement(label: "Colonna 1", flex: 1),
    TableHeaderElement(label: "Colonna 2", flex: 1),
  ];

  @override
  List<Widget> toTableRow() => items;
  // return List.generate(items?.length ?? items.length,
  //     (index) => items?[index] ?? items[index]);

}
