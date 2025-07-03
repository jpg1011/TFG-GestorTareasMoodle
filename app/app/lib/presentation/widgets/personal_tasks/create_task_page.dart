import 'package:app/models/databases/personaltask_database.dart';
import 'package:app/models/personaltask.dart';
import 'package:app/models/user_model.dart';
import 'package:app/presentation/screens/personal_tasks/personal_tasks_screen.dart';
import 'package:app/services/moodle_api_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  final UserModel user;
  final Future<void> Function() refreshTasks;

  const CreateTaskPage(
      {super.key, required this.user, required this.refreshTasks});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _taskdescription = TextEditingController();
  String? taskCourse;
  List<DateTime?>? date;
  TimeOfDay? time;
  TaskPriority? taskPriority;
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeDesc = FocusNode();
  late final PersonalTaskDatabase personalTasksDB;

  @override
  void initState() {
    super.initState();
    MoodleApiService.getMoodleURL().then((moodleURL) {
      setState(() {
        personalTasksDB = PersonalTaskDatabase(
            userid: widget.user.id.toString(), moodleid: moodleURL);
      });
    });
  }

  @override
  void dispose() {
    _focusNodeName.dispose();
    _focusNodeDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setPageState) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonalTasksScreen(user: widget.user))), 
                      icon: const Icon(Icons.arrow_back, color: Colors.black)
                    )
                  ],
                ),
                    const Text('Nueva tarea',
                        style: TextStyle(
                            fontSize: 46, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: CustomText(fieldName: 'Nombre de la tarea'),
                    ),
                    TextField(
                      controller: _taskname,
                      decoration: InputDecoration(
                          hintText: 'Introduce un nombre',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      focusNode: _focusNodeName,
                      onSubmitted: (value) => _focusNodeName.unfocus(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Text('Descripción de la tarea',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    TextField(
                      controller: _taskdescription,
                      decoration: InputDecoration(
                          hintText: 'Introduce una descripción',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      focusNode: _focusNodeDesc,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (value) => _focusNodeDesc.unfocus(),
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16.0),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: CustomText(fieldName: 'Curso'),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _focusNodeName.unfocus();
                        _focusNodeDesc.unfocus();
                        await showCourseMenu();
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  taskCourse != null
                                      ? taskCourse.toString()
                                      : 'Selecciona un curso',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: CustomText(fieldName: 'Fecha')),
                    Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: () async {
                                _focusNodeName.unfocus();
                                _focusNodeDesc.unfocus();
                                List<DateTime?>? datesPicked =
                                    await showCalendarPicker();
                                setState(() {
                                  date = datesPicked;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  date != null
                                      ? DateFormat('dd/MM/yyyy', 'es')
                                          .format(date![0]!)
                                      : 'dd/mm/aaaa',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                      fontSize: 16),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  TimeOfDay? timePicked =
                                      await showTimeDatePicker();
                                  setState(() {
                                    time = timePicked;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    time != null
                                        ? time!.format(context)
                                        : 'hh:mm',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.70),
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Text('Prioridad',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _focusNodeName.unfocus();
                        _focusNodeDesc.unfocus();
                        await showPriorityMenu();
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  taskPriority != null
                                      ? taskPriority!.name.toUpperCase()
                                      : 'Selecciona una prioridad',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final moodle =
                                await MoodleApiService.getMoodleURL();
                            if (validateFields()) {
                              await personalTasksDB.createPersonalTask(PersonalTask(
                                  userid: widget.user.id,
                                  moodleid: moodle.toString(),
                                  name: _taskname.text,
                                  description: _taskdescription.text,
                                  course: taskCourse!,
                                  date: DateTime(
                                      date![0]!.year,
                                      date![0]!.month,
                                      date![0]!.day,
                                      time!.hour,
                                      time!.minute),
                                  priority: taskPriority));
                              await widget.refreshTasks();
                              Navigator.pop(context);
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content:
                                    Text('Rellene los campos obligatorios')));
                            }
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Color(0xFF38373C)),
                          ),
                          child: const Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showCourseMenu() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text('Seleccionar curso',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                      child: ListView.separated(
                    controller: scrollController,
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: widget.user.userCourses!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.user.userCourses![index].shortname),
                        onTap: () {
                          setState(() {
                            taskCourse =
                                widget.user.userCourses![index].shortname;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ))
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<DateTime?>?> showCalendarPicker() async {
    final config = CalendarDatePicker2WithActionButtonsConfig(
        calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
        calendarType: CalendarDatePicker2Type.single,
        selectedDayHighlightColor: const Color(0xFF38373C),
        closeDialogOnCancelTapped: true,
        firstDayOfWeek: 1,
        centerAlignModePicker: true,
        selectedDayTextStyle: const TextStyle(color: Colors.white));

    List<DateTime?>? date = await showCalendarDatePicker2Dialog(
        context: context,
        config: config,
        dialogSize: const Size(325, 400),
        borderRadius: BorderRadius.circular(20),
        value: []);

    return date;
  }

  Future<TimeOfDay?> showTimeDatePicker() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: Theme.of(context)
                  .colorScheme
                  .copyWith(primary: const Color(0xFF38373C)),
              timePickerTheme: const TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteColor: Color(0xFF38373C),
                hourMinuteTextColor: Colors.white,
                dialHandColor: Colors.grey,
                dialBackgroundColor: Color(0xFF38373C),
                dialTextColor: Colors.white,
              ),
            ),
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!));
      },
    );

    return time;
  }

  Future<void> showPriorityMenu() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          maxChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  color: Theme.of(context).scaffoldBackgroundColor),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text('Seleccionar prioridad',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16.0),
                  priorityTile(color: Colors.green, priorityName: 'Baja'),
                  priorityTile(color: Colors.orange, priorityName: 'Media'),
                  priorityTile(color: Colors.red, priorityName: 'Alta'),
                  const SizedBox(height: 8.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget priorityTile({required Color color, required String priorityName}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            taskPriority =
                TaskPriority.values.byName(priorityName.toLowerCase());
          });
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * .80,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: Center(
              child: Text(priorityName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  bool validateFields() {
    return _taskname.text.isEmpty ||
            taskCourse == null ||
            date == null ||
            time == null
        ? false
        : true;
  }
}

class CustomText extends StatelessWidget {
  final String fieldName;
  const CustomText({super.key, required this.fieldName});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: fieldName,
          style: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          children: const [
            TextSpan(
                text: ' *',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ]),
    );
  }
}
