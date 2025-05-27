import 'package:app/models/databases/personaltask_database.dart';
import 'package:app/models/personaltask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatefulWidget {
  final PersonalTask task;
  final PersonalTaskDatabase personalTasksDB;
  final Future<void> Function() refreshTasks;

  const TaskCard(
      {super.key,
      required this.task,
      required this.personalTasksDB,
      required this.refreshTasks});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
            onPressed: (context) async {
              await widget.personalTasksDB.deleteTask(widget.task);
              widget.refreshTasks();
            },
            icon: Icons.delete,
            label: 'Eliminar')
      ]),
      child: ListTile(
          onTap: () => showTaskBottomSheet(),
          title: Text(widget.task.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.course),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          DateFormat.Hm('es').format(widget.task.date),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      if(widget.task.priority != null)
                        Flexible(
                          child: Container(
                            width: 70,
                            height: 25,
                            decoration: BoxDecoration(
                                color: widget.task.priority!.name == 'alta'
                                    ? Colors.red.withOpacity(.9)
                                    : widget.task.priority!.name == 'media'
                                        ? Colors.orange.withOpacity(.9)
                                        : Colors.green.withOpacity(.9),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              widget.task.priority!.name.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          trailing: Transform.scale(
            scale: 1.6,
            child: Checkbox(
              tristate: false,
              checkColor: Colors.white,
              fillColor: WidgetStatePropertyAll(
                  widget.task.done ? const Color(0xFF212121) : Colors.white),
              value: widget.task.done,
              shape: const CircleBorder(),
              onChanged: (bool? value) async {
                if (value == null) return;
                setState(() {
                  widget.task.done = value;
                  widget.task.finishedat = widget.task.done ? DateTime.now() : null;
                });
                await widget.personalTasksDB.updateTask(widget.task);
                await widget.refreshTasks();
              },
            ),
          )),
    );
  }

  Future<void> showTaskBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.6,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                color: Theme.of(context).scaffoldBackgroundColor
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    widget.task.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(widget.task.description != null)
                            Text(
                              widget.task.description!, 
                              style: const TextStyle(
                                fontSize: 16
                              )
                            ),
                          const SizedBox(height: 16.0),
                          Text(
                            widget.task.course,
                            style: const TextStyle(
                              fontSize: 16
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            DateFormat("EEEE',' d 'de' MMMM 'de' yyyy 'a' 'las' HH:mm", 'es').format(widget.task.date)
                          ),
                          const SizedBox(height: 16.0),
                          if(widget.task.priority != null)
                            Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                color: widget.task.priority!.name == 'alta'
                                      ? Colors.red.withOpacity(.9)
                                      : widget.task.priority!.name == 'media'
                                        ? Colors.orange.withOpacity(.9)
                                        : Colors.green.withOpacity(.9),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  widget.task.priority!.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16.0),
                          Text(
                            widget.task.done 
                            ? 'Finalizada el ${DateFormat("EEEE',' d 'de' MMMM 'de' yyyy 'a' 'las' HH:mm", 'es').format(widget.task.finishedat!)}'
                            : 'No finalizada'
                          )
                      ]
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
