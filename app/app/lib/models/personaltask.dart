enum TaskPriority { alta, media, baja }

class PersonalTask {
  int? id;
  int userid;
  String moodleid;
  String name;
  String? description;
  String course;
  DateTime date;
  bool done;
  DateTime? finishedat;
  TaskPriority? priority;

  PersonalTask(
      {
      this.id,
      required this.userid,
      required this.moodleid,
      required this.name,
      required this.description,
      required this.course,
      required this.date,
      this.done = false,
      this.finishedat,
      required this.priority});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userid,
      'moodle_id': moodleid,
      'name': name,
      'description': description,
      'course': course,
      'date': date.toLocal().toIso8601String(),
      'priority': priority?.name,
      'finishedat': finishedat?.toIso8601String(),
      'done': done
    };
  }

  factory PersonalTask.fromMap(Map<String, dynamic> map) {
    return PersonalTask(
        id: map['id'],
        userid: map['user_id'] as int,
        moodleid: map['moodle_id'].toString(),
        name: map['name'] as String,
        description: map['description'] as String,
        course: map['course'] as String,
        date: DateTime.parse(map['date']),
        priority: map['priority'] != null ? TaskPriority.values.byName(map['priority']) : null,
        finishedat: map['finishedat'] != null
            ? DateTime.parse(map['finishedat']).toLocal()
            : null,
        done: map['done']
    );
  }
}
