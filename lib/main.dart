import 'package:flutter/material.dart';
import 'screens/detailed_screen.dart';
import 'screens/forgot_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/result_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/update_screen.dart';

void main() {
  runApp(OnlineExamSystem());
}

class OnlineExamSystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Exam System',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/result': (context) => ResultScreen(),
        '/detailed-results': (context) =>
            DetailedResultsScreen(), // Define the route here
        '/update-account': (context) =>
            UpdateAccountScreen(), // Define the route here
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
