import 'package:app/backend/personal_tasks/personal_tasks_backend.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/databases/personaltask_database.dart';
import 'package:app/models/personaltask.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/personal_tasks/create_task_page.dart';
import 'package:app/presentation/widgets/personal_tasks/task_card.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:app/utils/constants.dart';
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
  PersonalTaskDatabase? personalTasksDB;
  List<PersonalTask> doneTasks = [];
  List<PersonalTask> undoneTasks = [];

  @override
  void initState() {
    super.initState();
    MoodleApiService.getMoodleURL().then((moodleURL) {
      if (!mounted) return;
      setState(() {
        personalTasksDB = PersonalTaskDatabase(
            userid: widget.user.id.toString(), moodleid: moodleURL);
      });
      loadTasks();
    });
  }

  Future<void> loadTasks() async {
    final personalTasks = await personalTasksDB!.getPersonalTasks();
    bool include = false;

    List<PersonalTask> done = [];
    List<PersonalTask> undone = [];

    for (var task in personalTasks) {
      DateTime date = DateTime.parse(task['date']);
      if (Filters.selectedCourses.isNotEmpty) {
        Courses? course;
        try {
          course = widget.user.userCourses!
              .firstWhere((course) => course.shortname == task['course']);
        } catch (e) {
          course = null;
        }

        if (course != null && Filters.selectedCourses.contains(course)) {
          if (Filters.ganttStartDate != null && Filters.ganttEndDate != null) {
            include = (Filters.ganttStartDate!.isBefore(date) ||
                    sameDay(Filters.ganttStartDate!, date)) &&
                (Filters.ganttEndDate!.isAfter(date) ||
                    sameDay(Filters.ganttEndDate!, date));
          } else if (Filters.ganttStartDate == null &&
              Filters.ganttEndDate != null) {
            include = Filters.ganttEndDate!.isBefore(date) ||
                sameDay(Filters.ganttEndDate!, date);
          } else if (Filters.ganttStartDate != null &&
              Filters.ganttEndDate == null) {
            include = Filters.ganttStartDate!.isAfter(date) ||
                sameDay(Filters.ganttStartDate!, date);
          } else {
            include = true;
          }

          if (include) {
            if (task['done']) {
              done.add(PersonalTask.fromMap(task));
            } else {
              undone.add(PersonalTask.fromMap(task));
            }
          }
        }
      } else {
        if (Filters.ganttStartDate != null && Filters.ganttEndDate != null) {
          include = (Filters.ganttStartDate!.isBefore(date) ||
                  sameDay(Filters.ganttStartDate!, date)) &&
              (Filters.ganttEndDate!.isAfter(date) ||
                  sameDay(Filters.ganttEndDate!, date));
        } else if (Filters.ganttStartDate == null &&
            Filters.ganttEndDate != null) {
          include = Filters.ganttEndDate!.isBefore(date) ||
              sameDay(Filters.ganttEndDate!, date);
        } else if (Filters.ganttStartDate != null &&
            Filters.ganttEndDate == null) {
          include = Filters.ganttStartDate!.isAfter(date) ||
              sameDay(Filters.ganttStartDate!, date);
        } else {
          include = true;
        }

        if (include) {
          if (task['done']) {
            done.add(PersonalTask.fromMap(task));
          } else {
            undone.add(PersonalTask.fromMap(task));
          }
        }
      }
    }
    setState(() {
      doneTasks = done;
      undoneTasks = undone;
    });
  }

  bool sameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (personalTasksDB == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                  splashBorderRadius: BorderRadius.circular(50),
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  tabs: const [
                    Tab(text: 'Pendientes'),
                    Tab(text: 'Completadas')
                  ]),
              Expanded(
                child: TabBarView(children: [
                  SecondaryTabBar(
                      tasks: undoneTasks,
                      tabs: const ['Hoy', 'Mañana', 'Esta semana', 'Todos'],
                      done: false,
                      personalTaskDatabase: personalTasksDB!,
                      refreshTasks: loadTasks),
                  SecondaryTabBar(
                    tasks: doneTasks,
                    tabs: const ['Hoy', 'Últimos 7d', 'Este mes', 'Todos'],
                    done: true,
                    personalTaskDatabase: personalTasksDB!,
                    refreshTasks: loadTasks,
                  )
                ]),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateTaskPage(
                            user: widget.user,
                            refreshTasks: loadTasks,
                          )));
            },
            backgroundColor: const Color(0xFF38373C),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}

class SecondaryTabBar extends StatefulWidget {
  final List<PersonalTask> tasks;
  final List<String> tabs;
  final bool done;
  final PersonalTaskDatabase personalTaskDatabase;
  final Future<void> Function() refreshTasks;

  const SecondaryTabBar(
      {super.key,
      required this.tasks,
      required this.tabs,
      required this.done,
      required this.personalTaskDatabase,
      required this.refreshTasks});

  @override
  State<SecondaryTabBar> createState() => _SecondaryTabBarState();
}

class _SecondaryTabBarState extends State<SecondaryTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final PersonalTasksBackend _personalTasksBackend = PersonalTasksBackend();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar.secondary(
            isScrollable: true,
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            splashBorderRadius: BorderRadius.circular(50),
            indicatorSize: TabBarIndicatorSize.tab,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            tabs: widget.tabs
                .map((tab) => Tab(
                      text: tab,
                    ))
                .toList()),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: widget.tabs.map((tab) {
                  final filtered = widget.done
                      ? _personalTasksBackend.filterDoneTask(tasks: widget.tasks, tab: tab)
                      : _personalTasksBackend.filterUnDoneTask(tasks: widget.tasks, tab: tab);

                  filtered.sort((a, b) => widget.done
                      ? a.finishedat!.compareTo(b.finishedat!)
                      : a.date.compareTo(b.date));

                  return TabBarListView(
                    tasks: filtered,
                    done: widget.done,
                    personalTaskDatabase: widget.personalTaskDatabase,
                    refreshTasks: widget.refreshTasks,
                  );
                }).toList()))
      ],
    );
  }
}

class TabBarListView extends StatelessWidget {
  List<PersonalTask> tasks;
  bool done;
  final PersonalTaskDatabase personalTaskDatabase;
  final Future<void> Function() refreshTasks;

  TabBarListView(
      {super.key,
      required this.tasks,
      required this.done,
      required this.personalTaskDatabase,
      required this.refreshTasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No hay tareas disponibles'));
    }

    Map<DateTime, List<PersonalTask>> days = {};

    for (var task in tasks) {
      DateTime day = DateTime(
          done ? task.finishedat!.year : task.date.year,
          done ? task.finishedat!.month : task.date.month,
          done ? task.finishedat!.day : task.date.day);

      if (!days.containsKey(day)) {
        days[day] = [];
      }
      days[day]!.add(task);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: days.keys.expand((day) {
            final dayTasks = days[day]!;
            return [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  DateFormat('EEEE-dd MMM', 'es').format(day),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ...dayTasks.expand((task) {
                return [
                  TaskCard(
                      task: task,
                      personalTasksDB: personalTaskDatabase,
                      refreshTasks: refreshTasks),
                  const Divider()
                ];
              })
            ];
          }).toList(),
        ),
      ),
    );
  }
}
