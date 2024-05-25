import 'package:flutter/material.dart';
import 'package:quizzy_app_flutter/quiz_logic.dart';

void main() => runApp(const Quizzy());

class Quizzy extends StatelessWidget {
  const Quizzy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final quizLogic = QuizLogic();

  var scoreKeeper = <Icon>[];

  Future<void> showAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Finished!'),
        content: Text(quizLogic.getUserScore()),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context, 'OK');
                scoreKeeper.clear();
                quizLogic.updateQuestion();
              });
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Text(
              quizLogic.getQuestionText(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 24.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: scoreKeeper,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.green),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'True',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  onPressed: () {
                    //The user picked true.
                    setState(() {
                      scoreKeeper.add(quizLogic.checkAnswer(true));
                    });
                    if (quizLogic.shouldShowAlert()) {
                      showAlert(context);
                    } else {
                      quizLogic.updateQuestion();
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'False',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    //The user picked false.
                    setState(() {
                      scoreKeeper.add(quizLogic.checkAnswer(false));
                    });
                    if (quizLogic.shouldShowAlert()) {
                      showAlert(context);
                    } else {
                      quizLogic.updateQuestion();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
