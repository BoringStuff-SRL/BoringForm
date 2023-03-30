import 'dart:convert';

import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:boring_form/field/boring_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:boring_form/theme/boring_responsive_size.dart';
import 'package:boring_form/theme/boring_field_decoration.dart';
import 'package:boring_form/field/boring_field_controller.dart';
import 'package:flutter/widgets.dart';

class BoringFilePicker extends BoringField<List<PlatformFile>> {
  BoringFilePicker(
      {required super.jsonKey,
      this.textSpacingFromIcon,
      this.borderRadius,
      this.buttonWidth,
      this.padding,
      this.backgroundColor,
      this.labelStyle,
      this.allowedExtensions,
      this.allowMultiple,
      super.fieldController,
      super.decoration,
      super.displayCondition,
      super.boringResponsiveSize,
      super.onChanged});

  final double? textSpacingFromIcon;
  final double? buttonWidth;
  final TextStyle? labelStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool? allowMultiple;
  final List<String>? allowedExtensions;

  @override
  Widget builder(BuildContext context,
      BoringFieldController<List<PlatformFile>> controller, Widget? child) {
    final style = getStyle(context);

    return BoringField.boringFieldBuilder(
      style,
      "",
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type:
                    allowedExtensions == null ? FileType.any : FileType.custom,
                allowMultiple: allowMultiple ?? true,
                allowedExtensions: allowedExtensions,
              );

              if (result != null) {
                controller.value = result.files;
              } else {
                // User canceled the picker
              }
            },
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(vertical: 7),
              width: buttonWidth ?? 100,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.green,
                borderRadius: borderRadius ?? BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  decoration?.prefixIcon ?? const Icon(Icons.file_open),
                  SizedBox(
                    width: textSpacingFromIcon ?? 5,
                  ),
                  Text(
                    decoration?.label ?? "Pick file",
                    style: labelStyle,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          controller.value == null
              ? Text("No files selected")
              : Text("${controller.value!.length} files selected")
        ],
      ),
    );
  }

  @override
  BoringField copyWith(
      {BoringFieldController<List<PlatformFile>>? fieldController,
      void Function(List<PlatformFile>? p1)? onChanged,
      BoringFieldDecoration? decoration,
      BoringResponsiveSize? boringResponsiveSize,
      String? jsonKey,
      bool Function(Map<String, dynamic> p1)? displayCondition}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
