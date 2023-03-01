import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/table/boring_table_field_row.dart';
import 'package:boring_form/implementations/table/boring_table_form_decoration.dart';
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
      required this.tableHeader,
      this.tableFormDecoration,
      this.groupActions = false,
      this.groupActionsMenuShape,
      this.actionGroupTextStyle,
      this.groupActionsWidget = const Icon(Icons.more_vert),
      super.boringResponsiveSize,
      this.copyIconWidget,
      this.deleteIconWidget,
      super.displayCondition,
      this.copyActionText,
      this.deleteActionText,
      super.decoration})
      : super(
            fieldController:
                tableFieldController ?? BoringTableFieldController());

  final _tableRows = RowsListener([]);
  final BoringTableFormDecoration? tableFormDecoration;
  final List<TableHeaderElement> tableHeader;
  final List<BoringField> items;
  final bool groupActions;
  final TextStyle? actionGroupTextStyle;
  final ShapeBorder? groupActionsMenuShape;
  final Widget groupActionsWidget;
  final Widget? deleteIconWidget;
  final Widget? copyIconWidget;
  final String? deleteActionText;
  final String? copyActionText;

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
                groupActions: groupActions,
                actionGroupTextStyle: actionGroupTextStyle,
                groupActionsMenuShape: groupActionsMenuShape,
                groupActionsWidget: groupActionsWidget,
                title: BoringTableTitle(
                  title: tableFormDecoration?.tableTitle ?? const Text('Title'),
                  actions: [
                    if (tableFormDecoration?.showAddButton ?? false)
                      ElevatedButton(
                        onPressed: _onAddAction,
                        style: tableFormDecoration?.addButtonActionStyle,
                        child: tableFormDecoration?.addButtonActionChild ??
                            const Text('add'),
                      )
                  ],
                ),
                cardElevation: tableFormDecoration?.cardElevation,
                rowActionsColumnLabel:
                    tableFormDecoration?.rowActionsColumnLabel,
                decoration: tableFormDecoration?.decoration,
                shape: tableFormDecoration?.shape,
                widgetWhenEmpty: tableFormDecoration?.widgetWhenEmpty,
                headerRow: tableHeader,
                items: tableRows,
                rowActions: [
                  BoringRowAction(
                      buttonText: groupActions ? deleteActionText : null,
                      onTap: (val) => _onDeleteAction(val),
                      icon: deleteIconWidget ?? const Icon(Icons.delete)),
                  BoringRowAction(
                      buttonText: groupActions ? copyActionText : null,
                      onTap: (val) => _onCopyAction(val),
                      icon: copyIconWidget ?? const Icon(Icons.copy))
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
      BoringTableFormDecoration? tableFormDecoration,
      List<TableHeaderElement>? tableHeader,
      BoringTableFieldController? tableFieldController,
      bool? groupActions,
      TextStyle? actionGroupTextStyle,
      ShapeBorder? groupActionsMenuShape,
      Widget? groupActionsWidget,
      Widget? deleteIconWidget,
      Widget? copyIconWidget,
      String? deleteActionText,
      String? copyActionText}) {
    return BoringTableField(
      groupActions: groupActions ?? this.groupActions,
      actionGroupTextStyle: actionGroupTextStyle ?? this.actionGroupTextStyle,
      copyActionText: copyActionText ?? this.copyActionText,
      copyIconWidget: copyIconWidget ?? this.copyIconWidget,
      deleteActionText: deleteActionText ?? this.deleteActionText,
      deleteIconWidget: deleteIconWidget ?? this.deleteIconWidget,
      groupActionsMenuShape:
          groupActionsMenuShape ?? this.groupActionsMenuShape,
      groupActionsWidget: groupActionsWidget ?? this.groupActionsWidget,
      boringResponsiveSize: boringResponsiveSize ?? this.boringResponsiveSize,
      jsonKey: jsonKey ?? this.jsonKey,
      decoration: decoration ?? this.decoration,
      onChanged: (onChanged as void Function(dynamic)?) ??
          (this.onChanged as void Function(dynamic)),
      displayCondition: displayCondition ?? this.displayCondition,
      items: items ?? this.items,
      tableHeader: tableHeader ?? this.tableHeader,
      tableFormDecoration: tableFormDecoration ?? this.tableFormDecoration,
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
