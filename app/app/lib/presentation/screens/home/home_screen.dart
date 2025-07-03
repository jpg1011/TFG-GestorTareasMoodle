import 'package:app/backend/home/home_backend.dart';
import 'package:app/presentation/screens/login/login_screen.dart';
import 'package:app/presentation/screens/personal_tasks/personal_tasks_screen.dart';
import 'package:app/presentation/widgets/home/filters/filter_dialog.dart';
import 'package:app/presentation/widgets/home/home_features_botton.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/presentation/screens/gantt_chart/gantt_chart_screen.dart';
import 'package:app/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBackend homeBackend;
  String getFirstname() {
    final name = widget.user.fullname.split(', ');
    return name.last;
  }

  @override
  void initState() {
    super.initState();
    homeBackend = HomeBackend(user: widget.user);
    homeBackend.loadSavedFilters(widget.user.email!);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xFF38373C),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32))),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Inicio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 34,
                                color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(widget.user.profileimageurl!),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.exit_to_app,
                                color: Colors.white),
                            onPressed: () async {
                              await MoodleApiService.logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '¡Hola, ${getFirstname()}! 👋',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              HomeFeaturesBotton(
                  label: 'Gantt',
                  icon: const Icon(Icons.view_timeline),
                  imgPath: 'assets/ganttPreview.png',
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  GanttChartScreen(
                                      user: widget.user,
                                      events: homeBackend.getEvents(
                                          Filters.selectedCourses,
                                          startDate: Filters.ganttStartDate,
                                          endDate: Filters.ganttEndDate)),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                                position: animation.drive(Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.ease))),
                                child: child);
                          },
                        ));
                  }),
              const SizedBox(height: 20),
              HomeFeaturesBotton(
                  label: 'Tareas',
                  icon: const Icon(Icons.list_alt),
                  imgPath: 'assets/logoUBU.png',
                  onTap: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  PersonalTasksScreen(user: widget.user),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                                position: animation.drive(Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero)
                                    .chain(CurveTween(curve: Curves.ease))),
                                child: child);
                          },
                        ));
                  }),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38373C),
                            shape: const CircleBorder(),
                            fixedSize: const Size(60, 60),
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero),
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => FilterDialog(homeBackend: homeBackend, user: widget.user),
                          );
                        },
                        child: const Icon(
                          Icons.filter_alt,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
