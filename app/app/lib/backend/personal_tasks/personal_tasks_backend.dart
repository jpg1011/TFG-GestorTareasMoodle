import 'package:app/models/personaltask.dart';


class PersonalTasksBackend {
  List<PersonalTask> filterDoneTask(
    {required List<PersonalTask> tasks, required String tab}) {
  final now = DateTime.now();

  switch (tab) {
    case 'Hoy':
      return tasks.where((task) {
        return task.finishedat!.year == now.year &&
            task.finishedat!.month == now.month &&
            task.finishedat!.day == now.day;
      }).toList();
    case 'Últimos 7d':
      final week = now.subtract(const Duration(days: 7));
      return tasks
          .where((task) =>
              task.finishedat!.isBefore(now) && task.finishedat!.isAfter(week))
          .toList();
    case 'Este mes':
      return tasks
          .where((task) =>
              task.finishedat!.year == now.year &&
              task.finishedat!.month == now.month)
          .toList();
    case 'Todos':
      return tasks;
    default:
      return tasks;
  }
}

List<PersonalTask> filterUnDoneTask(
    {required List<PersonalTask> tasks, required String tab}) {
    final now = DateTime.now();
    switch (tab) {
      case 'Hoy':
        return tasks
            .where((task) =>
                task.date.year == now.year &&
                task.date.month == now.month &&
                task.date.day == now.day)
            .toList();
      case 'Mañana':
        final tomorrow = now.add(const Duration(days: 1));
        return tasks
            .where((task) =>
                task.date.year == tomorrow.year &&
                task.date.month == tomorrow.month &&
                task.date.day == tomorrow.day)
            .toList();
      case 'Esta semana':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return tasks
            .where((task) =>
                task.date.isAfter(weekStart) && task.date.isBefore(weekEnd))
            .toList();
      case 'Todos':
        return tasks;
      default:
        return tasks;
    }
  }
}
