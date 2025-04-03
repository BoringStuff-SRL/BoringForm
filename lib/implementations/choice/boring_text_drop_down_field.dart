import 'dart:async';
import 'dart:math';

import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoringTextDropDownField extends BFormField<String> {
  BoringTextDropDownField({
    super.key,
    required super.fieldPath,
    required this.future,
    super.decoration,
    super.observedFields,
    super.onChanged,
    super.readOnly,
    super.required,
    super.responsiveSize,
    super.validationFunction,
    this.minLines = 1,
    this.maxLines = 1,
    this.boringStyle,
    this.inputFormatter,
  }) : fieldController = BoringTextDropDownFieldController(
          getItems: future,
        );
  final BDropdownTheme? boringStyle;
  final OverlayPortalController portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final Future<List<String>> Function() future;
  final TextEditingController _textController = TextEditingController();
  final GlobalKey _fieldKey = GlobalKey();
  final BoringTextDropDownFieldController fieldController;
  final FocusNode focusNode = FocusNode();
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  final int minLines;
  final int maxLines;

  final List<TextInputFormatter>? inputFormatter;
  bool _isSelecting = false;

  BDropdownTheme bDropdownTheme(BuildContext context) =>
      boringStyle ?? BoringTheme.of(context).bDropdownTheme;

  Widget _buildDropdownContainer({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: child,
    );
  }

  @override
  void onSelfChange(BFormController formController, String? fieldValue) {
    var cursorPos =
        min(_textController.selection.base.offset, fieldValue?.length ?? 0);

    _textController.text = (fieldValue ?? "");
    if (fieldValue != null) {
      _textController.selection = TextSelection.collapsed(offset: cursorPos);
    }
  }

  @override
  Widget fieldBuilder(
    BuildContext context,
    BoringFormStyle formStyle,
    BFormController formController,
    String? fieldValue,
    FieldValidation fieldValidation,
    void computedValue,
  ) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        portalController.show();
      } else if (!_isSelecting) {
        portalController.hide();
      }
    });
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal.targetsRootOverlay(
        controller: portalController,
        overlayChildBuilder: (context) {
          final renderBox =
              (_fieldKey.currentContext?.findRenderObject() as RenderBox);
          return ListenableBuilder(
              listenable: fieldController,
              builder: (context, child) {
                return Stack(
                  children: [
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
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }

                          if (fieldController.hasError) {
                            return _buildDropdownContainer(
                              child: const Center(
                                  child: Text('Errore nel caricamento')),
                            );
                          }

                          final items = fieldController.items;

                          if (items.isEmpty) {
                            return _buildDropdownContainer(
                              child:
                                  const Center(child: Text('Nessun elemento')),
                            );
                          }
                          return _buildDropdownContainer(
                            child: MouseRegion(
                              onEnter: (_) {
                                _isSelecting = true;
                              },
                              onExit: (_) {
                                _isSelecting = false;
                                if (!focusNode.hasFocus) {
                                  portalController.hide();
                                }
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return ListTile(
                                    title: Text(item),
                                    onTap: () {
                                      formController.setFieldValue(
                                          fieldPath, item);
                                      portalController.hide();
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
        },
        child: TextField(
          key: _fieldKey,
          controller: _textController,
          readOnly: fieldValidation.isReadOnly,
          enabled: fieldValidation.isReadOnly,
          inputFormatters: inputFormatter,
          minLines: minLines,
          maxLines: maxLines,
          textAlign: formStyle.textAlign,
          style: formStyle.textStyle,
          decoration: getInputDecoration(
              formController, formStyle, fieldValue, fieldValidation),
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
      ),
    );
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
  bool get isEmpty => _items.isEmpty;

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
