import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noodle_quiz/model/quiz.dart';
import 'package:noodle_quiz/pages/quiz_page.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  CategoryPage(this.category, {super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  late Query<Map<String, dynamic>> quizCollection;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    quizCollection = FirebaseFirestore.instance.collection('quiz');
    print(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.shade100,
      child: StreamBuilder<QuerySnapshot>(
          stream: quizCollection
              .where('type', isEqualTo: widget.category)
              .where('createdDate', isLessThan: Timestamp.now())
              .orderBy('createdDate', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //ロード中の状態を確認
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('Stream is waiting for data...');
              return const Center(child: CircularProgressIndicator());
            }

            // エラーが発生している場合はその情報をログに出力
            if (snapshot.hasError) {
              print('Stream encountered an error: ${snapshot.error}');
              return const Center(child: Text('Something went wrong!'));
            }

            // データが存在しない場合
            if (!snapshot.hasData) {
              print('Stream has no data.');
              return const Center(child: Text('No data found.'));
            }

            // データが取得できたら、ListViewを構築
            if (snapshot.hasData) {
              print('Stream has data: ${snapshot.data}');
              // 以下、データ表示のコード...
            }


            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(
                  widget.category,
                  style:const TextStyle(fontSize:16, fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                color: Colors.yellow.shade100,
                child: Column(
                  children: [
                    const SizedBox (height: 10),
                    Expanded(
                      child: ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                          final Quiz fetchQuiz = Quiz(
                            name: data['name'],
                            region: data['region'],
                            type: data['type'],
                            opt1: data['opt1'],
                            opt2: data['opt2'],
                            opt3: data['opt3'],
                            comment: data['comment'],
                            image: data['image'],
                            createdDate: data['createdDate'],
                          );

                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.ramen_dining),
                              title: Text(
                                fetchQuiz.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              tileColor: Colors.white,
                              onTap: () {
                                fetchQuiz.answer = null;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => QuizPage(fetchQuiz)));
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}



