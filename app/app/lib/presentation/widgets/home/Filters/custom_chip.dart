import 'package:app/backend/home/home_backend.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  final Courses course;
  final UserModel user;
  const CustomChip({super.key, required this.course, required this.user});

  @override
  State<CustomChip> createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  late final HomeBackend homeBackend;

  @override
  void initState() {
    super.initState();
    homeBackend = HomeBackend(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (!Filters.selectedCourses.contains(widget.course)) {
              Filters.selectedCourses.add(widget.course);
            } else {
              Filters.selectedCourses.remove(widget.course);
            }
            Filters.events = homeBackend.getEvents(Filters.selectedCourses);
          });
          homeBackend.saveFilters();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Filters.selectedCourses.contains(widget.course)
                  ? Colors.blue
                  : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(Filters.selectedCourses.contains(widget.course))
                const Icon(Icons.check, color: Colors.white,),
                const SizedBox(width: 16),
              Flexible(
                child: Text(
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  maxLines: null,
                  widget.course.shortname,
                  style: TextStyle(
                      color: Filters.selectedCourses.contains(widget.course)
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
