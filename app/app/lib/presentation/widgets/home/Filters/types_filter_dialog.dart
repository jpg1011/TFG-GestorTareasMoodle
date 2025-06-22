import 'package:app/backend/home/home_backend.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/home/filters/filter_dialog.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class TypesFilterDialog extends StatefulWidget {
  final HomeBackend homeBackend;
  final UserModel user;

  const TypesFilterDialog(
      {super.key, required this.homeBackend, required this.user});

  @override
  State<TypesFilterDialog> createState() => _TypesFilterDialogState();
}

class _TypesFilterDialogState extends State<TypesFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          IconButton(
              onPressed: () async {
                Navigator.pop(context);
                await showDialog(
                  context: context, 
                  builder: (context) => FilterDialog(homeBackend: widget.homeBackend, user: widget.user),
                );
              },
              icon: const Icon(Icons.arrow_back)),
          const Text(
            'Seleccionar tipo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                  Filters.events =
                      widget.homeBackend.getEvents(Filters.selectedCourses);
                });
                widget.homeBackend.saveFilters(widget.user.email!);
              },
              icon: Icon(
                Icons.task,
                color: Filters.selectTask ? Colors.white : Colors.blue,
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
                color: Filters.selectQuiz ? Colors.white : Colors.blue,
                size: 42,
              ),
              isSelected: Filters.selectQuiz,
              onPressed: () {
                setState(() {
                  Filters.selectQuiz = !Filters.selectQuiz;
                  Filters.events =
                      widget.homeBackend.getEvents(Filters.selectedCourses);
                });
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
