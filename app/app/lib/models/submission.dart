class Submission {
  //submission in lastattempt
  bool submitted;
  bool submissionsenabled;
  bool graded;
  bool cansubmit;

  //grade in feedback
  double? grade;

  Submission(
      {required this.submitted,
      required this.submissionsenabled,
      required this.graded,
      required this.cansubmit,
      this.grade});
}
