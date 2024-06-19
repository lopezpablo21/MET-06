import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Screens/login_screen.dart';
import 'Screens/faucet_screen.dart';
import 'Screens/light_screen.dart';
import 'Screens/fall_screen.dart';
import 'Screens/settings_screen.dart';
import 'Screens/medicines_screen.dart';

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
  final DatabaseReference _modeValRef = FirebaseDatabase.instance.ref('board/modeval');

  static List<Widget> _widgetOptions = <Widget>[
    FaucetScreen(),
    LightScreen(),
    FallSensorScreen(),
    MedicinesScreen(), // Añadir la nueva pantalla a la lista de opciones
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateModeVal(index); // Update Firebase with the new page index
    });
  }

  void _updateModeVal(int index) {
    _modeValRef.set(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PrimeCare', style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.purple[400],
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    username: widget.username,
                    password: widget.password,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.tap_and_play, color: _selectedIndex == 0 ? Colors.amber[800] : Colors.black),
            label: 'Faucet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, color: _selectedIndex == 1 ? Colors.amber[800] : Colors.black),
            label: 'Light',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, color: _selectedIndex == 2 ? Colors.amber[800] : Colors.black),
            label: 'Fall',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication, color: _selectedIndex == 3 ? Colors.amber[800] : Colors.black),
            label: 'Medicines',
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
