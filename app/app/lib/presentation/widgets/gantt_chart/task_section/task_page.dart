import 'package:app/backend/gantt_chart/gantt_chart_backend.dart';
import 'package:app/models/assign.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatelessWidget {
  
  final GanttChartBackend _ganttChartBackend = GanttChartBackend();
  final dynamic event;
  final Color taskColor;

  TaskPage({super.key, required this.event, required this.taskColor});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.20,
                  color: taskColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back, color: Colors.white)
                          )
                        ],
                      ),
                      Center(
                        child: Icon(
                          event.runtimeType == Assign
                                  ? Icons.task
                                  : Icons.fact_check,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(event.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center),
                    ),
                    Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: HtmlWidget(event.intro ?? '')
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Fecha de apertura',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(event.runtimeType == Assign
                          ? (event.allowsubmissionsfromdate != 0
                              ? DateFormat(
                                      "dd 'de' MMMM 'de' yyyy, 'a' 'las' HH:mm",
                                      'es')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      event.allowsubmissionsfromdate * 1000))
                              : '')
                          : (event.timeopen != 0
                              ? DateFormat(
                                      "dd 'de' MMMM 'de' yyyy, 'a' 'las' HH:mm",
                                      'es')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      event.timeopen * 1000))
                              : '')),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Fecha de cierre',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(event.runtimeType == Assign
                          ? (event.duedate != 0
                              ? DateFormat(
                                      "dd 'de' MMMM 'de' yyyy, 'a' 'las' HH:mm",
                                      'es')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      event.duedate * 1000))
                              : '')
                          : (event.timeclose != 0
                              ? DateFormat(
                                      "dd 'de' MMMM 'de' yyyy, 'a' 'las' HH:mm",
                                      'es')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      event.timeclose * 1000))
                              : '')),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Estado de entrega',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(event.runtimeType == Assign
                          ? (event.submission.submitted
                              ? 'Entregado'
                              : 'No entregado')
                          : ''),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Calificación',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('${_ganttChartBackend.getTaskGrade(event)}/10'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
