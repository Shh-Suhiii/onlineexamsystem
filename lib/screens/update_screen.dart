import 'package:flutter/material.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;  // Loading state for saving data

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Dummy password strength checker
  String? _checkPasswordStrength(String password) {
    if (password.length < 6) {
      return 'Password is too short';
    }
    if (password.length < 8) {
      return 'Password is weak';
    }
    return null;  // Strong password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Update Your Account Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              
              // Profile Picture Section
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Trigger image picker logic here
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Name Input Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Email Input Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Password Input Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  return _checkPasswordStrength(value ?? '');
                },
              ),
              SizedBox(height: 10),
              
              // Password Strength Indicator
              Text(
                _checkPasswordStrength(_passwordController.text) ?? 'Password is strong',
                style: TextStyle(
                  color: _checkPasswordStrength(_passwordController.text) == null
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              
              // Save Button (with loading state)
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });
                      // Show confirmation dialog
                      bool shouldSave = await _showConfirmationDialog();
                      if (shouldSave) {
                        // Simulate saving account updates
                        await Future.delayed(Duration(seconds: 2));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Account updated successfully!')),
                        );
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: Text('Save Changes', style: TextStyle(fontSize: 18)),
                ),
              SizedBox(height: 10),
              
              // Cancel Button
              TextButton(
                onPressed: () {
                  // Cancel action: Navigate back or clear fields
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirmation Dialog
  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm Changes'),
              content: Text('Are you sure you want to save these changes?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}