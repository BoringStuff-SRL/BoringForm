import 'package:boring_form/boring_form.dart';
import 'package:boring_table/models/models.dart';
import 'package:flutter/cupertino.dart';

import '../../field/boring_field.dart';

class BoringTableFieldRow extends BoringTableRowElement {
  BoringTableFieldRow.fromItems({required List<BoringField> items})
      : _items = items
            .map((item) =>
                item.copyWith(fieldController: item.fieldController.copyWith()))
            .toList();

  final List<BoringField> _items;

  List<BoringField> get items => _items;

  static final tableHeader = [
    TableHeaderElement(
        label: "Colonna 1",
        flex: 1,
        tableHeaderDecoration: TableHeaderDecoration()),
    TableHeaderElement(
        label: "Colonna 2",
        flex: 1,
        tableHeaderDecoration: TableHeaderDecoration()),
  ];

  @override
  List<Widget> toTableRow() => items;
}
