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
  List<Courses> selectedCourses = [];
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

  _openFilterDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                const Text(
                  'Aañdir filtros',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                TextButton(
                    style: const ButtonStyle(
                        overlayColor: WidgetStatePropertyAll(Colors.white)),
                    onPressed: () {
                      setState(() {
                        _clear();
                      });
                    },
                    child: const Text(
                      'Borrar',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 3.0,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  {'name': 'Cursos', 'function': _openCoursesFilter},
                  {'name': 'Tareas', 'function': _openTypesFilter}
                ].map((element) {
                  return Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              style: ButtonStyle(
                                  overlayColor:
                                      WidgetStatePropertyAll(Colors.grey[100])),
                              onPressed: () {
                                Navigator.pop(context);
                                Future.delayed(Duration.zero, () {
                                  (element['function'] as VoidCallback).call();
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    element['name'] as String,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.black,
                                  )
                                ],
                              )))
                    ],
                  );
                }).toList()),
          );
        });
  }

  _openCoursesFilter() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _openFilterDialog();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text(
                      'Seleccionar cursos',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                backgroundColor: Colors.white,
                elevation: 3.0,
                content: widget.user.userCourses!.isEmpty
                    ? const Text('No hay cursos para filtrar')
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _reorderCourses(widget.user.userCourses!)
                              .map((course) {
                            return FilterChip(
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.white,
                                side: BorderSide.none,
                                label: !selectedCourses.contains(course)
                                    ? Text(course.fullname,
                                        style: const TextStyle(
                                            color: Colors.black))
                                    : Text(course.fullname,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                selected: selectedCourses.contains(course),
                                selectedColor: Colors.blue,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedCourses.add(course);
                                    } else {
                                      selectedCourses.remove(course);
                                    }
                                    _events = getEvents(selectedCourses);
                                  });
                                  setDialogState(() {});
                                });
                          }).toList(),
                        ),
                      ));
          },
        );
      },
    );
  }

  _openTypesFilter() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _openFilterDialog();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text(
                      'Seleccionar tipo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: selectTask ? Colors.blue : Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            selectTask = !selectTask;
                            _events = getEvents(selectedCourses);
                          });
                          setDialogState(() {});
                        },
                        icon: Icon(
                          Icons.task,
                          color: selectTask ? Colors.white : Colors.blue,
                          size: 42,
                        ),
                        isSelected: selectTask,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                        color: selectQuiz ? Colors.blue : Colors.white,
                      ),
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.fact_check,
                          color: selectQuiz ? Colors.white : Colors.blue,
                          size: 42,
                        ),
                        isSelected: selectQuiz,
                        onPressed: () {
                          setState(() {
                            selectQuiz = !selectQuiz;
                            _events = getEvents(selectedCourses);
                          });
                          setDialogState(() {});
                        },
                      ),
                    )
                  ],
                ),
                backgroundColor: Colors.white,
              );
            },
          );
        });
  }

  List<Courses> _reorderCourses(List<Courses> coursesToOrder) {
    List<Courses> orderCourses = coursesToOrder;
    orderCourses.sort((a, b) => a.fullname.compareTo(b.fullname));

    return orderCourses;
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
          endDate: DateTime.fromMillisecondsSinceEpoch(event.timeclose * 1000));
    }
    return GanttAbsoluteEvent(
        displayName: 'No hay eventos',
        startDate: DateTime.now(),
        endDate: DateTime.now());
  }

  _clear() {
    _events = getEvents([]);
    selectedCourses = [];
    selectTask = true;
    selectQuiz = true;
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
                        _openFilterDialog();
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      child: const Icon(Icons.filter_list, color: Colors.white))
                ],
              ),
            ),
            GanttChartView(
              startOfTheWeek: WeekDay.monday,
              weekEnds: const {WeekDay.saturday, WeekDay.sunday},
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
