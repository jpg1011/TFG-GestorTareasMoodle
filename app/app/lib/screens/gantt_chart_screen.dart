import 'dart:math';
import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/gantt_chart/material_charts.dart';
import 'package:app/models/user_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class GanttChartScreen extends StatefulWidget {
  final UserModel user;

  const GanttChartScreen({super.key, required this.user});

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  List<dynamic> _events = [];
  List<Courses> selectedCourses = [];
  bool selectTask = true;
  bool selectQuiz = true;
  Map<int, Color> coursesColors = {};
  DateTime? ganttStartDate;
  DateTime? ganttEndDate;

  List<dynamic> getEvents(List<Courses> selectedCourses,
      {DateTime? startDate, DateTime? endDate}) {
    List<dynamic> events = [];

    final coursesToShow = selectedCourses.isEmpty
        ? widget.user.userCourses!
        : widget.user.userCourses!
            .where((course) => selectedCourses.contains(course));

    for (var course in coursesToShow) {
      if (course.assignments != null && selectTask) {
        List<Assign> orderedAssignments =
            reorderAssignments(course.assignments!);
        for (var event in orderedAssignments) {
          DateTime eventDate =
              DateTime.fromMillisecondsSinceEpoch(event.duedate * 1000);
          bool include = false;
          if (startDate != null && endDate != null) {
            include = (eventDate.isAfter(startDate) ||
                    eventDate.isAtSameMomentAs(startDate)) &&
                (eventDate.isBefore(endDate) ||
                    eventDate.isAtSameMomentAs(endDate));
          } else if (startDate != null && endDate == null) {
            include = eventDate.isAfter(startDate) ||
                eventDate.isAtSameMomentAs(startDate);
          } else if (startDate == null && endDate != null) {
            include = eventDate.isBefore(endDate) ||
                eventDate.isAtSameMomentAs(endDate);
          } else if (startDate == null && endDate == null) {
            include = true;
          }

          if (include) {
            events.add(event);
          }
        }
      }

      if (course.quizzes != null && selectQuiz) {
        List<Quiz> orderedQuizzes = reorderQuizzes(course.quizzes!);
        for (var event in orderedQuizzes) {
          DateTime eventDate =
              DateTime.fromMillisecondsSinceEpoch(event.timeclose * 1000);
          bool include = false;
          if (startDate != null && endDate != null) {
            include = (eventDate.isAfter(startDate) ||
                    eventDate.isAtSameMomentAs(startDate)) &&
                (eventDate.isBefore(endDate) ||
                    eventDate.isAtSameMomentAs(endDate));
          } else if (startDate != null && endDate == null) {
            include = eventDate.isAfter(startDate) ||
                eventDate.isAtSameMomentAs(startDate);
          } else if (startDate == null && endDate != null) {
            include = eventDate.isBefore(endDate) ||
                eventDate.isAtSameMomentAs(endDate);
          } else if (startDate == null && endDate == null) {
            include = true;
          }

          if (include) {
            events.add(event);
          }
        }
      }
    }

    return events;
  }

  List<Assign> reorderAssignments(List<Assign> listToOrder) {
    List<Assign> orderedList = List.from(listToOrder);
    orderedList.sort((a, b) => a.duedate.compareTo(b.duedate));
    return orderedList;
  }

  List<Quiz> reorderQuizzes(List<Quiz> listToOrder) {
    List<Quiz> orderedList = List.from(listToOrder);
    orderedList.sort((a, b) => a.timeclose.compareTo(b.timeclose));
    return orderedList;
  }

  @override
  void initState() {
    super.initState();
    _events = getEvents([]);
    selectTask = true;
    selectQuiz = true;
    generateCoursesColors();
    initializeDateFormatting('es');
  }

  _openFilterDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Row(
                  children: [
                    const Text(
                      'Añadir filtros',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
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
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [
                    Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.grey[100])),
                            onPressed: () {
                              Navigator.pop(context);
                              Future.delayed(Duration.zero, () {
                                _openCoursesFilter();
                              });
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Cursos',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                )
                              ],
                            )))
                  ]),
                  Row(children: [
                    Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.grey[100])),
                            onPressed: () {
                              Navigator.pop(context);
                              Future.delayed(Duration.zero, () {
                                _openTypesFilter();
                              });
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'Tareas',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                )
                              ],
                            )))
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? startDate = await showDatePicker(
                                context: context,
                                builder: (context, child) {
                                  return Theme(
                                      data: ThemeData(useMaterial3: false),
                                      child: child ?? const SizedBox());
                                },
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: ganttEndDate ??
                                    DateTime.now()
                                        .add(const Duration(days: 365)),
                                locale: const Locale('es', 'ES'),
                                helpText: 'Fecha inicial',
                                confirmText: 'Aceptar',
                                cancelText: 'Cancelar');
                            setState(() {
                              ganttStartDate = startDate;
                              _events = getEvents(selectedCourses, startDate: ganttStartDate, endDate:ganttEndDate);
                              setDialogState(() {});
                            });
                          },
                          child: Container(
                            height: 27,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              ganttStartDate != null
                                  ? DateFormat('dd/MM/y')
                                      .format(ganttStartDate!)
                                  : 'dd/mm/aaaa',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7)),
                            )),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_right),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? endDate = await showDatePicker(
                              context: context,
                              builder: (context, child) {
                                return Theme(
                                    data: ThemeData(useMaterial3: false),
                                    child: child ?? const SizedBox());
                              },
                              firstDate: ganttStartDate ??
                                  DateTime.now()
                                      .subtract(const Duration(days: 365)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              locale: const Locale('es', 'ES'),
                              helpText: 'Fecha final',
                              confirmText: 'Aceptar',
                              cancelText: 'Cancelar',
                            );
                            setState(() {
                              ganttEndDate = endDate;
                              _events = getEvents(selectedCourses, startDate: ganttStartDate, endDate:ganttEndDate);
                              setDialogState(() {});
                            });
                          },
                          child: Container(
                            height: 27,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              ganttEndDate != null
                                  ? DateFormat('dd/MM/y').format(ganttEndDate!)
                                  : 'dd/mm/aaaa',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7)),
                            )),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              );
            },
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
    List<Courses> orderCourses = List.from(coursesToOrder);
    orderCourses.sort((a, b) => a.fullname.compareTo(b.fullname));
    return orderCourses;
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
    if (event.runtimeType == Assign && selectTask) {
      print(getStartDate(
          eventStartDate: event.allowsubmissionsfromdate,
          eventEndDate: event.duedate));

      print(getEndDate(
          eventStartDate: event.allowsubmissionsfromdate,
          eventEndDate: event.duedate));
      print(event.name);
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
    } else if (event.runtimeType == Quiz && selectQuiz) {
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

  _clear() {
    _events = getEvents([]);
    selectedCourses = [];
    selectTask = true;
    selectQuiz = true;
  }

  double getDiagramSize(List<dynamic> events) {
    double topDiagram = 20.0;
    double bottomDiagram = 90.0;
    double minSize = MediaQuery.of(context).size.height;
    double size = 0.0;

    if (events.isEmpty) {
      return minSize;
    } else {
      size = _events.length * 60 + topDiagram + bottomDiagram;
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
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              _openFilterDialog();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blue)),
                            child: const Icon(Icons.filter_list,
                                color: Colors.white))
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
                                  height: getDiagramSize(_events),
                                  width: constraints.maxWidth,
                                  data: _events.isNotEmpty
                                      ? _events
                                          .map((event) {
                                            if (event.runtimeType == Assign &&
                                                selectTask) {
                                              return getGanttEvent(event);
                                            } else if (event.runtimeType ==
                                                    Quiz &&
                                                selectQuiz) {
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
                                children: _events
                                    .expand((event) {
                                      if (event.runtimeType == Assign &&
                                          selectTask) {
                                        return [
                                          const SizedBox(height: 16),
                                          generateCard(
                                              event: event,
                                              width: constraints.maxWidth)
                                        ];
                                      } else if (event.runtimeType == Quiz &&
                                          selectQuiz) {
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
                        ElevatedButton(
                            onPressed: () {
                              _openFilterDialog();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blue)),
                            child: const Icon(Icons.filter_list,
                                color: Colors.white))
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
                          height: getDiagramSize(_events),
                          width: MediaQuery.of(context).size.width,
                          data: _events.isNotEmpty
                              ? _events.map((event) {
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
                            children: _events
                                .expand((event) => [
                                      const SizedBox(height: 16),
                                      generateCard(
                                          event: event,
                                          width: constraints.maxWidth)
                                    ])
                                .toList(),
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
    if (event.submission.graded) {
      if (event.grade == 1 || event.grade == 10 || event.grade == 100) {
        return ((event.submission.grade * 10) / event.grade).toString();
      } else {
        return "--";
      }
    }
  }
  return "--";
}
