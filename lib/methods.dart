import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noodle_quiz/pages/category_page.dart';
import 'package:noodle_quiz/pages/quiz_page.dart';
import 'model/quiz.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // TimestampをDateTimeに変換

  String year = dateTime.year.toString(); // 年を文字列に変換
  String month = dateTime.month.toString().padLeft(2, '0'); // 月を文字列に変換、2桁表示にする
  String day = dateTime.day.toString().padLeft(2, '0'); // 日を文字列に変換、2桁表示にする

  // 日付を 'yyyy-MM-dd' 形式の文字列に結合する
  return "$year-$month-$day";
}

Widget viewIcon(int optnum, String optname, int? ansnum, String ansname) {
  if (ansnum == null) {
    return const Icon(Icons.question_mark);
  } else if (optname == ansname) {
    if (optnum == ansnum) {
      return const Icon(Icons.panorama_fish_eye, color: Colors.green);
    } else {
      return const Icon(Icons.panorama_fish_eye, color: Colors.red);
    }
  } else {
    if (optnum == ansnum) {
      return const Icon(Icons.clear, color: Colors.red);
    } else{
      return const Icon(Icons.minimize);
    }
  }
}

Widget viewOptlist(
    BuildContext context,
    Quiz quiz,
    int optnum,
    String optname,) {
  return GestureDetector(
    child: Row(
      children: <Widget>[
        const SizedBox(width: 16),
        viewIcon(optnum, optname, quiz.answer, quiz.name),
        const SizedBox(width: 16),
        Text(optname, style: const TextStyle(fontSize: 20),),
      ],
    ),
    onTap: () {
      quiz.answer = optnum;
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => QuizPage(quiz)));
    },
  );
}

Widget viewCategoryList(BuildContext context, String category) {
  return Column(
    children: [
      const SizedBox(height: 8),
      GestureDetector(
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.ramen_dining),
            const SizedBox(width: 16),
            Text(category, style: const TextStyle(fontSize: 20),),
          ],
        ),
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => CategoryPage(category)));
        },
      ),
    ],
  );
}