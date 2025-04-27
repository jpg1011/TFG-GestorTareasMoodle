import 'package:app/models/personaltask.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PersonalTaskCard extends StatefulWidget {
  final PersonalTask task;
  const PersonalTaskCard(this.task, {super.key});

  @override
  State<PersonalTaskCard> createState() => _PersonalTaskCardState();
}

class _PersonalTaskCardState extends State<PersonalTaskCard> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remainingTime = widget.task.enddate.difference(now);
    final totalTime = widget.task.enddate.difference(widget.task.startdate);
    int days = 0;
    int hours = 0;

    if (!remainingTime.isNegative) {
      if (remainingTime.inDays > 0) {
        days = remainingTime.inDays;
      }

      if (remainingTime.inHours % 24 > 0) {
        hours = remainingTime.inHours % 24;
      }
    }

    return GestureDetector(
      onTap: () {
        showCard();
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CircularPercentIndicator(
                      radius: 45,
                      lineWidth: 13.0,
                      animation: true,
                      percent: getPercent(remainingTime, totalTime),
                      center: Text(days != 0 ? '$days d \n$hours h' : '$hours h'),
                      progressColor: Colors.blue,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  const VerticalDivider(color: Colors.grey, thickness: 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.task.name, overflow: TextOverflow.ellipsis),
                        Text(widget.task.description, overflow: TextOverflow.ellipsis),
                        Text(widget.task.course, overflow: TextOverflow.ellipsis)
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          'Finaliza: ${DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es').format(widget.task.enddate)}', overflow: TextOverflow.ellipsis),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  double getPercent(Duration remaining, Duration total) {
    double percent;
    if (total.inSeconds <= 0 || remaining.inSeconds < 0) {
      percent = 0.0;
    } else if (remaining > total) {
      percent = 1.0;
    } else {
      percent = remaining.inSeconds / total.inSeconds;
    }

    return percent;
  }

  showCard() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.task.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text(widget.task.description),
                Text('Curso: ${widget.task.course}'),
                Text(DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es').format(widget.task.startdate)),
                Text(DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es').format(widget.task.enddate))
              ],
            ),
          ),
        );
      },
    );
  }
}
