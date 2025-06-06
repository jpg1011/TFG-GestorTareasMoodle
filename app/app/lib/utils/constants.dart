import 'package:app/models/courses.dart';

/*
  Name: MOODLE_SERVICE_NAME
  Description: URL of the Moodle server
*/
const String MOODLE_SERVICE_NAME = 'moodle_mobile_app';

/*
  Name: WS_GET_USER_INFO
  Description: Get user info by userId
*/
const String WS_GET_USER_INFO = 'core_user_get_users_by_field';

/*
  Name: WS_GET_COURSE_ASSIGN
  Description: Get user assignments by courseId
*/
const String WS_GET_COURSE_ASSIGN = 'mod_assign_get_assignments';

/*
  Name: WS_GET_ASSIGN_GRADES
  Description: Get assignment grades by assignmentId
*/
const String WS_GET_ASSIGN_GRADES = 'mod_assign_get_grades';

/*
  Name: WS_GET_ASSIGN_SUBMISSION
  Description: Get assignment submissions by assignmentId
*/
const String WS_GET_ASSIGN_SUBMISSIONS = 'mod_assign_get_submissions';

/*
  Name: WS_GET_ASSIGN_SUBMISS_STATUS
  Description: Get assign submission status
*/
const String WS_GET_ASSIGN_SUBMISS_STATUS = 'mod_assign_get_submission_status';

/*
  Name: WS_GET_USER_COURSES
  Description: Get user courses by userId
*/
const String WS_GET_USER_COURSES = 'core_enrol_get_users_courses';

/*
  Name: WS_GET_COURSE_QUIZ
  Description: Get user quizzes by courseId
*/
const String WS_GET_COURSE_QUIZ = 'mod_quiz_get_quizzes_by_courses';

/*
  Name: WS_GET_QUIZ_GRADE
  Description: Get quiz grade by quizId
*/
const String WS_GET_QUIZ_GRADE = 'mod_quiz_get_user_best_grade ';

class Filters {
  static List<dynamic> events = [];
  static List<Courses> selectedCourses = [];
  static DateTime? ganttStartDate;
  static DateTime? ganttEndDate;
  static bool selectTask = true;
  static bool selectQuiz = true;
  static bool openingDate = true;
  static bool closingDate = true;
}
