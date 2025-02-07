class Assign {
  final int id;
  final int cmid;
  final int course;
  final String name;
  final int nosubmissions;
  final int submissiondrafts;
  final int sendnotifications;
  final int sendlatenotifications;
  final int sendstudentnotifications;
  final int duedate;
  final int allowsubmissionsfromdate;
  final int grade;
  final int timemodified;
  final int completionsubmit;
  final int cutoffdate;
  final int gradingduedate;
  final int teamsubmission;
  final int requireallteammemberssubmit;
  final int teamsubmissiongroupingid;
  final int blindmarking;
  final int hidegrader;
  final int revealidentities;
  final String attemptreopenmethod;
  final int maxattempts;
  final int markingworkflow;
  final int markingallocation;
  final int markinganonymous;
  final int requiresubmissionstatement;
  final int preventsubmissionnotingroup;
  final String? submissionstatement;
  final int? submissionstatementformat;

  Assign(
      {required this.id,
      required this.cmid,
      required this.course,
      required this.name,
      required this.nosubmissions,
      required this.submissiondrafts,
      required this.sendnotifications,
      required this.sendlatenotifications,
      required this.sendstudentnotifications,
      required this.duedate,
      required this.allowsubmissionsfromdate,
      required this.grade,
      required this.timemodified,
      required this.completionsubmit,
      required this.cutoffdate,
      required this.gradingduedate,
      required this.teamsubmission,
      required this.requireallteammemberssubmit,
      required this.teamsubmissiongroupingid,
      required this.blindmarking,
      required this.hidegrader,
      required this.revealidentities,
      required this.attemptreopenmethod,
      required this.maxattempts,
      required this.markingworkflow,
      required this.markingallocation,
      required this.markinganonymous,
      required this.requiresubmissionstatement,
      required this.preventsubmissionnotingroup,
      this.submissionstatement,
      this.submissionstatementformat});

  Assign.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cmid = json['cmid'],
        course = json['course'],
        name = json['name'],
        nosubmissions = json['nosubmissions'],
        submissiondrafts = json['submissiondrafts'],
        sendnotifications = json['sendnotifications'],
        sendlatenotifications = json['sendlatenotifications'],
        sendstudentnotifications = json['sendstudentnotifications'],
        duedate = json['duedate'],
        allowsubmissionsfromdate = json['allowsubmissionsfromdate'],
        grade = json['grade'],
        timemodified = json['timemodified'],
        completionsubmit = json['completionsubmit'],
        cutoffdate = json['cutoffdate'],
        gradingduedate = json['gradingduedate'],
        teamsubmission = json['teamsubmission'],
        requireallteammemberssubmit = json['requireallteammemberssubmit'],
        teamsubmissiongroupingid = json['teamsubmissiongroupingid'],
        blindmarking = json['blindmarking'],
        hidegrader = json['hidegrader'],
        revealidentities = json['revealidentities'],
        attemptreopenmethod = json['attemptreopenmethod'],
        maxattempts = json['maxattempts'],
        markingworkflow = json['markingworkflow'],
        markingallocation = json['markingallocation'],
        markinganonymous = json['markinganonymous'],
        requiresubmissionstatement = json['requiresubmissionstatement'],
        preventsubmissionnotingroup = json['preventsubmissionnotingroup'],
        submissionstatement = json['submissionstatement'],
        submissionstatementformat = json['submissionstatementformat'];
}
