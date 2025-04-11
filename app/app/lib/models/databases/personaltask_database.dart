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
}
