import 'package:flutter/material.dart';
import 'package:app/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor Tareas UBU',
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 255, 255, 255)),
      initialRoute: '/login',
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
