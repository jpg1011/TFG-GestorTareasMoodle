class PersonalTask {
  int userid;
  String moodleid;
  String name;
  String description;
  String course;
  DateTime startdate;
  DateTime enddate;

  PersonalTask(
      {
      required this.userid,
      required this.moodleid,
      required this.name,
      required this.description,
      required this.course,
      required this.startdate,
      required this.enddate});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userid,
      'moodle_id': moodleid,
      'name': name,
      'description': description,
      'course': course,
      'startdate': startdate.toLocal().toIso8601String(),
      'enddate': enddate.toLocal().toIso8601String(),
    };
  }

  factory PersonalTask.fromMap(Map<String, dynamic> map) {
    return PersonalTask(
      userid: map['user_id'] as int,
      moodleid: map['moodle_id'].toString(),
      name: map['name'] as String,
      description: map['description'] as String,
      course: map['course'] as String,
      startdate: DateTime.parse(map['startdate']),
      enddate: DateTime.parse(map['enddate']),
    );
  }
}
