import 'package:flutter/material.dart';
import '../models/user.dart';
import 'recording_screen.dart';
import 'chat_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    if (widget.user.isAdmin) {
      _screens = [
        RecordingScreen(),
        ChatScreen(username: widget.user.name),
        HistoryScreen(),
      ];
      _navItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.mic),
          label: 'הקלטה',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'צ׳אט',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'היסטוריה',
        ),
      ];
    } else {
      _screens = [
        ChatScreen(username: widget.user.name),
        HistoryScreen(),
      ];
      _navItems = [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'צ׳אט',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'היסטוריה',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.isAdmin ? 'מסך מורה' : 'מסך תלמיד'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
} 