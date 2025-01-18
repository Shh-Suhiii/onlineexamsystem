import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Theme toggle state
  bool notificationsEnabled = true; // Notification toggle state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/avatar.png'), // Placeholder image
              ),
              SizedBox(width: 16),
              Text(
                'John Doe', // Replace with dynamic user name
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(),

          // Theme Toggle
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.blueAccent),
            title: Text('Dark Mode', style: TextStyle(fontSize: 18)),
            subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled', style: TextStyle(color: Colors.grey)),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                // Logic for applying dark mode can be added here
              },
            ),
          ),
          Divider(),

          // Notification Settings
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blueAccent),
            title: Text('Notifications', style: TextStyle(fontSize: 18)),
            subtitle: Text(notificationsEnabled ? 'Enabled' : 'Disabled', style: TextStyle(color: Colors.grey)),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          Divider(),

          // Language Selection
          ListTile(
            leading: Icon(Icons.language, color: Colors.blueAccent),
            title: Text('Language', style: TextStyle(fontSize: 18)),
            subtitle: Text('English', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Logic to change language can be implemented here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('English'),
                        onTap: () {
                          // Apply English language
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Spanish'),
                        onTap: () {
                          // Apply Spanish language
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Divider(),

          // Reset Settings
          ListTile(
            leading: Icon(Icons.restore, color: Colors.blueAccent),
            title: Text('Reset Settings', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Show confirmation dialog before resetting settings
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Reset Settings'),
                  content: Text('Are you sure you want to reset all settings?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // Reset settings to default values
                          isDarkMode = false;
                          notificationsEnabled = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),

          // Account Management
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.blueAccent),
            title: Text('Update Account Information', style: TextStyle(fontSize: 18)),
            subtitle: Text('Edit your profile details', style: TextStyle(color: Colors.grey)),
            onTap: () {
              // Navigate to Account Update Screen (not implemented here)
              Navigator.pushNamed(context, '/update-account');
            },
          ),
          Divider(),

          // Log Out
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blueAccent),
            title: Text('Log Out', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Log out logic
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Log Out'),
                  content: Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement log-out functionality
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Log Out'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}