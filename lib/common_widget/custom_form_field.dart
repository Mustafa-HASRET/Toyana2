import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLength;
  final bool isTextarea;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLength,
    this.isTextarea = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: isTextarea ? 5 : 1,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: const Color(0xFFBDBDBD)) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF8C00), width: 1.6),
        ),
        counterText: maxLength != null ? '${controller.text.length}/$maxLength' : null,
      ),
      onChanged: (_) {
        if (maxLength != null) {
          (context as Element).markNeedsBuild();
        }
      },
    );
  }
}
