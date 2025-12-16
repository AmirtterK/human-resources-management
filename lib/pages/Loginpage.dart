import 'package:flutter/material.dart';
import 'package:hr_management/components/AuthinticationDialog.dart';

/// Page displaying the authentication dialog.
class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F7F6),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: AuthinticationDialog(),
          ),
        ),
      ),
    );
  }
}
