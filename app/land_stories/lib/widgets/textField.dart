import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final int mxLen;
  final controller;

  TextFieldWidget(this.hint, this.mxLen, this.controller);
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: PlatformTextField(
          controller: controller,
          keyboardType: TextInputType.text,
          android: (_) => MaterialTextFieldData(
            decoration: InputDecoration(
              labelText: hint,
              hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
            ),
          ),
          ios: (_) => CupertinoTextFieldData(
            placeholder: hint,
            placeholderStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
            autofocus: true,
            autocorrect: true,
            enableSuggestions: true,
          ),
          maxLength: mxLen,
        ),
      ),
    );
  }
}
