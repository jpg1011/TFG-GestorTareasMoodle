import 'package:app/backend/gantt_chart/gantt_chart_backend.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_section/gantt_chart/src/models.dart';
import 'package:app/presentation/widgets/gantt_chart/gantt_section/gantt_chart/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GanttView extends StatefulWidget {
  final List<dynamic> events;
  final UserModel user;

  const GanttView({super.key, required this.events, required this.user});

  @override
  State<GanttView> createState() => _GanttViewState();
}

class _GanttViewState extends State<GanttView> {
  final GanttChartBackend _ganttChartBackend = GanttChartBackend();
  double currentSliderWidthValue = 0;
  double currentSliderSpacingValue = 60.0;
  bool sliderInUse = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          constrained: false,
          minScale: 0.5,
          maxScale: 2.0,
          boundaryMargin: const EdgeInsets.only(bottom: 60),
          panEnabled: true,
          child: MaterialGanttChart(
            style: GanttChartStyle(
              pointRadius: 6.0,
              showConnections: false,
              verticalSpacing: currentSliderSpacingValue,
              horizontalPadding: 50,
              lineColor: const Color(0xFF212121),
              connectionLineColor: const Color(0xFF212121),
              labelOffset: 10.0,
            ),
            height: _ganttChartBackend.getDiagramHeight(context,
                events: widget.events,
                verticalSpacing: currentSliderSpacingValue,
                top: 50),
            width: MediaQuery.of(context).size.width + currentSliderWidthValue,
            data: widget.events.isNotEmpty
                ? widget.events.map((event) {
                    return _ganttChartBackend.getGanttEvent(event, widget.user,
                        _ganttChartBackend.generateCoursesColors(widget.user));
                  }).toList()
                : [
                    GanttData(
                      startDate: DateTime.now(),
                      endDate: DateTime.now(),
                      label: 'No hay tareas pendientes',
                    ),
                  ],
          ),
        ),
        SlidingUpPanel(
          minHeight: 45,
          isDraggable: !sliderInUse,
          panelBuilder: (sc) => _panel(sc),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        )
      ],
    );
  }

  Widget _panel(ScrollController sc) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: sc,
      children: [
        SizedBox(
          height: 50,
          child: Center(
            child: Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Configurar diagrama',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            )
          ],
        ),
       const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Ancho del diagrama',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Slider(
          label: currentSliderWidthValue.round().toString(),
          value: currentSliderWidthValue,
          max: 1000,
          divisions: 10,
          onChangeStart: (value) => setState(() => sliderInUse = true),
          onChangeEnd: (value) => setState(() => sliderInUse = false),
          onChanged: (value) {
            setState(() {
              currentSliderWidthValue = value;
            });
          },
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Espacio vertical entre actividades',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Slider(
          label: currentSliderSpacingValue.round().toString(),
          value: currentSliderSpacingValue,
          min: 60,
          max: 200,
          divisions: 14,
          onChangeStart: (value) => setState(() => sliderInUse = true),
          onChangeEnd: (value) => setState(() => sliderInUse = false),
          onChanged: (value) {
            setState(() {
              currentSliderSpacingValue = value;
            });
          },
        ),
      ],
    );
  }
}
