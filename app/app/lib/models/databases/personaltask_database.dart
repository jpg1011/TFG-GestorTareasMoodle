import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app/models/personaltask.dart';

class PersonalTaskDatabase {
  final String userid;
  final String moodleid;

  final database = Supabase.instance.client.from('personal_tasks');

  PersonalTaskDatabase({required this.userid, required this.moodleid});

  //Create
  Future createPersonalTask(PersonalTask personalTask) async {
    await database.insert(personalTask.toMap());
  }

  //Read
  Future getPersonalTasks() async {
    final data = await Supabase.instance.client
        .from('personal_tasks')
        .select()
        .eq('user_id', userid)
        .eq('moodle_id', moodleid);
    return data;
  }

  //Update
  Future updateTask(PersonalTask personalTask) async {
    await database.update({
      'id': personalTask.id!,
      'user_id': personalTask.userid,
      'moodle_id': personalTask.moodleid,
      'name': personalTask.name,
      'description': personalTask.description,
      'course': personalTask.course,
      'date': personalTask.date.toLocal().toIso8601String(),
      'finishedat': personalTask.finishedat?.toLocal().toIso8601String(), 
      'done': personalTask.done,
      'priority': personalTask.priority.name
      }).eq('id', personalTask.id!).select();
  }

  //Delete
  Future deleteTask(PersonalTask task) async{
    await database.delete().eq('id', task.id!);
  }
}
