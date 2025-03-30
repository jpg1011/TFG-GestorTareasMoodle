import 'package:flutter/material.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _urlMoodle = TextEditingController();
  bool viewPassword = true;
  String savedMoodle = 'URL Moodle';

  @override
  void initState() {
    super.initState();
    chargeMoodle();
  }

  Future<void> chargeMoodle() async {
    final prefs = await SharedPreferences.getInstance();
    final savedURL = prefs.getString('moodleConection');
    setState(() {
      savedMoodle = savedURL ?? 'URL Moodle';
    });
  }

  Future<void> saveMoodle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('moodleConection', _urlMoodle.text);
  }

  Future<void> _openURLDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Guardar Moodle',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlMoodle,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.school_outlined),
                        hintText: savedMoodle,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.black)),
                        focusColor: Colors.blue,
                        suffixIcon: TextButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            overlayColor:
                                WidgetStatePropertyAll(Colors.transparent),
                          ),
                          onPressed: () async {
                            await saveMoodle();
                            await chargeMoodle();
                            _urlMoodle.clear();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Guardar',
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _openURLDialog();
                    },
                    icon: const Icon(Icons.school)),
              )
            ],
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoUBU.png',
                  height: 100,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Correo universitario',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: viewPassword,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                viewPassword = !viewPassword;
                              });
                            },
                            icon: Icon(viewPassword
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await MoodleApiService.login(
                          _usernameController.text, _passwordController.text);
                      if (success) {
                        var userInfo = await MoodleApiService.getUserInfo();
                        final UserModel user = UserModel.fromJson(userInfo);

                        var userCourses = await MoodleApiService.getUserCourses(
                            userInfo['id'] as int);
                        user.userCourses = userCourses;
                        for (var course in user.userCourses!) {
                          var assignments =
                              await MoodleApiService.getCourseAssignments(
                                  course.id);
                          course.assignments = assignments;
                          for (var assign in course.assignments!) {
                            assign.submission = await MoodleApiService
                                .getAssignSubmissionStatus(assign.id);
                          }
                        }

                        for (var course in user.userCourses!) {
                          var quizzes = await MoodleApiService.getCourseQuizzes(
                              course.id);
                          course.quizzes = quizzes;
                        }

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen(user: user)));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Acceder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '© 2024 Universidad de Burgos',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
