import 'package:app/presentation/widgets/gantt_chart/gantt_section/gantt_view.dart';
import 'package:app/presentation/widgets/gantt_chart/task_section/tasks_view.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/models/user_model.dart';

class GanttChartScreen extends StatefulWidget {
  final UserModel user;
  final List<dynamic> events;

  const GanttChartScreen({super.key, required this.user, required this.events});

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                indicatorColor: const Color(0xFF38373C),
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                splashBorderRadius: BorderRadius.circular(20),
                splashFactory: InkSplash.splashFactory,
                tabs: const [
                   Tab(text: 'Gantt', icon: Icon(Icons.view_timeline)),
                   Tab(text: 'Tareas', icon: Icon(Icons.list_alt))
                ]),
            Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GanttView(events: widget.events, user: widget.user),
                    TasksView(user: widget.user, events: widget.events, coursesToShow: Filters.selectedCourses)
            ]))
          ],
        )),
      ),
    );
  }
}
