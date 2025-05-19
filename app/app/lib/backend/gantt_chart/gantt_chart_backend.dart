import 'dart:math';
import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_section/gantt_chart/src/models.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class GanttChartBackend {
  double getDiagramHeight(context,
      {required List<dynamic> events,
      required double verticalSpacing,
      required double top}) {
    double minSize = MediaQuery.of(context).size.height;
    double size = 0.0;

    if (events.isEmpty) {
      return minSize;
    } else {
      size = events.length * verticalSpacing + top + 60;
    }

    return max(size, minSize);
  }

  GanttData getGanttEvent(
      dynamic event, UserModel user, Map<int, Color> coursesColors) {
    if (event.runtimeType == Assign && Filters.selectTask) {
      return GanttData(
        label: event.name,
        description: user.userCourses!
            .firstWhere((course) => course.id == event.course)
            .fullname,
        icon: Icons.task,
        color: coursesColors[event.course],
        startDate: getStartDate(
            eventStartDate: event.allowsubmissionsfromdate,
            eventEndDate: event.duedate),
        endDate: getEndDate(
            eventStartDate: event.allowsubmissionsfromdate,
            eventEndDate: event.duedate),
      );
    } else if (event.runtimeType == Quiz && Filters.selectQuiz) {
      return GanttData(
          label: event.name,
          description: user.userCourses!
              .firstWhere((course) => course.id == event.course)
              .fullname,
          icon: Icons.fact_check,
          color: coursesColors[event.course],
          startDate: getStartDate(
              eventStartDate: event.timeopen, eventEndDate: event.timeclose),
          endDate: getEndDate(
              eventStartDate: event.timeopen, eventEndDate: event.timeclose));
    }
    return GanttData(
        label: 'No hay eventos',
        startDate: DateTime.now(),
        endDate: DateTime.now());
  }

  Map<int, Color> generateCoursesColors(UserModel user) {
    Map<int, Color> coursesColors = {};

    final List<Color> carrouselColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.lime,
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];
    int index = 0;
    for (var course in user.userCourses!) {
      if (index < 20) {
        coursesColors[course.id] = carrouselColors[index];
        index++;
      } else {
        index = 0;
        coursesColors[course.id] = carrouselColors[index];
        index++;
      }
    }

    return coursesColors;
  }

  DateTime getStartDate({int eventStartDate = 0, int eventEndDate = 0}) {
    if (eventStartDate != 0 && eventEndDate == 0) {
      return DateTime.fromMillisecondsSinceEpoch(eventStartDate * 1000);
    } else if (eventStartDate == 0 && eventEndDate != 0) {
      if (DateTime.fromMillisecondsSinceEpoch(eventEndDate * 1000)
          .isBefore(DateTime.now())) {
        return DateTime.fromMillisecondsSinceEpoch(eventEndDate * 1000);
      }
      return DateTime.now();
    } else if (eventStartDate != 0 && eventEndDate != 0) {
      return DateTime.fromMillisecondsSinceEpoch(eventStartDate * 1000);
    } else {
      return DateTime.now();
    }
  }

  DateTime getEndDate({int eventStartDate = 0, int eventEndDate = 0}) {
    if (eventStartDate != 0 && eventEndDate == 0) {
      return DateTime.fromMillisecondsSinceEpoch(eventStartDate * 1000);
    } else if (eventStartDate == 0 && eventEndDate != 0) {
      if (DateTime.fromMillisecondsSinceEpoch(eventEndDate * 1000)
          .isBefore(DateTime.now())) {
        return DateTime.fromMillisecondsSinceEpoch(eventEndDate * 1000);
      }
      return DateTime.now();
    } else if (eventStartDate != 0 && eventEndDate != 0) {
      return DateTime.fromMillisecondsSinceEpoch(eventEndDate * 1000);
    } else {
      return DateTime.now();
    }
  }

  String getTimeDifference(DateTime now, DateTime eventEnd) {
    if (now.isBefore(eventEnd)) {
      Duration difference = eventEnd.difference(now);

      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      return "$days d $hours h $minutes m";
    }
    return '--';
  }

  String getTaskGrade(dynamic event) {
    if (event.runtimeType == Assign) {
      if (event.submission.graded && event.submission.grade != null) {
        return ((event.submission.grade * 10) / event.grade).toString();
      }
    } else {
      if (event.quizgrade.hasgrade && event.quizgrade.grade != null) {
        return num.parse(
                ((event.quizgrade.grade * 10) / event.grade).toString())
            .toStringAsFixed(2);
      }
    }
    return "Sin calificar";
  }

  List<dynamic> getCourseEvents(Courses course, List<dynamic> events) {
    return events.where((event) => event.course == course.id).toList();
  }
}
