// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_form/boring_form.dart';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum FilePickerFeedbackPosition { top, left, right, bottom }

class BoringFilePicker extends BoringFormField<List<PlatformFile>> {
  final double? textSpacingFromIcon;
  final double? buttonWidth;
  final double? verticalAlignment;
  final TextStyle? labelStyle;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool? allowMultiple;
  final Text? noFilesSelectedText;
  final Text Function(int filesSelected)? feedbackTextBuilder;
  final List<String>? allowedExtensions;
  final FilePickerFeedbackPosition feedbackPosition;
  final MainAxisAlignment mainAxisAlignment;
  final TextDirection? textDirection;
  final Border? border;
  // final String? label;

  const BoringFilePicker({
    super.key,
    required super.fieldPath,
    super.observedFields,
    super.validationFunction,
    super.decoration,
    super.readOnly,
    this.textSpacingFromIcon,
    this.borderRadius,
    this.buttonWidth,
    this.padding,
    this.backgroundColor,
    this.labelStyle,
    this.allowedExtensions,
    this.allowMultiple,
    this.verticalAlignment,
    this.noFilesSelectedText,
    this.textDirection,
    this.feedbackPosition = FilePickerFeedbackPosition.right,
    this.feedbackTextBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.border,
    // this.label,
  });

  Widget _feedback(List<PlatformFile>? files) => Flexible(
        child: feedbackTextBuilder?.call(files?.length ?? 0) ??
            Text(
              "${files?.length ?? 0} files selected",
              overflow: TextOverflow.ellipsis,
            ),
      );
  void _handlePick(
    BoringFormController formController,
    FilePickerResult? pickerResult,
  ) {
    if (pickerResult == null) {
      // User canceled the picker
      return;
    }
    setChangedValue(formController, pickerResult.files);
  }

  @override
  Widget builder(
      BuildContext context,
      BoringFormTheme formTheme,
      BoringFormController formController,
      List<PlatformFile>? fieldValue,
      String? error) {
    final style = formTheme.style;
    final decoration =
        getInputDecoration(formController, formTheme, error, fieldValue);
    final readOnly = style.readOnly;

    return Align(
      heightFactor: verticalAlignment ?? 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (feedbackPosition == FilePickerFeedbackPosition.left)
            Row(
              children: [
                _feedback(fieldValue),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (feedbackPosition == FilePickerFeedbackPosition.top)
                Column(
                  children: [
                    _feedback(fieldValue),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              MouseRegion(
                cursor:
                    !readOnly ? SystemMouseCursors.click : MouseCursor.defer,
                child: GestureDetector(
                  onTap: () async {
                    if (readOnly) {
                      return;
                    }
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: allowedExtensions == null
                                ? FileType.any
                                : FileType.custom,
                            allowMultiple: allowMultiple ?? true,
                            allowedExtensions: allowedExtensions,
                            withData: true);
                    _handlePick(formController, result);
                  },
                  child: Container(
                    padding: padding ?? const EdgeInsets.symmetric(vertical: 7),
                    width: buttonWidth ?? 100,
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.green,
                      border: border,
                      borderRadius: borderRadius ?? BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: textDirection,
                      children: [
                        decoration.prefixIcon ?? const Icon(Icons.file_open),
                        SizedBox(
                          width: textSpacingFromIcon ?? 5,
                        ),
                        decoration.label ??
                            Text(
                              "Pick file",
                              style: labelStyle,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
              if (feedbackPosition == FilePickerFeedbackPosition.bottom)
                Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    _feedback(fieldValue),
                  ],
                ),
              if (error != null)
                Text(error, style: TextStyle(color: Colors.red))
            ],
          ),
          const SizedBox(
            width: 5,
          ),
          if (feedbackPosition == FilePickerFeedbackPosition.right)
            _feedback(fieldValue),
        ],
      ),
    );
  }

  @override
  void onObservedFieldsChange(BoringFormController formController) {}

  @override
  void onSelfChange(
      BoringFormController formController, List<PlatformFile>? fieldValue) {}
}
