import 'dart:collection';
import 'package:app/models/courses.dart';
import 'package:app/models/databases/personaltask_database.dart';
import 'package:app/models/personaltask.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/personal_tasks/widgets/personal_task_column.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PersonalTasksScreen extends StatefulWidget {
  final UserModel user;

  const PersonalTasksScreen({super.key, required this.user});

  @override
  State<PersonalTasksScreen> createState() => _PersonalTasksScreenState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _PersonalTasksScreenState extends State<PersonalTasksScreen> {
  TextEditingController _taskname = TextEditingController();
  TextEditingController _taskdescription = TextEditingController();
  TextEditingController _taskCourse = TextEditingController();
  String? taskCourse;
  DateTime? taskStartDate;
  DateTime? taskEndDate;
  late final PersonalTaskDatabase personalTasksDB;
  List<Map<String, dynamic>>? tasks;
  List<PersonalTask> endedTasks = [];
  List<PersonalTask> urgentTasks = [];
  List<PersonalTask> threeDaysTasks = [];
  List<PersonalTask> sevenDaysTasks = [];
  bool timeView = true;

  @override
  void initState() {
    super.initState();
    MoodleApiService.getMoodleURL().then((moodleURL) {
      setState(() {
        personalTasksDB = PersonalTaskDatabase(
            userid: widget.user.id.toString(), moodleid: moodleURL);
      });
      loadTasks();
    });
  }

  void clearTaskDialog() {
    _taskname.clear();
    _taskdescription.clear();
    _taskCourse.clear();
    taskStartDate = null;
    taskEndDate = null;
  }

  Widget showTasks(PersonalTask task) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description),
    );
  }

  List<PersonalTask> getAllTasks(List<Map<String, dynamic>>? data) {
    List<PersonalTask> tasks = [];

    if (data != null) {
      for (var task in data) {
        tasks.add(PersonalTask.fromMap(task));
      }
    }
    return tasks;
  }

  Future<void> loadTasks() async {
    final personalTasks = await personalTasksDB.getPersonalTasks();
    setState(() {
      tasks = personalTasks;
      getTasksByDeadline();
    });
  }

  getTasksByDeadline() {
    List<PersonalTask> allTask = getAllTasks(tasks);
    DateTime now = DateTime.now();
    endedTasks = allTask.where((task) => task.enddate.isBefore(now)).toList();
    urgentTasks = allTask
        .where((task) =>
            task.enddate.isAfter(now) &&
            task.enddate.isBefore(now.add(const Duration(hours: 24))))
        .toList();
    threeDaysTasks = allTask
        .where((task) =>
            task.enddate.isAfter(now.add(const Duration(hours: 24))) &&
            task.enddate.isBefore(now.add(const Duration(days: 3))))
        .toList();
    sevenDaysTasks = allTask
        .where((task) => task.enddate.isAfter(now.add(const Duration(days: 3))))
        .toList();
    endedTasks.sort((a, b) => a.enddate.compareTo(b.enddate));
    urgentTasks.sort((a, b) => a.enddate.compareTo(b.enddate));
    threeDaysTasks.sort((a, b) => a.enddate.compareTo(b.enddate));
    sevenDaysTasks.sort((a, b) => a.enddate.compareTo(b.enddate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(user: widget.user)));
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.black)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          timeView = !timeView;
                        });
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                      icon: Icon(
                        timeView ? Icons.access_time : Icons.menu_book,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (timeView) {
                    return Row(
                      children: [
                        Expanded(
                            child: PersonalTaskColumn(endedTasks, width: constraints.maxWidth / 4,
                                columnName: 'Tareas finalizadas')),
                        Expanded(
                            child: PersonalTaskColumn(urgentTasks, width: constraints.maxWidth / 4,
                                columnName: 'Tareas urgentes')),
                        Expanded(
                            child: PersonalTaskColumn(threeDaysTasks, width: constraints.maxWidth / 4,
                                columnName: 'Próximos 3 días')),
                        Expanded(
                            child: PersonalTaskColumn(sevenDaysTasks, width: constraints.maxWidth / 4,
                                columnName: '3 días o más')),
                      ],
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: widget.user.userCourses!.map((course) {
                        final courseTasks = getAllTasks(tasks).where((courseTask) => courseTask.course == course.fullname).toList();
                        return PersonalTaskColumn(
                          courseTasks,
                          width: constraints.maxWidth / 4,
                          columnName: course.shortname
                        );
                      }).toList()),
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      onPressed: () {
                        addTaskDialog();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  addTaskDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Nueva tarea',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskname,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintText: 'Nombre de la tarea',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _taskdescription,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Descripción de la tarea',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 10),
                  DropdownMenu(
                    controller: _taskCourse,
                    enableSearch: false,
                    hintText: 'Seleccione curso',
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                        outlineBorder: const BorderSide(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onSelected: (value) {
                      setState(() {
                        taskCourse = value;
                      });
                      setDialogState(() {});
                    },
                    dropdownMenuEntries: UnmodifiableListView<MenuEntry>(
                      widget.user.userCourses!.map<MenuEntry>(
                          (Courses course) => MenuEntry(
                              value: course.fullname, label: course.fullname)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          height: 45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        taskStartDate != null
                                            ? DateFormat('dd/MM/y')
                                                .format(taskStartDate!)
                                            : 'dd/mm/aaaa',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ))),
                              const VerticalDivider(),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? startDate = await showDatePicker(
                                        context: context,
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData(
                                                  useMaterial3: false),
                                              child: child ?? const SizedBox());
                                        },
                                        firstDate: DateTime.now(),
                                        lastDate: taskEndDate ?? DateTime(2100),
                                        locale: const Locale('es', 'ES'),
                                        helpText: 'Fecha inicial',
                                        confirmText: 'Aceptar',
                                        cancelText: 'Cancelar');
                                    setState(() {
                                      taskStartDate = startDate;
                                    });
                                    setDialogState(() {});
                                  },
                                  icon: const Icon(Icons.event_available))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          height: 45,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        taskEndDate != null
                                            ? DateFormat('dd/MM/y')
                                                .format(taskEndDate!)
                                            : 'dd/mm/aaaa',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ))),
                              const VerticalDivider(),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                    onPressed: () async {
                                      DateTime? endDate = await showDatePicker(
                                          context: context,
                                          builder: (context, child) {
                                            return Theme(
                                                data: ThemeData(
                                                    useMaterial3: false),
                                                child:
                                                    child ?? const SizedBox());
                                          },
                                          firstDate:
                                              taskStartDate ?? DateTime.now(),
                                          lastDate: DateTime(2100),
                                          locale: const Locale('es', 'ES'),
                                          helpText: 'Fecha final',
                                          confirmText: 'Aceptar',
                                          cancelText: 'Cancelar');
                                      setState(() {
                                        taskEndDate = endDate;
                                      });
                                      setDialogState(() {});
                                    },
                                    icon: const Icon(Icons.event_busy)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      onPressed: () async {
                        final moodle = await MoodleApiService.getMoodleURL();
                        personalTasksDB
                            .createPersonalTask(PersonalTask(
                                userid: widget.user.id,
                                moodleid: moodle.toString(),
                                name: _taskname.text,
                                description: _taskdescription.text,
                                course: _taskCourse.text,
                                startdate: taskStartDate!,
                                enddate: taskEndDate!))
                            .then((onValue) {
                          loadTasks();
                        });
                        clearTaskDialog();
                        setDialogState(() {});
                      },
                      child: const Text('Crear tarea',
                          style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
