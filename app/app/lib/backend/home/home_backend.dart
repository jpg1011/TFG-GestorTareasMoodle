import 'dart:convert';

import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:app/models/user_model.dart';
import 'package:app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBackend {
  final UserModel user;

  HomeBackend({required this.user});

  Future<void> saveFilters(String useremail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> coursesids =
        Filters.selectedCourses.map((course) => course.id.toString()).toList();

    Map<String, dynamic> filterData = {
      'coursesids': coursesids,
      'selectTask': Filters.selectTask,
      'selectQuiz': Filters.selectQuiz,
      'ganttStartDate': Filters.ganttStartDate?.toIso8601String(),
      'ganttEndDate': Filters.ganttEndDate?.toIso8601String(),
      'openingDate': Filters.openingDate,
      'closingDate': Filters.closingDate
    };
    prefs.setString(useremail, jsonEncode(filterData));
  }

  Future<void> loadSavedFilters(String useremail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userFilterData = prefs.getString(useremail);

    if (userFilterData == null) return;

    final filters = jsonDecode(userFilterData);

    List<String> coursesids = List.from(filters['coursesids'] ?? []);

    Filters.selectedCourses = [];

    for (var courseid in coursesids) {
      for (var userCourse in user.userCourses!) {
        if (int.parse(courseid) == userCourse.id) {
          Filters.selectedCourses.add(user.userCourses!
              .where((course) => course.id == int.parse(courseid))
              .first);
        }
      }
    }

    Filters.selectTask = filters['selectTask'] ?? true;
    Filters.selectQuiz = filters['selectQuiz'] ?? true;

    Filters.ganttStartDate = filters['ganttStartDate'] != null
      ? DateTime.parse(filters['ganttStartDate'])
      : null;

    Filters.ganttEndDate = filters['ganttEndDate'] != null
      ? DateTime.parse(filters['ganttEndDate'])
      : null;

    Filters.openingDate = filters['openingDate'] ?? true;
    Filters.closingDate = filters['closingDate'] ?? true;
  }

  List<dynamic> getEvents(List<Courses> selectedCourses,
      {DateTime? startDate, DateTime? endDate}) {
    List<dynamic> events = [];

    final coursesToShow = selectedCourses.isEmpty
        ? user.userCourses!
        : user.userCourses!.where((course) => selectedCourses.contains(course));

    for (var course in coursesToShow) {
      if (course.assignments != null && Filters.selectTask) {
        List<Assign> orderedAssignments =
            reorderAssignments(course.assignments!);
        for (var event in orderedAssignments) {
          DateTime eventDate =
              DateTime.fromMillisecondsSinceEpoch(event.duedate * 1000);
          inRange(startDate, endDate, eventDate, events, event);
        }
      }

      if (course.quizzes != null && Filters.selectQuiz) {
        List<Quiz> orderedQuizzes = reorderQuizzes(course.quizzes!);
        for (var event in orderedQuizzes) {
          DateTime eventDate =
              DateTime.fromMillisecondsSinceEpoch(event.timeclose * 1000);
          inRange(startDate, endDate, eventDate, events, event);
        }
      }
    }

    return events;
  }

  void inRange(DateTime? startDate, DateTime? endDate, DateTime eventDate,
      List<dynamic> events, dynamic event) {
    bool include = false;
    if (startDate != null && endDate != null) {
      include =
          (eventDate.isAfter(startDate) || sameDay(startDate, eventDate)) &&
              (eventDate.isBefore(endDate) || sameDay(endDate, eventDate));
    } else if (startDate != null && endDate == null) {
      include = eventDate.isAfter(startDate) || sameDay(startDate, eventDate);
    } else if (startDate == null && endDate != null) {
      include = eventDate.isBefore(endDate) || sameDay(endDate, eventDate);
    } else if (startDate == null && endDate == null) {
      include = true;
    }

    if (include) {
      if (Filters.openingDate) {
        final open = event.runtimeType == Assign
            ? event.allowsubmissionsfromdate != 0
            : event.timeopen != 0;
        if (!open) {
          return;
        }
      }
      if (Filters.closingDate) {
        final close = event.runtimeType == Assign
            ? event.duedate != 0
            : event.timeclose != 0;
        if (!close) {
          return;
        }
      }
      events.add(event);
    }
  }

  bool sameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<Assign> reorderAssignments(List<Assign> listToOrder) {
    List<Assign> orderedList = List.from(listToOrder);
    orderedList.sort((a, b) => a.duedate.compareTo(b.duedate));
    return orderedList;
  }

  List<Quiz> reorderQuizzes(List<Quiz> listToOrder) {
    List<Quiz> orderedList = List.from(listToOrder);
    orderedList.sort((a, b) => a.timeclose.compareTo(b.timeclose));
    return orderedList;
  }

  List<Courses> reorderCourses(List<Courses> coursesToOrder) {
    List<Courses> orderCourses = List.from(coursesToOrder);
    orderCourses.sort((a, b) => a.shortname.compareTo(b.shortname));
    return orderCourses;
  }

  clear() {
    Filters.selectedCourses = [];
    Filters.events = getEvents(Filters.selectedCourses);
    Filters.selectTask = true;
    Filters.selectQuiz = true;
    Filters.ganttStartDate = null;
    Filters.ganttEndDate = null;
    Filters.openingDate = true;
    Filters.closingDate = true;
  }
}
