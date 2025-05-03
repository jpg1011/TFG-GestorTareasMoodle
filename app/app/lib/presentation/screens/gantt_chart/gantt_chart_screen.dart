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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(user: widget.user)));
                            },
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black)),
                        const Spacer()
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: MaterialGanttChart(
                                  style: GanttChartStyle(
                                      pointRadius: 6.0,
                                      showConnections: false,
                                      verticalSpacing: 60.0,
                                      lineColor: Colors.grey,
                                      dateFormat:
                                          DateFormat('MMM dd, y', 'es')),
                                  height: getDiagramSize(widget.events),
                                  width: constraints.maxWidth,
                                  data: widget.events.isNotEmpty
                                      ? widget.events
                                          .map((event) {
                                            if (event.runtimeType == Assign &&
                                                Filters.selectTask) {
                                              return getGanttEvent(event);
                                            } else if (event.runtimeType ==
                                                    Quiz &&
                                                Filters.selectQuiz) {
                                              return getGanttEvent(event);
                                            }
                                            return null;
                                          })
                                          .where((event) => event != null)
                                          .cast<GanttData>()
                                          .toList()
                                      : []),
                            );
                          }),
                        ),
                        Expanded(child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: Column(
                                children: widget.events
                                    .expand((event) {
                                      if (event.runtimeType == Assign &&
                                          Filters.selectTask) {
                                        return [
                                          const SizedBox(height: 16),
                                          generateCard(
                                              event: event,
                                              width: constraints.maxWidth)
                                        ];
                                      } else if (event.runtimeType == Quiz &&
                                          Filters.selectQuiz) {
                                        return [
                                          const SizedBox(height: 16),
                                          generateCard(
                                              event: event,
                                              width: constraints.maxWidth)
                                        ];
                                      }
                                      return [];
                                    })
                                    .cast<Widget>()
                                    .toList(),
                              ),
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.transparent)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(user: widget.user)));
                            },
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: MaterialGanttChart(
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
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            children: widget.events.expand<Widget>((event) {
                              if (event != null) {
                                return [
                                  const SizedBox(height: 16),
                                  generateCard(
                                      event: event, width: constraints.maxWidth)
                                ];
                              }
                              return [];
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget generateCard({required dynamic event, required double width}) {
    return Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          height: 140,
          width: width - 40,
          decoration: const BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 3.0),
                  child: Icon(
                    event.runtimeType == Assign ? Icons.task : Icons.fact_check,
                    color: coursesColors[event.course],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 3.0),
                    child: Text(
                      event.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            const Divider(color: Colors.grey, indent: 20, endIndent: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                      child: Text(
                        widget.user.userCourses!
                            .firstWhere((course) => course.id == event.course)
                            .fullname,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_available, size: 15),
                        Text(DateFormat('MMM dd, y  HH:mm', 'es').format(
                            getStartDate(
                                eventStartDate: event.runtimeType == Assign
                                    ? event.allowsubmissionsfromdate
                                    : event.timeopen,
                                eventEndDate: event.runtimeType == Assign
                                    ? event.duedate
                                    : event.timeclose)))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_busy, size: 15),
                        Text(DateFormat('MMM dd, y  HH:mm', 'es')
                            .format(
                                getEndDate(
                                    eventStartDate: event.runtimeType == Assign
                                        ? event.allowsubmissionsfromdate
                                        : event.timeopen,
                                    eventEndDate: event.runtimeType == Assign
                                        ? event.duedate
                                        : event.timeclose)))
                      ],
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14),
                        const SizedBox(width: 5),
                        Text(_getTimeDifference(
                            DateTime.now(),
                            getEndDate(
                                eventStartDate: event.runtimeType == Assign
                                    ? event.allowsubmissionsfromdate
                                    : event.timeopen,
                                eventEndDate: event.runtimeType == Assign
                                    ? event.duedate
                                    : event.timeclose)))
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.grade, size: 14),
                        const SizedBox(width: 5),
                        Text(_getTaskGrade(event))
                      ],
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }
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
