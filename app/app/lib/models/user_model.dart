import 'package:app/models/courses.dart';

class UserModel {
  final int id;
  final String? username;
  final String? firstname;
  final String? lastname;
  final String fullname;
  final String? email;
  final String? address;
  final int? phone1;
  final int? phone2;
  final String? department;
  final String? institution;
  final String? idnumber;
  final String? interests;
  final int? firstaccess;
  final int? lastaccess;
  final String? auth;
  final bool? suspended;
  final bool? confirmed;
  final String? lang;
  final String? theme;
  final String? timezone;
  final int? mailformat;
  final int? trackforums;
  final String? description;
  final int? descriptionformat;
  final String? city;
  final String? country;
  final String profileimageurlsmall;
  final String? profileimageurl;
  List<Courses>? userCourses;

  UserModel({
    required this.id,
    this.username,
    this.firstname,
    this.lastname,
    required this.fullname,
    this.email,
    this.address,
    this.phone1,
    this.phone2,
    this.department,
    this.institution,
    this.idnumber,
    this.interests,
    this.firstaccess,
    this.lastaccess,
    this.auth,
    this.suspended,
    this.confirmed,
    this.lang,
    this.theme,
    this.timezone,
    this.mailformat,
    this.trackforums,
    this.description,
    this.descriptionformat,
    this.city,
    this.country,
    required this.profileimageurlsmall,
    this.profileimageurl,
    this.userCourses,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        fullname = json['fullname'],
        email = json['email'],
        address = json['address'],
        phone1 = json['phone1'],
        phone2 = json['phone2'],
        department = json['department'],
        institution = json['institution'],
        idnumber = json['idnumber'],
        interests = json['interests'],
        firstaccess = json['firstaccess'],
        lastaccess = json['lastaccess'],
        auth = json['auth'],
        suspended = json['suspended'],
        confirmed = json['confirmed'],
        lang = json['lang'],
        theme = json['theme'],
        timezone = json['timezone'],
        mailformat = json['mailformat'],
        trackforums = json['trackforums'],
        description = json['description'],
        descriptionformat = json['descriptionformat'],
        city = json['city'],
        country = json['country'],
        profileimageurlsmall = json['profileimageurlsmall'],
        profileimageurl = json['profileimageurl'] as String;

  set setUserCourses(List<Courses> courses) {
    userCourses = courses;
  }

  get getUserCourses => userCourses;
}
