import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures the body extends behind the appBar
      // appBar: AppBar(
      //   title: Text('Login'),
      //   backgroundColor: Colors.blueAccent,
      // ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo with Animation
                FadeTransition(
                  opacity: _logoAnimation,
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                
                // Welcome Text with Animation
                FadeTransition(
                  opacity: _logoAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Log in to your account',
                        style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Form with Slide Animation
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
                                    r"^[a-zA-Z0-9._%-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,4}$")
                                .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Password Input
                        _buildInputField(
                          controller: passwordController,
                          labelText: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Login Button with Hover Effect
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacementNamed(context, '/home');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              textStyle: TextStyle(fontSize: 18),
                              elevation: 5,
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Forgot Password
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Divider with "OR"
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.blueAccent)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'OR',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.blueAccent)),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Sign Up Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account?',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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

  // Custom Input Field with Focus Effect
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
          // Change the color when the field is focused
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