import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Screens/login_screen.dart';
import 'Screens/faucet_screen.dart';
import 'Screens/light_screen.dart';
import 'Screens/fall_screen.dart';
import 'Screens/settings_screen.dart';
import 'Screens/medicines_screen.dart';
import 'Screens/status_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18.0),
          bodyMedium: TextStyle(fontSize: 18.0),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  final String password;

  HomeScreen({required this.username, required this.password});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Widget _currentScreen = FaucetScreen();
  String _currentTitle = 'PrimeCare';
  bool _isSpecialScreen = false;
  final DatabaseReference _modeValRef = FirebaseDatabase.instance.ref('board/modeval');

  static List<Widget> _widgetOptions = <Widget>[
    FaucetScreen(),
    LightScreen(),
    FallSensorScreen(),
    MedicinesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentScreen = _widgetOptions[index];
      _currentTitle = 'PrimeCare';
      _isSpecialScreen = false;
      _updateModeVal(index);
    });
  }

  void _updateModeVal(int index) {
    _modeValRef.set(index);
  }

  void _navigateToScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
      _currentTitle = 'PrimeCare';
      _isSpecialScreen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _currentTitle,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.purple[400],
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {
            _navigateToScreen(StatusScreen());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _navigateToScreen(SettingsScreen(
                username: widget.username,
                password: widget.password,
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: _currentScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play, color: _selectedIndex == 0 && !_isSpecialScreen ? Colors.amber[800] : Colors.black),
            label: _isSpecialScreen ? '' : 'Faucet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, color: _selectedIndex == 1 && !_isSpecialScreen ? Colors.amber[800] : Colors.black),
            label: _isSpecialScreen ? '' : 'Light',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, color: _selectedIndex == 2 && !_isSpecialScreen ? Colors.amber[800] : Colors.black),
            label: _isSpecialScreen ? '' : 'Fall',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication, color: _selectedIndex == 3 && !_isSpecialScreen ? Colors.amber[800] : Colors.black),
            label: _isSpecialScreen ? '' : 'Medicines',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        iconSize: 36,
        selectedFontSize: 20,
      ),
    );
  }
}
















