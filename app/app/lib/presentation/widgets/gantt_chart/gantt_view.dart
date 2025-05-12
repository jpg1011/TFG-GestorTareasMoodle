import 'package:app/backend/gantt_chart/gantt_chart_backend.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_chart/src/models.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_chart/src/widgets.dart';
import 'package:flutter/material.dart';

class GanttView extends StatefulWidget {
  final List<dynamic> events;
  final UserModel user;

  const GanttView({super.key, required this.events, required this.user});

  @override
  State<GanttView> createState() => _GanttViewState();
}

class _GanttViewState extends State<GanttView> {
  final GanttChartBackend _ganttChartBackend = GanttChartBackend();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MaterialGanttChart(
          style: const GanttChartStyle(
              pointRadius: 6.0,
              showConnections: false,
              verticalSpacing: 60.0,
              lineColor: Colors.grey),
          height: _ganttChartBackend.getDiagramSize(context, widget.events),
          width: MediaQuery.of(context).size.width,
          data: widget.events.isNotEmpty
              ? widget.events.map((event) {
                  return _ganttChartBackend.getGanttEvent(event, widget.user, _ganttChartBackend.generateCoursesColors(widget.user));
                }).toList()
              : [
                  GanttData(
                      startDate: DateTime.now(),
                      endDate: DateTime.now(),
                      label: 'No hay tareas pendientes'),
                ]),
    );
  }
}
