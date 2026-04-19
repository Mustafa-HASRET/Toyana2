import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLength;
  final bool isTextarea;
  final TextInputType keyboardType;

  const CustomFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.maxLength,
    this.isTextarea = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: isTextarea ? 5 : 1,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        counterText: maxLength != null ? '${controller.text.length}/$maxLength' : null,
      ),
      onChanged: (_) {
        if (maxLength != null) {
          // Force rebuild when counter needs update.
          (context as Element).markNeedsBuild();
        }
      },
    );
  }
}
