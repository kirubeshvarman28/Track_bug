import 'package:flutter/material.dart';
import 'screens/main_scaffold.dart';

void main() {
  runApp(const TraceBugApp());
}

class TraceBugApp extends StatelessWidget {
  const TraceBugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRACK BUG',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFC6FF00),
        scaffoldBackgroundColor: const Color(0xFF000000),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFC6FF00),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC6FF00),
          secondary: Color(0xFFC6FF00),
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const MainScaffold(),
      debugShowCheckedModeBanner: false,
    );
  }
}
