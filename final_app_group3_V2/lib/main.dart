import 'package:flutter/material.dart';
import 'Screens/login_screen.dart';
import 'Screens/faucet_screen.dart';
import 'Screens/light_screen.dart';
import 'Screens/fall_screen.dart';
import 'Screens/settings_screen.dart';

void main() {
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

  static List<Widget> _widgetOptions = <Widget>[
    FaucetScreen(),
    LightScreen(),
    FallSensorScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontSize: 24)),
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
            label: 'Grifo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, color: _selectedIndex == 1 ? Colors.amber[800] : Colors.black),
            label: 'Luz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning, color: _selectedIndex == 2 ? Colors.amber[800] : Colors.black),
            label: 'Sensor de Caída',
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


