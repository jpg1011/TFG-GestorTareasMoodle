import 'dart:math';
import 'package:app/models/assign.dart';
import 'package:app/models/quiz.dart';
import 'package:app/presentation/screens/home/home_screen.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_chart/material_charts.dart';
import 'package:app/models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class GanttChartScreen extends StatefulWidget {
  final UserModel user;
  final List<dynamic> events;

  const GanttChartScreen({super.key, required this.user, required this.events});

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  Map<int, Color> coursesColors = {};

  @override
  void initState() {
    super.initState();
    generateCoursesColors();
    initializeDateFormatting('es');
  }

  @override
  void dispose() {
    super.dispose();
  }

  void generateCoursesColors() {
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
    for (var course in widget.user.userCourses!) {
      if (index < 20) {
        coursesColors[course.id] = carrouselColors[index];
        index++;
      } else {
        index = 0;
        coursesColors[course.id] = carrouselColors[index];
        index++;
      }
    }
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

  GanttData getGanttEvent(dynamic event) {
    if (event.runtimeType == Assign && Filters.selectTask) {
      return GanttData(
        label: event.name,
        description: widget.user.userCourses!
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
          description: widget.user.userCourses!
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

  double getDiagramSize(List<dynamic> events) {
    double topDiagram = 20.0;
    double bottomDiagram = 90.0;
    double minSize = MediaQuery.of(context).size.height;
    double size = 0.0;

    if (events.isEmpty) {
      return minSize;
    } else {
      size = events.length * 60 + topDiagram + bottomDiagram;
    }

    return max(size, minSize);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
          children: [
            TabBar(
              indicatorColor: Color(0xFF38373C),
              dividerColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              splashBorderRadius: BorderRadius.circular(20),
              splashFactory: InkSplash.splashFactory,
              tabs: [
                Tab(text: 'Gantt', icon: Icon(Icons.view_timeline)),
                Tab(text: 'Tareas', icon: Icon(Icons.list_alt))
              ]
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MaterialGanttChart(
                          style: const GanttChartStyle(
                              pointRadius: 6.0,
                              showConnections: false,
                              verticalSpacing: 60.0,
                              lineColor: Colors.grey),
                          height: getDiagramSize(widget.events),
                          width: MediaQuery.of(context).size.width,
                          data: widget.events.isNotEmpty
                              ? widget.events.map((event) {
                                  return getGanttEvent(event);
                                }).toList()
                              : [
                                  GanttData(
                                      startDate: DateTime.now(),
                                      endDate: DateTime.now(),
                                      label: 'No hay tareas pendientes'),
                                ]),
                  Container(
                    color: Colors.red,
                  )
                ]
              )
            )
          ],
        )),
      ),
    );
  }

  String _getTimeDifference(DateTime now, DateTime eventEnd) {
    if (now.isBefore(eventEnd)) {
      Duration difference = eventEnd.difference(now);

      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      return "$days d $hours h $minutes m";
    }
    return '--';
  }

  String _getTaskGrade(dynamic event) {
    if (event.runtimeType == Assign) {
      if (event.submission.graded && event.submission.grade != null) {
        if (event.grade == 1 || event.grade == 10 || event.grade == 100) {
          return ((event.submission.grade * 10) / event.grade).toString();
        } else {
          return "--";
        }
      }
    }
    return "--";
  }
}
