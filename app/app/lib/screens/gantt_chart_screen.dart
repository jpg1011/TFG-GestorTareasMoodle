import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:app/models/user_model.dart';

class GanttChartScreen extends StatefulWidget {
  final UserModel user;

  const GanttChartScreen({super.key, required this.user});

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  List<GanttAbsoluteEvent> getEvents() {
    var events = <GanttAbsoluteEvent>[];
    for (var course in widget.user.userCourses!) {
      if (course.assignments != null) {
        for (var event in course.assignments!) {
          if(event.duedate*1000 >= DateTime.now().millisecondsSinceEpoch){
            events.add(GanttAbsoluteEvent(
              startDate: DateTime.fromMillisecondsSinceEpoch(event.allowsubmissionsfromdate*1000),
              endDate: DateTime.fromMillisecondsSinceEpoch(event.duedate*1000),
              displayName: event.name
            )
          );
          }
        }

        for (var event in course.quizzes!) {
          if(event.timeclose*1000 >= DateTime.now().millisecondsSinceEpoch){
            events.add(GanttAbsoluteEvent(
              startDate: DateTime.fromMillisecondsSinceEpoch(event.timeopen*1000),
              endDate: DateTime.fromMillisecondsSinceEpoch(event.timeclose*1000),
              displayName: event.name
            )
          );
          }
        }
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Diagrama Gantt"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: GanttChartView(
        startOfTheWeek: WeekDay.monday,
        weekEnds: {WeekDay.saturday, WeekDay.sunday},
        startDate: DateTime(2025, 1, 30),
        events: getEvents()
      ),
    );
  }
}
