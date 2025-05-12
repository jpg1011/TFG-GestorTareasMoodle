import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:app/models/quiz_grade.dart';
import 'package:app/models/submission.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:convert';
import 'package:app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodleApiService {
  static String? _token;
  static String? _username;

  static Future<String> getMoodleURL() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('moodleConection') ?? 'URL Moodle';
  }

  static Future<bool> login(String username, String password) async {
    final moodleURL = await getMoodleURL();
    final uri = Uri.parse('$moodleURL/login/token.php');

    try {
      final response = await http.post(
        uri,
        body: {
          'username': username,
          'password': password,
          'service': MOODLE_SERVICE_NAME,
        },
      );

      if (response.statusCode == 200) {
        _username = username;
        final data = jsonDecode(response.body);
        _token = data['token'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUserInfo() async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');
    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_USER_INFO,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'field': 'username',
        'values[]': _username
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data[0] != null) {
          return data[0];
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('Error statusCode');
      }
    } catch (e) {
      throw Exception();
    }
  }

  static Future<List<Courses>> getUserCourses(int userid) async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');

    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_USER_COURSES,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'userid': userid.toString()
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          var courses = <Courses>[];
          for (final course in data) {
            courses.add(Courses.fromJson(course));
          }
          return courses;
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('No response');
      }
    } catch (e) {
      throw Exception('Fatal error');
    }
  }

  static Future<List<Assign>> getCourseAssignments(int courseid) async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');
    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_COURSE_ASSIGN,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'courseids[]': courseid.toString()
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['courses'][0]['assignments'] != null) {
          var assignments = <Assign>[];
          for (final assign in data['courses'][0]['assignments']) {
            assignments.add(Assign.fromJson(assign));
          }

          return assignments;
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('No response');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<List<Quiz>> getCourseQuizzes(int courseid) async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');
    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_COURSE_QUIZ,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'courseids[]': courseid.toString()
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['quizzes'] != null) {
          var quizzes = <Quiz>[];
          for (final quiz in data['quizzes']) {
            quizzes.add(Quiz.fromJson(quiz));
          }
          return quizzes;
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception('No response');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Submission> getAssignSubmissionStatus(int assignId) async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');

    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_ASSIGN_SUBMISS_STATUS,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'assignid': assignId.toString()
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Submission submission = Submission(
            submitted: false,
            submissionsenabled: false,
            graded: false,
            cansubmit: false);
        if (data['lastattempt'] != null) {
          if (data['lastattempt']['submission'] != null) {
            submission = Submission(
                submitted:
                    data['lastattempt']['submission']['status'] == 'submitted'
                        ? true
                        : false,
                submissionsenabled: data['lastattempt']['submissionsenabled'],
                graded: data['lastattempt']['graded'],
                cansubmit: data['lastattempt']['cansubmit']);
          } else {
            submission = Submission(
                submitted: false,
                submissionsenabled: data['lastattempt']['submissionsenabled'],
                graded: data['lastattempt']['graded'],
                cansubmit: data['lastattempt']['cansubmit']);
          }
        }
        if (data['feedback'] != null) {
          if (data['feedback']['grade'] != null) {
            submission.grade = double.parse(data['feedback']['grade']['grade']);
          } else if (data['feedback']['gradefordisplay'] != null) {
            String grade = _formatGrade(data['feedback']['gradefordisplay']
                .toString()
                .replaceAll('&nbsp;', '')
                .split('/')
                .first);

            submission.grade = double.parse(grade);
          }
        }
        return submission;
      } else {
        throw Exception('No response');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<QuizGrade> getQuizSubmissionStatus(int quizId) async {
    final moodleURL = await getMoodleURL();
    final url = Uri.parse('$moodleURL/webservice/rest/server.php');

    try {
      final response = await http.post(url, body: {
        'wsfunction': WS_GET_QUIZ_GRADE,
        'moodlewsrestformat': 'json',
        'wstoken': _token,
        'quizid': quizId.toString()
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        QuizGrade quizGrade = QuizGrade(hasgrade: false);
        if (data['hasgrade']) {
          quizGrade = QuizGrade(
            hasgrade: true,
            grade: data['grade'] != null ? double.parse(data['grade'].toString()) : null,
            gradetopass: data['gradetopass'] != null ? double.parse(data['gradetopass'].toString()) : null
          );
          return quizGrade;
        }

        return quizGrade;
      } else {
        throw Exception('No response');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static _formatGrade(String gradeToFormat) {
    return gradeToFormat.replaceAll(',', '.');
  }

  String parseHTMLString(String html) {
    return parse(html).body?.text ?? '';
  }
}
