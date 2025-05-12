import 'package:app/presentation/widgets/gantt_chart/task_card.dart';
import 'package:flutter/material.dart';

class CoursesTasks extends StatefulWidget {
  final String coursename;
  final Color courseColor;
  final List<dynamic> courseevents;

  const CoursesTasks(
      {super.key, required this.coursename, required this.courseevents, required this.courseColor});

  @override
  State<CoursesTasks> createState() => _CoursesTasksState();
}

class _CoursesTasksState extends State<CoursesTasks> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: Text(widget.coursename, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)))
              ],
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(widget.courseevents.length, (index) {
              return TaskCard(
                event: widget.courseevents[index],
                taskColor: widget.courseColor,
              );
            }),
          )
        ],
      ),
    );
  }
}
