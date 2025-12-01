import 'package:flutter/material.dart';
import 'package:hr_management/components/ForgotPasswordDialog.dart';
import 'package:hr_management/components/PasswordFailedDialog.dart';
import 'package:hr_management/components/PasswordSuccessDialog.dart';
import 'package:hr_management/components/AuthinticationDialog.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F7F6),
      body: Center(
        child: AuthinticationDialog(),
        // child: ResetPasswordDialog(),
        // child: PasswordSuccessDialog(onReturnToLogin: () {  },),
        // child: PasswordFailedDialog(onReturnToLogin: () {  },),
      ),
    );
  }
}
