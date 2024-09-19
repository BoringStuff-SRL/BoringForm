// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors

import 'dart:typed_data';

import 'package:boring_form/boring_form.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_file_box.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class _DropData {
  final String fileName;
  final Uint8List bytes;

  const _DropData({
    required this.fileName,
    required this.bytes,
  });
}

class _DropDataHandler {
  final List<_DropData> _data = [];
  final int itemsToDrop;
  final BoringFilePickerSettings settings;
  final BoringFormController formController;
  final List<String> fieldPath;

  _DropDataHandler({
    required this.itemsToDrop,
    required this.formController,
    required this.settings,
    required this.fieldPath,
  });

  void addFile(_DropData data) {
    _data.add(data);

    if (_data.length == itemsToDrop) {
      final platformFiles = _data
          .map(
            (e) => PlatformFile(
              name: e.fileName,
              size: e.bytes.lengthInBytes,
              bytes: e.bytes,
            ),
          )
          .toList();
      _setFieldValue(platformFiles, settings);
    }
  }

  void _setFieldValue(
    List<PlatformFile> pickerResult,
    BoringFilePickerSettings settings,
  ) {
    if (pickerResult.isEmpty) {
      return;
    }
    switch (settings.decoration.boringFilePickerBehaviour) {
      case BoringFilePickerBehaviour.overwrite:
        formController.setFieldValue(fieldPath, pickerResult);
        break;
      case BoringFilePickerBehaviour.add:
        final files = formController.getValue(fieldPath) as List<PlatformFile>?;
        if (settings.decoration.allowMultiple) {
          formController.setFieldValue(fieldPath, (files ?? []) + pickerResult);
        } else {
          formController.setFieldValue(fieldPath, pickerResult);
        }
        break;
    }
  }
}

class BoringDropZone extends StatelessWidget {
  final BoringFormController formController;
  final List<String> fieldPath;
  late final ValueNotifier<Color> color;

  BoringDropZone({
    super.key,
    required this.formController,
    required this.fieldPath,
  });

  Future<void> handleOnDragDone(
    BuildContext context,
    BoringFilePickerSettings settings,
    PerformDropEvent details,
  ) async {
    // se sono in readOnly non posso fare niente
    if (settings.readOnly) {
      return;
    }

    //prendo la quantita' di file da caricare
    final itemsToDrop = details.session.items.length;

    // controllo se sono conformi ai settaggi
    if (!settings.decoration.allowMultiple && itemsToDrop > 1) {
      settings.decoration.onError
          ?.call(context, BoringFilePickerErrorType.allowMultiple);
      return;
    }

    // istanzio il data handler
    final dropDataHandler = _DropDataHandler(
      itemsToDrop: itemsToDrop,
      formController: formController,
      fieldPath: fieldPath,
      settings: settings,
    );

    /// ciclo tutti gli elementi della sessione
    for (var element in details.session.items) {
      final dataReader = element.dataReader;
      // se non ha un dataReader skippo a quello dopo
      if (dataReader == null) continue;

      // vedo se il file e' conforme ad uno degli standards
      for (final format in Formats.standardFormats) {
        if (element.canProvide(format)) {
          // se lo e' leggo il file e lo aggiungo al dataHandler

          dataReader.getFile(
            null,
            (value) async {
              final fileExt = value.fileName!.split('.').last;

              final data = _DropData(
                fileName: value.fileName!,
                bytes: await value.readAll(),
              );

              if (!(settings.decoration.allowedExtensions?.contains(fileExt) ??
                  true)) {
                settings.decoration.onError
                    ?.call(context, BoringFilePickerErrorType.extension);
                return;
              }

              dropDataHandler.addFile(data);
            },
          );

          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = BoringFilePickerSettings.of(context);
    final decoration = settings.decoration;
    color = ValueNotifier(decoration.inActiveColor);
    return settings.decoration.dropzoneBuilder?.call(context, formController) ??
        DropRegion(
          formats: Formats.standardFormats,
          onDropOver: (event) {
            if (settings.readOnly) {
              return DropOperation.move;
            }
            if (color.value != decoration.activeColor) {
              color.value = decoration.activeColor;
            }
            return DropOperation.move;
          },
          onPerformDrop: (event) async {
            handleOnDragDone(context, settings, event);
          },
          onDropEnter: (p0) {
            if (settings.readOnly) {
              return;
            }
          },
          onDropLeave: (p0) {
            if (settings.readOnly) {
              return;
            }
            color.value = decoration.inActiveColor;
          },
          child: ValueListenableBuilder(
            valueListenable: color,
            builder: (context, currentColor, child) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    if (settings.readOnly) {
                      return;
                    }
                    final result = await FilePicker.platform.pickFiles(
                      type: decoration.allowedExtensions == null
                          ? FileType.any
                          : FileType.custom,
                      allowMultiple: decoration.allowMultiple,
                      allowedExtensions: decoration.allowedExtensions,
                      withData: true,
                    );

                    if (result == null || result.files.isEmpty) return;
                    final files = result.files;

                    final dataHandler = _DropDataHandler(
                      itemsToDrop: files.length,
                      formController: formController,
                      settings: settings,
                      fieldPath: fieldPath,
                    );

                    for (final file in files) {
                      dataHandler.addFile(
                        _DropData(
                          fileName: file.name,
                          bytes: file.bytes!,
                        ),
                      );
                    }
                  },
                  child: BoringDropFileBox(
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
                  ),
                ),
              );
            },
          ),
        );
  }
}
