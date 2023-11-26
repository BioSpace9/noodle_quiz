import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noodle_quiz/methods.dart';

class Quiz {
  String name;
  String region;
  String type;
  String opt1;
  String opt2;
  String opt3;
  String comment;
  String image;
  Timestamp createdDate;
  String title;
  bool? istrue;
  int? answer;

  Quiz({
    required this.name,
    required this.region,
    required this.type,
    required this.opt1,
    required this.opt2,
    required this.opt3,
    required this.comment,
    required this.image,
    required this.createdDate,
  }) : title = formatTimestamp(createdDate) + " "
      + type + "クイズ！";
}