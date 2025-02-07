import 'package:flutter/material.dart';
import 'package:app/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor Tareas UBU',
      theme: ThemeData(primaryColor: const Color(0xFFF4F4F4)),
      initialRoute: '/login',
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
