import 'package:flutter/material.dart';
import 'features/auth/welcome_screen.dart';

void main() {
  runApp(const HoPhakApp());
}

class HoPhakApp extends StatelessWidget {
  const HoPhakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ho_Phak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Prompt'),
      home: const WelcomeScreen(),
    );
  }
}