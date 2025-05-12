import 'package:app/models/assign.dart';
import 'package:app/presentation/widgets/gantt_chart/task_page.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final dynamic event;
  final Color taskColor;

  const TaskCard({super.key, required this.event, required this.taskColor});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TaskPage(event: widget.event, taskColor: widget.taskColor),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                      position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
                      child: child);
                },
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4)
              )
            ]
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex:4, 
                    child: Container(
                      alignment: Alignment.center,
                      color: widget.taskColor,
                      child: Icon(widget.event.runtimeType == Assign ? Icons.task : Icons.fact_check, color: Colors.white, size: 36,),
                    )
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(widget.event.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis,),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTapCard(){

  
  }
}


