import 'package:app/models/quiz_grade.dart';

class Quiz {
  final int id;
  final int coursemodule;
  final int course;
  final String name;
  final String? intro;
  final int introformat;
  final List<dynamic>? introfiles;
  final int section;
  final bool visible;
  final int groupmode;
  final int groupingid;
  final String? lang;
  final int timeopen;
  final int timeclose;
  final String? overduehandling;
  final int? graceperiod;
  final String? preferredbehaviour;
  final int? caredoquestions;
  final int attempts;
  final int? attemptonlast;
  final int grademethod;
  final int? decimalpoints;
  final int? questiondecimalpoints;
  final int? reviewattempt;
  final int? reviewcorrections;
  final int? reviewmaxmarks;
  final int? reviewmarks;
  final int? reviewspecificfeedback;
  final int? reviewgeneralfeedback;
  final int? reviewrightanswer;
  final int? reviewoverallfeedback;
  final int? quetionsperpage;
  final String? navmethod;
  final int? shuffleanswers;
  final double? sumgrades;
  final double? grade;
  final int? timecreated;
  final int? timemodified;
  final String? password;
  final String? subnet;
  final String? browsersecurity;
  final int? delay1;
  final int? delay2;
  final int? showuserpicture;
  final int? showblocks;
  final int? completionattemptsexhausted;
  final int? completionpass;
  final int? allowofflineattempts;
  final int? autosaveperiod;
  final int? hasfeedback;
  final int? hasquestions;
  QuizGrade? quizgrade;

  Quiz({
    required this.id,
    required this.coursemodule,
    required this.course,
    required this.name,
    required this.intro,
    required this.introformat,
    required this.introfiles,
    required this.section,
    required this.visible,
    required this.groupmode,
    required this.groupingid,
    required this.lang,
    required this.timeopen,
    required this.timeclose,
    required this.overduehandling,
    required this.graceperiod,
    required this.preferredbehaviour,
    required this.caredoquestions,
    required this.attempts,
    required this.attemptonlast,
    required this.grademethod,
    required this.decimalpoints,
    required this.questiondecimalpoints,
    required this.reviewattempt,
    required this.reviewcorrections,
    required this.reviewmaxmarks,
    required this.reviewmarks,
    required this.reviewspecificfeedback,
    required this.reviewgeneralfeedback,
    required this.reviewrightanswer,
    required this.reviewoverallfeedback,
    required this.quetionsperpage,
    required this.navmethod,
    required this.shuffleanswers,
    required this.sumgrades,
    required this.grade,
    required this.timecreated,
    required this.timemodified,
    required this.password,
    required this.subnet,
    required this.browsersecurity,
    required this.delay1,
    required this.delay2,
    required this.showuserpicture,
    required this.showblocks,
    required this.completionattemptsexhausted,
    required this.completionpass,
    required this.allowofflineattempts,
    required this.autosaveperiod,
    required this.hasfeedback,
    required this.hasquestions,
    this.quizgrade
  });

  Quiz.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        coursemodule = json['coursemodule'],
        course = json['course'],
        name = json['name'],
        intro = json['intro'],
        introformat = json['introformat'],
        introfiles = List<dynamic>.from(json['introfiles']),
        section = json['section'],
        visible = json['visible'],
        groupmode = json['groupmode'],
        groupingid = json['groupingid'],
        lang = json['lang'],
        timeopen = json['timeopen'],
        timeclose = json['timeclose'],
        overduehandling = json['overduehandling'],
        graceperiod = json['graceperiod'],
        preferredbehaviour = json['preferredbehaviour'],
        caredoquestions = json['caredoquestions'],
        attempts = json['attempts'],
        attemptonlast = json['attemptonlast'],
        grademethod = json['grademethod'],
        decimalpoints = json['decimalpoints'],
        questiondecimalpoints = json['questiondecimalpoints'],
        reviewattempt = json['reviewattempt'],
        reviewcorrections = json['reviewcorrections'],
        reviewmaxmarks = json['reviewmaxmarks'],
        reviewmarks = json['reviewmarks'],
        reviewspecificfeedback = json['reviewspecificfeedback'],
        reviewgeneralfeedback = json['reviewgeneralfeedback'],
        reviewrightanswer = json['reviewrightanswer'],
        reviewoverallfeedback = json['reviewoverallfeedback'],
        quetionsperpage = json['quetionsperpage'],
        navmethod = json['navmethod'],
        shuffleanswers = json['shuffleanswers'],
        sumgrades = (json['sumgrades'])?.toDouble(),
        grade = (json['grade'])?.toDouble(),
        timecreated = json['timecreated'],
        timemodified = json['timemodified'],
        password = json['password'],
        subnet = json['subnet'],
        browsersecurity = json['browsersecurity'],
        delay1 = json['delay1'],
        delay2 = json['delay2'],
        showuserpicture = json['showuserpicture'],
        showblocks = json['showblocks'],
        completionattemptsexhausted = json['completionattemptsexhausted'],
        completionpass = json['completionpass'],
        allowofflineattempts = json['allowofflineattempts'],
        autosaveperiod = json['autosaveperiod'],
        hasfeedback = json['hasfeedback'],
        hasquestions = json['hasquestions'];
}
