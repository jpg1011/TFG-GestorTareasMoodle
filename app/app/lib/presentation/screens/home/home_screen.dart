import 'package:app/backend/home/home_backend.dart';
import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:app/presentation/screens/personal_tasks/personal_tasks_screen.dart';
import 'package:app/presentation/widgets/home/Filters/custom_chip.dart';
import 'package:app/presentation/widgets/home/home_features_botton.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/screens/gantt_chart/gantt_chart_screen.dart';
import 'package:app/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBackend homeBackend;
  String getFirstname() {
    final name = widget.user.fullname.split(', ');
    return name.last;
  }

  @override
  void initState() {
    super.initState();
    homeBackend = HomeBackend(user: widget.user);
    homeBackend.loadSavedFilters();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xFF38373C),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Inicio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 34,
                                color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(widget.user.profileimageurl!),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.exit_to_app,
                                color: Colors.white),
                            onPressed: () async {
                              await MoodleApiService.logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '¡Hola, ${getFirstname()}! 👋',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              HomeFeaturesBotton(
                  label: 'Gantt',
                  icon: const Icon(Icons.view_timeline),
                  imgPath: 'assets/ganttPreview.png',
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  GanttChartScreen(
                                      user: widget.user,
                                      events: homeBackend.getEvents(Filters.selectedCourses,
                                          startDate: Filters.ganttStartDate,
                                          endDate: Filters.ganttEndDate)),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                                position: animation.drive(Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.ease))),
                                child: child);
                          },
                        ));
                  }),
              const SizedBox(height: 20),
              HomeFeaturesBotton(
                  label: 'Tareas',
                  icon: const Icon(Icons.list_alt),
                  imgPath: 'assets/logoUBU.png',
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PersonalTasksScreen(user: widget.user),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                                position: animation.drive(Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.ease))),
                                child: child);
                          },
                        ));
                  }),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38373C),
                            shape: const CircleBorder(),
                            fixedSize: const Size(60, 60),
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero),
                        onPressed: () {
                          _openFilterDialog();
                        },
                        child: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                            homeBackend.clear();
                          });
                          homeBackend.saveFilters();
                          setDialogState(() {});
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
                                lastDate: Filters.ganttEndDate ??
                                    DateTime.now()
                                        .add(const Duration(days: 365)),
                                locale: const Locale('es', 'ES'),
                                helpText: 'Fecha inicial',
                                confirmText: 'Aceptar',
                                cancelText: 'Cancelar');
                            setState(() {
                              Filters.ganttStartDate = startDate;
                              Filters.events = homeBackend.getEvents(
                                  Filters.selectedCourses,
                                  startDate: Filters.ganttStartDate,
                                  endDate: Filters.ganttEndDate);
                              homeBackend.saveFilters();
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
                              Filters.ganttStartDate != null
                                  ? DateFormat('dd/MM/y')
                                      .format(Filters.ganttStartDate!)
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
                              firstDate: Filters.ganttStartDate ??
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
                              Filters.ganttEndDate = endDate;
                              Filters.events = homeBackend.getEvents(
                                  Filters.selectedCourses,
                                  startDate: Filters.ganttStartDate,
                                  endDate: Filters.ganttEndDate);
                              homeBackend.saveFilters();
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
                              Filters.ganttEndDate != null
                                  ? DateFormat('dd/MM/y')
                                      .format(Filters.ganttEndDate!)
                                  : 'dd/mm/aaaa',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.7)),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          fillColor: WidgetStatePropertyAll(
                              Filters.openingDate ? Colors.blue : Colors.white),
                          value: Filters.openingDate,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                Filters.openingDate = value;
                                Filters.events =
                                    homeBackend.getEvents(Filters.selectedCourses);
                              }
                            });
                            homeBackend.saveFilters();
                            setDialogState(() {});
                          }),
                      const Expanded(child: Text('Fecha apertura')),
                      Checkbox(
                          fillColor: WidgetStatePropertyAll(
                              Filters.closingDate ? Colors.blue : Colors.white),
                          value: Filters.closingDate,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                Filters.closingDate = value;
                                Filters.events =
                                    homeBackend.getEvents(Filters.selectedCourses);
                              }
                            });
                            homeBackend.saveFilters();
                            setDialogState(() {});
                          }),
                      const Expanded(child: Text('Fecha cierre'))
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
                          children: homeBackend.reorderCourses(widget.user.userCourses!)
                              .map((course) {
                            return CustomChip(course: course, user: widget.user);
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
                        color: Filters.selectTask ? Colors.blue : Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            Filters.selectTask = !Filters.selectTask;
                            Filters.events = homeBackend.getEvents(Filters.selectedCourses);
                          });
                          homeBackend.saveFilters();
                          setDialogState(() {});
                        },
                        icon: Icon(
                          Icons.task,
                          color:
                              Filters.selectTask ? Colors.white : Colors.blue,
                          size: 42,
                        ),
                        isSelected: Filters.selectTask,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                        color: Filters.selectQuiz ? Colors.blue : Colors.white,
                      ),
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.fact_check,
                          color:
                              Filters.selectQuiz ? Colors.white : Colors.blue,
                          size: 42,
                        ),
                        isSelected: Filters.selectQuiz,
                        onPressed: () {
                          setState(() {
                            Filters.selectQuiz = !Filters.selectQuiz;
                            Filters.events = homeBackend.getEvents(Filters.selectedCourses);
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
}
