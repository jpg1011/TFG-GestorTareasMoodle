import 'package:flutter/material.dart';
import 'package:app/screens/gantt_chart_screen.dart';
import 'package:app/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bienvenido'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GanttChartScreen(user: widget.user)));
                },
                child: const Text("Tareas Gantt"))
          ],
        ),
      ),
    );
  }
}
