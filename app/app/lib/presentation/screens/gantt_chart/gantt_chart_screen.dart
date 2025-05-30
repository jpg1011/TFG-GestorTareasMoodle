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
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(color: Color(0xFF212121), width: 2.0),
                borderRadius: BorderRadius.circular(20)
              ),
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              indicatorColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              tabs: const [
                 Tab(text: 'Gantt', icon: Icon(Icons.view_timeline), height: 50),
                 Tab(text: 'Actividades', icon: Icon(Icons.list_alt), height: 50)
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
