import 'dart:async';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoringTextDropDownField extends BoringFormField<String> {
  BoringTextDropDownField({
    super.key,
    required super.fieldPath,
    required this.future,
    super.decoration,
    super.observedFields,
    super.forceHideRequiredFieldLabel,
    super.onChanged,
    super.readOnly,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputFormatter,
    this.allowEmpty = false,
    ValidationFunction<String>? validationFunction,
    String errorMessage = "Value cannot be empty",
  })  : fieldController = BoringTextDropDownFieldController(
          getItems: future,
        ),
        super(
            validationFunction: validationFunction == null && allowEmpty
                ? null
                : (BoringFormController formController, String? value) {
                    final error =
                        validationFunction?.call(formController, value);
                    final emptyError =
                        !allowEmpty && (value == null || value.isEmpty)
                            ? errorMessage
                            : null;
                    return error ?? emptyError;
                  });

  final OverlayPortalController portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final Future<List<String>> Function() future;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _fieldKey = GlobalKey();
  final BoringTextDropDownFieldController fieldController;
  final FocusNode focusNode = FocusNode();
  final int minLines;
  final int maxLines;
  final bool allowEmpty;
  final List<TextInputFormatter>? inputFormatter;

  @override
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, String? fieldValue, String? error) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        portalController.show();
      } else {
        portalController.hide();
      }
    });
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal.targetsRootOverlay(
        controller: portalController,
        child: TextField(
          key: _fieldKey,
          controller: _textController,
          readOnly: isReadOnly(formController, formStyle),
          enabled: !isReadOnly(formController, formStyle),
          inputFormatters: inputFormatter,
          minLines: minLines,
          maxLines: maxLines,
          textAlign: formStyle.textAlign,
          style: formStyle.textStyle,
          decoration:
              getInputDecoration(formController, formStyle, error, fieldValue),
          onChanged: (value) {
            fieldController.setFilter(value);
            formController.setFieldValue(fieldPath, value);
            if (!portalController.isShowing) {
              portalController.show();
            }
            setChangedValue(formController, value);
          },
          focusNode: focusNode,
        ),
        overlayChildBuilder: (context) {
          final renderBox =
              (_fieldKey.currentContext?.findRenderObject() as RenderBox);

          return Stack(
            children: [
              GestureDetector(
                onTap: portalController.hide,
              ),
              BDropdownWindow(
                layerLink: _layerLink,
                buildOver: false,
                dropdownWindowMaxHeight: 200,
                parentRenderBox: renderBox,
                child: ListenableBuilder(
                  listenable: fieldController,
                  builder: (context, child) {
                    if (fieldController.isLoading) {
                      return _buildDropdownContainer(
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (fieldController.hasError) {
                      return _buildDropdownContainer(
                        child:
                            const Center(child: Text('Errore nel caricamento')),
                      );
                    }

                    final items = fieldController.items;

                    if (items.isEmpty) {
                      return Container();
                    }

                    return _buildDropdownContainer(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item.toString()),
                            onTap: () {
                              formController.setFieldValue(fieldPath, item);
                              portalController.hide();
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: child,
    );
  }

  @override
  void onSelfChange(BoringFormController formController, String? fieldValue) {
    var cursorPos = _textController.selection.base.offset;
    _textController.text = (fieldValue ?? "");
    if (fieldValue != null) {
      _textController.selection = TextSelection.collapsed(offset: cursorPos);
    }
  }
}

class BoringTextDropDownFieldController extends ChangeNotifier {
  List<String> _items = [];
  final Future<List<String>> Function() getItems;
  bool _isLoading = false;
  String? _filter;
  Object? _error;

  BoringTextDropDownFieldController({required this.getItems}) {
    loadItems();
  }

  List<String> get items => _items
      .where((e) => (e.toLowerCase()).contains((_filter?.toLowerCase()) ?? ''))
      .toList();

  bool get isLoading => _isLoading;
  bool get hasError => _error != null;

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();
    _items = await getItems().catchError((e) {
      _error = e;
    });
    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
}
