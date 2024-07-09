import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_zoom/widget_zoom.dart';

class BoringImagePickerWithPreviewDecoration {
  final BoxDecoration Function(bool hasValue)? boxDecoration;
  final EdgeInsets Function(bool hasValue)? boxPadding;
  final Widget? selectImagesWidget;

  final String? selectImageText;
  final Widget? selectImageIcon;
  final Color? selectImageColor;
  final String? editText;
  final String? clearText;

  final Widget Function(BuildContext context, Widget child) _selectImageWrapper;
  final Widget Function(BuildContext context, Widget child)
      _previewImageWrapper;
  final Widget Function(
      BuildContext context, BoringFormController formController)? actionBuilder;
  BoringImagePickerWithPreviewDecoration({
    this.editText,
    this.clearText,
    this.boxDecoration,
    this.boxPadding,
    this.selectImagesWidget,
    this.selectImageText,
    this.selectImageIcon,
    this.selectImageColor,
    this.actionBuilder,
    Widget Function(BuildContext context, Widget child)? selectImageWrapper,
    Widget Function(BuildContext context, Widget child)? previewImageWrapper,
  })  : _selectImageWrapper = selectImageWrapper ?? ((context, child) => child),
        _previewImageWrapper =
            previewImageWrapper ?? ((context, child) => child);
}

class BoringImagePickerWithPreview extends BoringFormField<Uint8List> {
  BoringImagePickerWithPreview(
      {required super.fieldPath,
      super.onChanged,
      super.decoration,
      super.observedFields,
      super.key,
      super.readOnly,
      super.validationFunction,
      BoringImagePickerWithPreviewDecoration? imagePickerWithPreviewDecoration})
      : imagePickerWithPreviewDecoration = imagePickerWithPreviewDecoration ??
            BoringImagePickerWithPreviewDecoration(),
        _imagePickerWithPreviewBuilders = _BoringImagePickerWithPreviewBuilders(
            imagePickerWithPreviewDecoration ??
                BoringImagePickerWithPreviewDecoration());

  final BoringImagePickerWithPreviewDecoration imagePickerWithPreviewDecoration;
  final _BoringImagePickerWithPreviewBuilders _imagePickerWithPreviewBuilders;

  @override
  Widget builder(
      BuildContext context,
      BoringFormStyle formTheme,
      BoringFormController formController,
      Uint8List? fieldValue,
      String? error) {
    final hasValue = fieldValue != null;

    final boxDecoration =
        _imagePickerWithPreviewBuilders.buildBoxDecoration(hasValue);

    return ClipRRect(
      borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
      child: Container(
        padding: _imagePickerWithPreviewBuilders.buildBoxPadding(hasValue),
        decoration: boxDecoration,
        child: !hasValue
            ? _emptyValueWidget(context, formController)
            : _imagePreviewWidget(context, formController),
      ),
    );
  }

  Widget _emptyValueWidget(
      BuildContext context, BoringFormController formController) {
    final child = _clickToPickWidget(
      formController: formController,
      child: _imagePickerWithPreviewBuilders.buildSelectImagesWidget(context),
    );

    return _imagePickerWithPreviewBuilders.buildEmptyValueWidget(
        context, child);
  }

  Widget _imagePreviewWidget(
      BuildContext context, BoringFormController formController) {
    final image = Image.memory(
      formController.getValue(fieldPath) as Uint8List,
      fit: BoxFit.contain,
    );
    final child = Stack(
      children: [
        WidgetZoom(
          heroAnimationTag: "TAG",
          zoomWidget: image,
          fullScreenDoubleTapZoomScale: 2.5,
        ),
        imagePickerWithPreviewDecoration.actionBuilder
                ?.call(context, formController) ??
            Positioned(
              top: 5,
              right: 5,
              child: PopupMenuButton(
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(imagePickerWithPreviewDecoration.editText ??
                            "Edit image"),
                      ],
                    ),
                    onTap: () => _handleSelectImage(formController),
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(imagePickerWithPreviewDecoration.clearText ??
                            "Remove image"),
                      ],
                    ),
                    onTap: () => _handleClearImage(formController),
                  ),
                ],
              ),
            ),
      ],
    );

    return _imagePickerWithPreviewBuilders.buildImagePreviewWidget(
        context, child);
  }

  Widget _clickToPickWidget(
          {required BoringFormController formController,
          required Widget child}) =>
      Builder(builder: (context) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
              await _handleSelectImage(formController);
            },
            child: child,
          ),
        );
      });

  Future<void> _handleSelectImage(BoringFormController formController) async {
    final selectedFileResult = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.image,
    );

    if (selectedFileResult != null) {
      formController.setFieldValue(
          fieldPath, selectedFileResult.files.first.bytes!);
    }
  }

  Future<void> _handleClearImage(BoringFormController formController) async {
    formController.setFieldValue(fieldPath, null);
  }

  @override
  void onSelfChange(
      BoringFormController formController, Uint8List? fieldValue) {}
}

class _BoringImagePickerWithPreviewBuilders {
  BoringImagePickerWithPreviewDecoration imagePickerWithPreviewDecoration;

  _BoringImagePickerWithPreviewBuilders(this.imagePickerWithPreviewDecoration);

  BoxDecoration buildBoxDecoration(bool hasValue) =>
      imagePickerWithPreviewDecoration.boxDecoration?.call(hasValue) ??
      BoxDecoration(
          border: !hasValue ? Border.all(color: Colors.grey, width: 1) : null,
          borderRadius: BorderRadius.circular(15));

  EdgeInsets buildBoxPadding(bool hasValue) =>
      imagePickerWithPreviewDecoration.boxPadding?.call(hasValue) ??
      (hasValue ? EdgeInsets.zero : const EdgeInsets.all(15));

  Widget buildSelectImagesWidget(BuildContext context) =>
      imagePickerWithPreviewDecoration.selectImagesWidget ??
      Column(
        children: [
          imagePickerWithPreviewDecoration.selectImageIcon ??
              Icon(
                Icons.upload,
                color: Theme.of(context).colorScheme.primary,
                size: 35,
              ),
          const SizedBox(height: 10),
          Text(
            imagePickerWithPreviewDecoration.selectImageText ?? "Select image",
            style: TextStyle(
                color: imagePickerWithPreviewDecoration.selectImageColor ??
                    Colors.grey),
          )
        ],
      );

  Widget buildEmptyValueWidget(BuildContext context, Widget child) =>
      imagePickerWithPreviewDecoration._selectImageWrapper.call(context, child);

  Widget buildImagePreviewWidget(BuildContext context, Widget child) =>
      imagePickerWithPreviewDecoration._previewImageWrapper
          .call(context, child);
}
