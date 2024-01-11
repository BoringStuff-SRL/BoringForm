import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoringStep {
  final String title;
  final String? subTitle;
  final Widget child;

  const BoringStep({required this.child, required this.title, this.subTitle});
}
