import 'package:flutter/material.dart';
import 'exam_screen.dart';
import 'result_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int unreadNotifications = 3;
  List<String> notifications = [
    'New Exam Available: Math Test',
    'Exam Results Updated: Physics',
    'Reminder: Upcoming Chemistry Exam'
  ];
  String userRole = 'Student'; // Added user role for a more personal touch

  void markAsRead() {
    setState(() {
      unreadNotifications = 0;
    });
    Navigator.pop(context); // Close the popup when the user marks as read
  }

  // Function to change background based on the time of day
  LinearGradient getDynamicBackground() {
    DateTime now = DateTime.now();
    if (now.hour >= 6 && now.hour <= 18) {
      // Daytime background
      return LinearGradient(
        colors: [Colors.blueAccent, Colors.lightBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // Nighttime background
      return LinearGradient(
        colors: [Colors.blueGrey, Colors.black87],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User', style: TextStyle(color: Colors.white)),
                Text(userRole, style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: getDynamicBackground(),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications, size: 28),
                if (unreadNotifications > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$unreadNotifications',
                          style: TextStyle(fontSize: 8, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showNotificationPopup(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: getDynamicBackground(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              _buildSearchBar(),
              SizedBox(height: 16),
              // Quick Access Section (Latest Exams/Results)
              _buildQuickAccess(),
              SizedBox(height: 16),
              // Grid View
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildCard(context, 'Start Exam', Icons.edit, ExamScreen()),
                    _buildCard(context, 'View Results', Icons.score, ResultScreen()),
                    _buildCard(context, 'Settings', Icons.settings, SettingsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        onPressed: () {
          // Implement action (e.g., add new exam)
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  // Quick Access Widget: Display latest exam/reminder
  Widget _buildQuickAccess() {
    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 6,
      shadowColor: Colors.blueAccent.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(Icons.access_time, color: Colors.blueAccent),
        title: Text('Upcoming Exam: Chemistry Test', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        subtitle: Text('Check your exam schedule', style: TextStyle(color: Colors.blueAccent)),
        onTap: () {
          // Navigate to the Exam Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExamScreen()),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.05),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white.withOpacity(0.8),
          elevation: 10,
          shadowColor: Colors.blueAccent.withOpacity(0.4),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 48, color: Colors.blueAccent),
                SizedBox(height: 16),
                Text(title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          icon: Icon(Icons.search, color: Colors.blueAccent),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Method to show notification popup
  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have $unreadNotifications new notifications.'),
            SizedBox(height: 10),
            ...notifications.map((notification) {
              return ListTile(
                leading: Icon(Icons.notification_important),
                title: Text(notification),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: markAsRead,
            child: Text('Mark as Read'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Custom Animated Floating Action Button
class AnimatedFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget child;

  const AnimatedFloatingActionButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedFloatingActionButtonState createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation = Tween(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton(
        onPressed: () {
          _controller.forward().then((value) {
            _controller.reverse();
          });
          widget.onPressed();
        },
        backgroundColor: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }
}