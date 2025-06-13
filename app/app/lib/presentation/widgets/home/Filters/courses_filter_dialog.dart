import 'package:app/backend/home/home_backend.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/widgets/home/filters/custom_chip.dart';
import 'package:app/presentation/widgets/home/filters/filter_dialog.dart';
import 'package:flutter/material.dart';

class CoursesFilterDialog extends StatefulWidget {
  final HomeBackend homeBackend;
  final UserModel user;

  const CoursesFilterDialog(
      {super.key, required this.homeBackend, required this.user});

  @override
  State<CoursesFilterDialog> createState() => _CoursesFilterDialogState();
}

class _CoursesFilterDialogState extends State<CoursesFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
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
              'Seleccionar cursos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                  children: widget.homeBackend
                      .reorderCourses(widget.user.userCourses!)
                      .map((course) {
                    return CustomChip(course: course, user: widget.user);
                  }).toList(),
                ),
              ));
  }
}
