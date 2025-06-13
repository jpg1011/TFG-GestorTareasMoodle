import 'package:app/models/user_model.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBackend {
  Future<String> chargeMoodle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('moodleConection') ?? 'https://moodleexample.com';
  }

  Future<void> saveMoodle({required TextEditingController urlMoodle}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('moodleConection', urlMoodle.text);
  }

  Future<void> saveEmail({required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<String?> loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<bool> getSaveOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('saveEmail') ?? false;
  }

  Future<bool> checkMoodleServer(String url) async {
    try {
      url += '';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body.toLowerCase().contains('moodle');
      } else {
        throw Exception('Server status code: ${response.statusCode}');
      }
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> loginSetup(
      {required String email,
      required String password,
      required bool saveEmailOption}) async {
    await MoodleApiService.login(email, password);

    if (saveEmailOption) await saveEmail(email: email);
    var userInfo = await MoodleApiService.getUserInfo();
    final UserModel user = UserModel.fromJson(userInfo);

    var userCourses =
        await MoodleApiService.getUserCourses(userInfo['id'] as int);
    user.userCourses = userCourses;
    for (var course in user.userCourses!) {
      var assignments = await MoodleApiService.getCourseAssignments(course.id);
      course.assignments = assignments;
      for (var assign in course.assignments!) {
        assign.submission =
            await MoodleApiService.getAssignSubmissionStatus(assign.id);
      }
    }

    for (var course in user.userCourses!) {
      var quizzes = await MoodleApiService.getCourseQuizzes(course.id);
      course.quizzes = quizzes;
      for (var quiz in course.quizzes!) {
        quiz.quizgrade =
            await MoodleApiService.getQuizSubmissionStatus(quiz.id);
      }
    }

    return user;
  }
}
