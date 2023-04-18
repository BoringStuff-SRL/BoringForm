// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

class BoringTableFormDecoration {
  final Widget? tableTitle;
  final double? cardElevation;
  final Widget? widgetWhenEmpty;
  final String? rowActionsColumnLabel;
  final double? borderRadius;
  final BoringTableDecoration? decoration;
  final Widget? footer;
  final bool showAddButton;
  final Widget? addButtonActionChild;
  final ButtonStyle? addButtonActionStyle;

  BoringTableFormDecoration(
      {this.tableTitle,
      this.cardElevation,
      this.widgetWhenEmpty,
      this.rowActionsColumnLabel,
      this.borderRadius,
      this.decoration,
      this.footer,
      this.showAddButton = false,
      this.addButtonActionChild,
      this.addButtonActionStyle});
}
