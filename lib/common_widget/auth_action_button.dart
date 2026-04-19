import 'package:flutter/material.dart';

class AuthActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const AuthActionButton({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: foregroundColor),
      label: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
