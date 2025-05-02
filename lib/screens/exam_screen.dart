import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import 'dart:async';

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
  late ConfettiController _confettiController;
  Timer? _countdownTimer;
  

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
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

  @override
  void dispose() {
    _confettiController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!timerPaused) {
      Future.delayed(Duration(seconds: 1), () {
        if (!mounted) return;
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
    _confettiController.play();
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
            Text('You answered $answeredQuestions out of $totalQuestions correctly!'),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: answeredQuestions / totalQuestions,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            SizedBox(height: 20),
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(
              'Online Exam',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Welcome to the Exam!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '“Believe in yourself! Every question is a new opportunity.”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  // Encouragement Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.indigo.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_objects_outlined, color: Colors.indigo),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Stay focused! You got this 💪 Keep going until the last question.',
                              style: TextStyle(fontSize: 14, color: Colors.indigo[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          int countdown = 3;
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => StatefulBuilder(
                              builder: (context, setDialogState) {
                                _countdownTimer?.cancel();
                                _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                                  if (countdown == 1) {
                                    timer.cancel();
                                    _countdownTimer = null;
                                    Navigator.pop(context);
                                    if (!mounted) return;
                                    setState(() {
                                      examStarted = true;
                                    });
                                    _startTimer();
                                  } else {
                                    if (!mounted) return;
                                    setDialogState(() {
                                      countdown--;
                                    });
                                  }
                                });
                                return AlertDialog(
                                  title: Text('Get Ready!'),
                                  content: Text(
                                    '$countdown',
                                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        child: Text('Start Exam'),
                      ),
                      ],
                    )
                else ...[
                  if (currentQuestionIndex < questions.length) ...[
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
                        Text(
                          'Score: $answeredQuestions / $totalQuestions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        SizedBox(height: 10),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Question ${currentQuestionIndex + 1} of $totalQuestions',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        // Display Current Question
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          elevation: 8,
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
                                foregroundColor: Colors.white,
                                backgroundColor: questions[currentQuestionIndex]['userAnswer'] ==
                                        questions[currentQuestionIndex]['options'][index]
                                    ? (questions[currentQuestionIndex]['isCorrect']
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onPressed: () {
                                setState(() {
                                  questions[currentQuestionIndex]['userAnswer'] =
                                      questions[currentQuestionIndex]['options'][index];
                                  questions[currentQuestionIndex]['isCorrect'] =
                                      questions[currentQuestionIndex]['options'][index] ==
                                          questions[currentQuestionIndex]['correctAnswer'];
                                  if (questions[currentQuestionIndex]['isCorrect']) {
                                    answeredQuestions++;
                                  }
                                  isAnswered = true;
                                });
                              },
                              child: Text(
                                questions[currentQuestionIndex]['options'][index],
                                style: TextStyle(fontSize: 16),
                              ),
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
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back),
                                    SizedBox(width: 4),
                                    Text('Previous'),
                                  ],
                                ),
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
                                child: Row(
                                  children: [
                                    Text('Next'),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            // Finish Exam Button
                            if (answeredQuestions == totalQuestions)
                              ElevatedButton(
                                onPressed: _endExam,
                                child: Row(
                                  children: [
                                    Icon(Icons.flag),
                                    SizedBox(width: 4),
                                    Text('Finish Exam'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Tip: You can pause the timer anytime using the pause button!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ] else ...[
                    Center(child: Text('Exam complete!')),
                  ],
                ],],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.deepPurple,
            icon: Icon(Icons.help_outline),
            label: Text('Help'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Need Help?'),
                  content: Text(
                    '📌 Answer all questions.\n📌 Click "Finish Exam" when done.\n📌 Use the pause button to stop the timer.\n\nAll the best!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.green, Colors.blue, Colors.purple, Colors.orange],
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}