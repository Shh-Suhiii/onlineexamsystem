import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart'; // Optional for sharing results

class DetailedResultsScreen extends StatelessWidget {
  const DetailedResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data for the questions and answers
    final List<Map<String, dynamic>> results = [
      {
        'question': 'What is 2 + 2?',
        'correctAnswer': '4',
        'userAnswer': '4',
        'isCorrect': true,
        'explanation': '2 + 2 equals 4.',
        'type': 'Math',
      },
      {
        'question': 'What is the capital of France?',
        'correctAnswer': 'Paris',
        'userAnswer': 'Berlin',
        'isCorrect': false,
        'explanation': 'The capital of France is Paris.',
        'type': 'Geography',
      },
      // Add more questions as needed
    ];

    int correctAnswers = results.where((result) => result['isCorrect'] == true).length;
    int totalQuestions = results.length;
    int incorrectAnswers = totalQuestions - correctAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Results', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Answers:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 16),
            // Summary Section
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.blueAccent.withOpacity(0.2), blurRadius: 4, spreadRadius: 1),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Questions: $totalQuestions', style: TextStyle(fontSize: 16)),
                  Text('Correct: $correctAnswers', style: TextStyle(fontSize: 16, color: Colors.green)),
                  Text('Incorrect: $incorrectAnswers', style: TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),
            ),
            // Results List
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Type Icon
                          Row(
                            children: [
                              Icon(
                                result['type'] == 'Math' ? Icons.calculate : Icons.location_on,
                                color: Colors.blueAccent,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                result['question'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Your Answer: ',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              Text(
                                result['userAnswer'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: result['isCorrect'] ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Correct Answer: ',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              Text(
                                result['correctAnswer'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Explanation: ${result['explanation']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 12),
                          // Answer Status Icon
                          Row(
                            children: [
                              Icon(
                                result['isCorrect'] ? Icons.check_circle : Icons.cancel,
                                color: result['isCorrect'] ? Colors.green : Colors.red,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                result['isCorrect'] ? 'Correct' : 'Incorrect',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: result['isCorrect'] ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Share Results Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement sharing functionality
                  // Fluttertoast.showToast(msg: "Results shared successfully!"); // Placeholder
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  'Share Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            // Back to Results Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  'Back to Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}