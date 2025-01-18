import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isProcessing = false;

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isProcessing = true;
      });
      
      final email = emailController.text;

      // Simulate a password reset request delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isProcessing = false;
        });

        // Add your logic for password reset here, such as sending an email.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Password Reset Email Sent'),
            content: Text(
              'A password reset email has been sent to $email. Please check your inbox.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize the animations
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is destroyed
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar removed for full-screen effect
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animation
                FadeTransition(
                  opacity: _logoAnimation,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Heading Text with animation
                FadeTransition(
                  opacity: _logoAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Reset Your Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enter your email address below, and we’ll send you a link to reset your password.',
                        style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Form with animation
                AnimatedBuilder(
                  animation: _formAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0.0, 50 * (1 - _formAnimation.value)),
                      child: child,
                    );
                  },
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email Input
                        _buildInputField(
                          controller: emailController,
                          labelText: 'Email',
                          icon: Icons.email,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Reset Button with progress indicator
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: isProcessing ? Colors.grey : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: isProcessing ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: TextStyle(fontSize: 18),
                              elevation: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: isProcessing
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                  : Text(
                                      'Send Reset Link',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Back to Login Option
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back to Login',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Input Field with focus effects
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool obscureText,
    required String? Function(String?) validator,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          // Handle focus changes
        });
      },
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.blueAccent),
        ),
      ),
    );
  }
}