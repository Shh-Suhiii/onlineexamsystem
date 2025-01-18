import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int totalQuestions = 10; // Example total number of questions
  int answeredQuestions = 0; // Number of answered questions
  bool examStarted = false;
  bool isAnswered = false;
  int currentQuestionIndex = 0;
  int timerSeconds = 600; // Timer in seconds (10 minutes)
  late List<Map<String, dynamic>> questions;
  bool timerPaused = false;

  @override
  void initState() {
    super.initState();
    questions = List.generate(totalQuestions, (index) {
      return {
        'question': 'Question ${index + 1}: What is Flutter?',
        'options': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        'correctAnswer': 'Option 1', // Correct answer for this example
        'userAnswer': '', // Store user answer
        'isCorrect': false, // Store if answer was correct
      };
    });

    _startTimer();
  }

  void _startTimer() {
    if (!timerPaused) {
      Future.delayed(Duration(seconds: 1), () {
        if (timerSeconds > 0 && examStarted) {
          setState(() {
            timerSeconds--;
          });
          _startTimer(); // Keep counting down

          // Alert when time is almost up
          if (timerSeconds <= 30) {
            Vibration.vibrate(duration: 500); // Vibration alert
          }
        } else if (timerSeconds == 0) {
          _endExam();
        }
      });
    }
  }

  void _endExam() {
    setState(() {
      examStarted = false;
    });
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Exam Completed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have finished all the questions.'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showReviewDialog,
              child: Text('Review Answers'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Your Answers'),
        content: Container(
          width: double.maxFinite, // Ensure content stretches to the available width
          child: SingleChildScrollView( // Allow scrolling if content overflows
            child: Column(
              children: [
                // Display the answers
                ListView.builder(
                  shrinkWrap: true, // Allow the ListView to shrink to its content
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    var question = questions[index];
                    return ListTile(
                      title: Text('Question ${index + 1}: ${question['isCorrect'] ? 'Correct' : 'Incorrect'}'),
                      subtitle: Text('Your Answer: ${question['userAnswer']}'),
                      trailing: Icon(question['isCorrect'] ? Icons.check : Icons.close),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome to the Exam!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (!examStarted)
              Column(
                children: [
                  Text(
                    'Press the button below to start your exam.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        examStarted = true;
                      });
                      _startTimer();
                    },
                    child: Text('Start Exam'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  // Timer display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Time Remaining: ${_formatTime(timerSeconds)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(timerPaused ? Icons.play_arrow : Icons.pause),
                        onPressed: () {
                          setState(() {
                            timerPaused = !timerPaused;
                          });
                          if (!timerPaused) _startTimer(); // Resume timer if not paused
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Progress Tracker
                  LinearProgressIndicator(
                    value: answeredQuestions / totalQuestions,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Progress: $answeredQuestions / $totalQuestions',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // Display Current Question
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        questions[currentQuestionIndex]['question'],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Answer Options
                  Wrap(
                    spacing: 10,
                    children: List.generate(4, (index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: questions[currentQuestionIndex]['userAnswer'] == questions[currentQuestionIndex]['options'][index]
                              ? (questions[currentQuestionIndex]['isCorrect'] ? Colors.green : Colors.red)
                              : null,
                        ),
                        onPressed: () {
                          setState(() {
                            questions[currentQuestionIndex]['userAnswer'] = questions[currentQuestionIndex]['options'][index];
                            questions[currentQuestionIndex]['isCorrect'] = questions[currentQuestionIndex]['options'][index] == questions[currentQuestionIndex]['correctAnswer'];
                            if (questions[currentQuestionIndex]['isCorrect']) {
                              answeredQuestions++;
                            }
                            isAnswered = true;
                          });
                        },
                        child: Text(questions[currentQuestionIndex]['options'][index]),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  // Previous/Next Question Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentQuestionIndex > 0)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentQuestionIndex--;
                            });
                          },
                          child: Text('Previous'),
                        ),
                      if (isAnswered && answeredQuestions < totalQuestions)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (answeredQuestions < totalQuestions - 1) {
                                currentQuestionIndex++;
                              } else {
                                _endExam(); // End exam after last question
                              }
                              isAnswered = false;
                            });
                          },
                          child: Text('Next Question'),
                        ),
                      // Finish Exam Button
                      if (answeredQuestions == totalQuestions)
                        ElevatedButton(
                          onPressed: _endExam,
                          child: Text('Finish Exam'),
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}