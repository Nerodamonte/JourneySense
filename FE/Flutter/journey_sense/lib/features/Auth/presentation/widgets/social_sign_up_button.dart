// lib/features/auth/presentation/widgets/social_sign_up_button.dart

import 'package:flutter/material.dart';

class SocialSignUpButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isGoogle; // true = white bg, false = dark bg

  const SocialSignUpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isGoogle = true,
    String? icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGoogle ? Colors.white : const Color(0xFF1A1A1A),
          foregroundColor: isGoogle ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: isGoogle ? Colors.grey.shade300 : Colors.transparent,
            ),
          ),
          elevation: 0,
        ),
        icon: Icon(
          isGoogle ? Icons.mail : Icons.apple, // thay bằng custom icon nếu có
          size: 22,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
