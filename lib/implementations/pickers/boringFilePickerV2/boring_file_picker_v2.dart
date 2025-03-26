// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_drop_zone.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_list_tile.dart';
import 'package:boring_form/implementations/pickers/boringFilePickerV2/boring_file_picker_settings.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringFilePickerV2 extends BFormField<List<PlatformFile>> {
  final BoringFilePickerDecoration decoration;

  BoringFilePickerV2(
      {super.key,
      required super.fieldPath,
      super.observedFields,
      super.validationFunction,
      super.readOnly,
      super.required,
      super.responsiveSize,
      super.onChanged,
      this.decoration = const BoringFilePickerDecoration()});

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BoringFormController formController,
    List<PlatformFile>? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    return BoringFilePickerSettings(
      readOnly: fieldValidation.isReadOnly,
      decoration: decoration,
      formController: formController,
      fieldPath: fieldPath,
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: fieldValue?.length ?? 0,
            itemBuilder: (context, index) {
              return BoringFileListTile(
                file: fieldValue![index],
              );
            },
          ),
          if (!fieldValidation.isReadOnly)
            Row(
              children: [
                Expanded(
                  child: BoringDropZone(
                      formController: formController, fieldPath: fieldPath),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
