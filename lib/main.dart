import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_management/pages/HomePage.dart';
import 'pages/Loginpage.dart';
import 'package:hr_management/components/ForgotPasswordDialog.dart';
import 'package:hr_management/components/PasswordSuccessDialog.dart';
import 'package:hr_management/components/PasswordFailedDialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HR MANAGEMENT',

      debugShowCheckedModeBanner: false,

      routerConfig: _router,

      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF09866F), width: 0.6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        fontFamily: 'Trap',
        fontFamilyFallback: const ['Alfont'],
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/home', builder: (context, state) => const Homepage()),
      GoRoute(path: '/login', builder: (context, state) => const Loginpage()),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xffF1F7F6),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: ResetPasswordDialog(),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/reset-success',
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xffF1F7F6),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: PasswordSuccessDialog(),
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/reset-failed',
        builder: (context, state) => const Scaffold(
          backgroundColor: Color(0xffF1F7F6),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: PasswordFailedDialog(),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
