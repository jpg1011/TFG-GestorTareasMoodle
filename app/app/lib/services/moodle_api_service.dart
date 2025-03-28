import 'package:app/models/assign.dart';
import 'package:app/models/courses.dart';
import 'package:app/models/quiz.dart';
import 'package:http/http.dart' as http;
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
}
