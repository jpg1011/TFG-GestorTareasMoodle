import 'package:app/backend/home/home_backend.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/home/filters/courses_filter_dialog.dart';
import 'package:app/presentation/widgets/home/filters/types_filter_dialog.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatefulWidget {
  final HomeBackend homeBackend;
  final UserModel user;

  const FilterDialog(
      {super.key, required this.homeBackend, required this.user});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text(
            'Añadir filtros',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          TextButton(
              style: const ButtonStyle(
                  overlayColor: WidgetStatePropertyAll(Colors.white)),
              onPressed: () {
                setState(() {
                  widget.homeBackend.clear();
                });
                widget.homeBackend.saveFilters();
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
                      overlayColor: WidgetStatePropertyAll(Colors.grey[100])),
                  onPressed: () async {
                    Navigator.pop(context);
                    await showDialog(
                      context: context,
                      builder: (context) => CoursesFilterDialog(
                          homeBackend: widget.homeBackend, user: widget.user),
                    );
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
                      overlayColor: WidgetStatePropertyAll(Colors.grey[100])),
                  onPressed: () async {
                    Navigator.pop(context);
                    await showDialog(
                      context: context, 
                      builder: (context) => TypesFilterDialog(homeBackend: widget.homeBackend, user: widget.user),
                    );
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
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: Filters.ganttEndDate ??
                          DateTime.now().add(const Duration(days: 365)),
                      locale: const Locale('es', 'ES'),
                      helpText: 'Fecha inicial',
                      confirmText: 'Aceptar',
                      cancelText: 'Cancelar');
                  setState(() {
                    Filters.ganttStartDate = startDate;
                    Filters.events = widget.homeBackend.getEvents(
                        Filters.selectedCourses,
                        startDate: Filters.ganttStartDate,
                        endDate: Filters.ganttEndDate);
                    widget.homeBackend.saveFilters();
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
                        ? DateFormat('dd/MM/y').format(Filters.ganttStartDate!)
                        : 'dd/mm/aaaa',
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
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
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    locale: const Locale('es', 'ES'),
                    helpText: 'Fecha final',
                    confirmText: 'Aceptar',
                    cancelText: 'Cancelar',
                  );
                  setState(() {
                    Filters.ganttEndDate = endDate;
                    Filters.events = widget.homeBackend.getEvents(
                        Filters.selectedCourses,
                        startDate: Filters.ganttStartDate,
                        endDate: Filters.ganttEndDate);
                    widget.homeBackend.saveFilters();
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
                        ? DateFormat('dd/MM/y').format(Filters.ganttEndDate!)
                        : 'dd/mm/aaaa',
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
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
                          widget.homeBackend.getEvents(Filters.selectedCourses);
                    }
                  });
                  widget.homeBackend.saveFilters();
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
                          widget.homeBackend.getEvents(Filters.selectedCourses);
                    }
                  });
                  widget.homeBackend.saveFilters();
                }),
            const Expanded(child: Text('Fecha cierre'))
          ],
        )
      ]),
    );
  }
}
