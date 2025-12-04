import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PasswordFailedDialog extends StatelessWidget {
  const PasswordFailedDialog({super.key});

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
              'The Secret PIN code is incorrect.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red,
                decoration: TextDecoration.underline,
                decorationColor:  Colors.red,
                decorationThickness: 2,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please retry with the correct code.',
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