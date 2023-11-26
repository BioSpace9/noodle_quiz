import 'package:flutter/material.dart';
import 'package:noodle_quiz/model/quiz.dart';
import '../methods.dart';

class QuizPage extends StatelessWidget {
  final Quiz quiz;
  QuizPage(this.quiz, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(quiz.title, style:const TextStyle(fontSize:16),),
      ),
      body:SingleChildScrollView(
        child: Container(
          color: Colors.yellow.shade100,
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Image.network(
                      quiz.image,
                      loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                  ),
                ),
                const SizedBox(height:24),
                viewOptlist(context, quiz, 1, quiz.opt1),
                const SizedBox(height:16),
                viewOptlist(context, quiz, 2, quiz.opt2),
                const SizedBox(height:16),
                viewOptlist(context, quiz, 3, quiz.opt3),
                const SizedBox(height:24),
                quiz.answer == null
                    ? const SizedBox.shrink()
                    : Column(children:[
                      Text(quiz.comment, style: const TextStyle(fontSize: 20),),
                      const SizedBox(height:24),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
