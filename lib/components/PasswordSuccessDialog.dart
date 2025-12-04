import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordSuccessDialog extends StatelessWidget {
  const PasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0x2609866F), width: 1),
      ),
      child: Container(
        width: 550,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your new password has been set successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xff0A866F),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xff0A866F),
                decorationThickness: 2,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please re-connect through the Login page.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => context.go('/login'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Return to Login',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}