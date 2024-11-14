import 'package:flutter/material.dart';
import 'package:parking_version_1/pages/login.dart';
import 'package:parking_version_1/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) =>  LoginPage(),  
        '/home': (context) => const HomePage(),
      },
    );
  }
}
