import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
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
  List<dynamic> _events = [];
  bool selectTask = false;
  bool selectQuiz = false;

  List<dynamic> getEvents(List<Courses> selectedCourses) {
    List<dynamic> events = [];

    final coursesToShow = selectedCourses.isEmpty
        ? widget.user.userCourses!
        : widget.user.userCourses!
            .where((course) => selectedCourses.contains(course));

    for (var course in coursesToShow) {
      if (course.assignments != null) {
        for (var event in course.assignments!) {
          if (event.duedate * 1000 >= DateTime.now().millisecondsSinceEpoch) {
            events.add(event);
          }
        }
      }

      if (course.quizzes != null) {
        for (var event in course.quizzes!) {
          if (event.timeclose * 1000 >= DateTime.now().millisecondsSinceEpoch) {
            events.add(event);
          }
        }
      }
    }

    return events;
  }

  @override
  void initState() {
    super.initState();
    _events = getEvents([]);
    selectTask = true;
    selectQuiz = true;
  }

  Future<void> _showFilterMenu(BuildContext context) async {
    final List<dynamic> types = [Assign, Quiz];

    final List<Courses>? selectedCourses =
        await showModalBottomSheet<List<Courses>>(
            context: context,
            builder: (BuildContext context) {
              List<Courses> coursesToFilter = [];
              return StatefulBuilder(builder: (BuildContext context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Filtrar diagrama',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 5.0,
                        children: [
                          ...widget.user.userCourses!.map((course) {
                            return FilterChip(
                                label: Text(course.shortname),
                                selected: coursesToFilter.contains(course),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      coursesToFilter.add(course);
                                    } else {
                                      coursesToFilter.remove(course);
                                    }
                                  });
                                });
                          })
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilterChip(
                            label: const Text('Tareas'),
                            selected: selectTask,
                            onSelected: (bool value) {
                              setState(
                                () {
                                  if (value) {
                                    selectTask = value;
                                  } else {
                                    selectTask = false;
                                  }
                                },
                              );
                            },
                          ),
                          FilterChip(
                            label: const Text('Cuestionarios'),
                            selected: selectQuiz,
                            onSelected: (bool value) {
                              setState(
                                () {
                                  if (value) {
                                    selectQuiz = value;
                                  } else {
                                    selectQuiz = false;
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar')),
                          ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, coursesToFilter),
                              child: const Text('Aceptar'))
                        ],
                      ),
                    ],
                  ),
                );
              });
            });

    if (selectedCourses != null) {
      setState(() {
        _events = getEvents(selectedCourses);
      });
    }
  }

  GanttAbsoluteEvent getGanttEvent(dynamic event) {
    if (event.runtimeType == Assign && selectTask) {
      return GanttAbsoluteEvent(
        displayName: event.name,
        startDate: DateTime.fromMillisecondsSinceEpoch(
            event.allowsubmissionsfromdate * 1000),
        endDate: DateTime.fromMillisecondsSinceEpoch(event.duedate * 1000),
      );
    } else if (event.runtimeType == Quiz && selectQuiz) {
      return GanttAbsoluteEvent(
          displayName: event.name,
          startDate: DateTime.fromMillisecondsSinceEpoch(event.timeopen * 1000),
          endDate: DateTime.fromMillisecondsSinceEpoch(event.timeclose * 1000)
      );
    }
    return GanttAbsoluteEvent(
        displayName: 'No hay eventos',
        startDate: DateTime.now(),
        endDate: DateTime.now()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Diagrama Gantt"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _showFilterMenu(context);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.cyan[100])),
                      child: const Icon(Icons.filter_list, color: Colors.white))
                ],
              ),
            ),
            GanttChartView(
              startOfTheWeek: WeekDay.monday,
              weekEnds: {WeekDay.saturday, WeekDay.sunday},
              startDate: DateTime(2025, 1, 30),
              events: _events.isEmpty
                  ? []
                  : _events.map((event) {
                      return getGanttEvent(event);
                    }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
