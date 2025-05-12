import 'package:app/backend/gantt_chart/gantt_chart_backend.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/gantt_chart/courses_tasks.dart';
import 'package:flutter/material.dart';

class TasksView extends StatefulWidget {
  final List<dynamic> events;
  final List<Courses> coursesToShow;
  final UserModel user;

  const TasksView(
      {super.key,required this.user, required this.events, required this.coursesToShow});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final GanttChartBackend _ganttChartBackend = GanttChartBackend();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: widget.coursesToShow.isNotEmpty 
            ? widget.coursesToShow.map((course) {
                return CoursesTasks(coursename: course.shortname, courseevents: _ganttChartBackend.getCourseEvents(course), courseColor: _ganttChartBackend.generateCoursesColors(widget.user)[course.id]!);
              }).toList()
            : widget.user.userCourses!.map((course){
              return CoursesTasks(coursename: course.shortname, courseevents: _ganttChartBackend.getCourseEvents(course), courseColor: _ganttChartBackend.generateCoursesColors(widget.user)[course.id]!);
            }).toList(),
        ),
      ),
    );
  }
}
