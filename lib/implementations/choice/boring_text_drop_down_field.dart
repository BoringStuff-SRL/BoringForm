import 'dart:async';
import 'package:boring_form/field/boring_form_field.dart';
import 'package:boring_ui/boring_ui.dart';
import 'package:flutter/material.dart';

class BoringWindowField<T> extends BoringFormField<T> {
  BoringWindowField({
    super.key,
    required super.fieldPath,
    required this.future,
    required this.label,
  });

  final OverlayPortalController portalController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  final Future<List<T>> future;
  final String label;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget builder(BuildContext context, BoringFormStyle formStyle,
      BoringFormController formController, T? fieldValue, String? error) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TapRegion(
            onTapOutside: (event) => portalController.hide(),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: label,
                errorText: error,
              ),
              onTap: () {
                portalController.isShowing
                    ? portalController.hide()
                    : portalController.show();
              },
            ),
          ),
          OverlayPortal(
            controller: portalController,
            overlayChildBuilder: (context) {
              return Positioned(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: const Offset(0, 50),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder<List<T>>(
                      future: future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildDropdownContainer(
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return _buildDropdownContainer(
                            child: const Center(
                                child: Text('Errore nel caricamento')),
                          );
                        }

                        final items = snapshot.data ?? [];

                        if (items.isEmpty) {
                          return _buildDropdownContainer(
                            child: const Center(
                                child: Text('Nessun elemento trovato')),
                          );
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
                                  _textController.text = item.toString();
                                  portalController.hide();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
  void onSelfChange(BoringFormController formController, T? fieldValue) {
    _textController.text = fieldValue?.toString() ?? '';
  }
}
