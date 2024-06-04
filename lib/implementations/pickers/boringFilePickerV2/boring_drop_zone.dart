// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_file_box.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BoringDropZone extends StatelessWidget {
  final BoringFormController formController;
  final List<String> fieldPath;
  late final ValueNotifier<Color> color;
  BoringDropZone(
      {super.key, required this.formController, required this.fieldPath});
  @override
  Widget build(BuildContext context) {
    final decoration = BoringFilePickerSettings.of(context).decoration;
    color = ValueNotifier(decoration.inActiveColor);
    return DropTarget(
      onDragEntered: (details) {
        color.value = decoration.activeColor;
      },
      onDragExited: (details) {
        color.value = decoration.inActiveColor;
      },
      onDragDone: (details) async {
        List<PlatformFile> files = [];
        for (DropItem e in details.files) {
          final bytes = await e.readAsBytes();
          files.add(PlatformFile(
              name: e.name,
              size: bytes.lengthInBytes,
              bytes: bytes,
              path: e.path));
        }
        formController.setFieldValue(fieldPath, files);
      },
      child: ValueListenableBuilder(
          valueListenable: color,
          builder: (context, currentColor, child) {
            return BoringDropFileBox(
              decoration: decoration,
              currentColor: currentColor,
              child: Column(
                children: [
                  decoration.hintIcon ??
                      Icon(
                        Icons.download,
                        color: currentColor,
                        size: 40,
                      ),
                  Text(
                    decoration.hintText ?? 'Drag and drop file or click',
                    style: decoration.hintTextStyle ??
                        TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: currentColor),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
