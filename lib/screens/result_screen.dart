import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
// import 'package:fluttertoast/fluttertoast.dart'; // For adding toast messages (optional)

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Example data
    final int totalQuestions = 10;
    final int correctAnswers = 7;
    final int incorrectAnswers = totalQuestions - correctAnswers;
    final bool passed = correctAnswers >= 6;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Results', style: TextStyle(fontSize: 24, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: passed ? Colors.green[100] : Colors.red[100],
                child: Icon(
                  passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                  color: passed ? Colors.green[800] : Colors.red[800],
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Exam Results',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Score Summary Card with gradient background
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              shadowColor: Colors.blueAccent.withOpacity(0.5),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total Questions: $totalQuestions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Correct Answers: $correctAnswers',
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    ),
                    Text(
                      'Incorrect Answers: $incorrectAnswers',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    SizedBox(height: 15),
                    // Status Text with Animation
                    AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: Text(
                        passed ? 'Status: Passed 🎉' : 'Status: Failed 😔',
                        key: ValueKey<bool>(passed),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: passed ? Colors.green : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                              value: correctAnswers / totalQuestions,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey[300],
                              color: passed ? Colors.green : Colors.red,
                            ),
                          ),
                          Text(
                            '${((correctAnswers / totalQuestions) * 100).toInt()}%',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Icon for Passed/Failed status
                    Icon(
                      passed ? Icons.check_circle : Icons.cancel,
                      color: passed ? Colors.green : Colors.red,
                      size: 40,
                    ),
                    SizedBox(height: 15),
                    // Animated Progress Bar for additional feedback
                    AnimatedContainer(
                      duration: Duration(seconds: 1),
                      child: LinearProgressIndicator(
                        value: correctAnswers / totalQuestions,
                        backgroundColor: Colors.grey[300],
                        color: passed ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 15),
                    Card(
                      color: passed ? Colors.lightGreen[100] : Colors.red[50],
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          passed
                              ? 'Great job! Keep up the good work!'
                              : 'Don\'t worry! Keep practicing and try again!',
                          style: TextStyle(
                            color: passed ? Colors.green[800] : Colors.red[800],
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: Colors.blue[50],
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '“Success is not final, failure is not fatal: it is the courage to continue that counts.”',
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.indigo),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Confetti effect on pass
            if (passed)
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
              ),
            SizedBox(height: 20),
            // Action Buttons with Elevated Styles and Spacing
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to detailed answers screen (not implemented here)
                Navigator.pushNamed(context, '/detailed-results');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 12.0)),
              icon: Icon(Icons.list_alt),
              label: Text('View Detailed Answers', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Restart exam logic
                Navigator.pop(context); // Return to the previous screen
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, padding: EdgeInsets.symmetric(vertical: 12.0)),
              icon: Icon(Icons.refresh),
              label: Text('Retry Exam', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 10),
            // Share Button with Toast (optional feature)
            ElevatedButton.icon(
              onPressed: () {
                // Share exam results (can implement sharing logic here)
                // Fluttertoast.showToast(msg: "Result shared successfully!"); // Just a placeholder
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: EdgeInsets.symmetric(vertical: 12.0)),
              icon: Icon(Icons.share),
              label: Text('Share Results', style: TextStyle(fontSize: 16)),
            ),
            Spacer(),
            // Footer with Styling
            Text(
              'Thank you for taking the exam!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (passed) {
            _confettiController.play(); // Trigger confetti animation on button press
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.card_giftcard),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Tap the gift to celebrate!',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ),
    );
  }
}