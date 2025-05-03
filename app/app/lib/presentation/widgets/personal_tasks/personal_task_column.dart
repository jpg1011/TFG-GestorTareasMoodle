import 'package:app/models/personaltask.dart';
import 'package:app/presentation/widgets/personal_tasks/personal_task_card.dart';
import 'package:flutter/material.dart';

class PersonalTaskColumn extends StatelessWidget {
  final List<PersonalTask> tasks;
  final String columnName;
  final double width;
  const PersonalTaskColumn(this.tasks, {super.key, required this.columnName, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(columnName, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: tasks.map((task) => PersonalTaskCard(task)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
