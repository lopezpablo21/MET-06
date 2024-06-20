import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final String username;
  final String password;

  SettingsScreen({required this.username, required this.password});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.purple[400],
      ),
      body: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(204, 159, 255, 1),
                  Colors.white,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(username, style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text('Password:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(password, style: TextStyle(fontSize: 20)),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _signOut(context),
                    child: Text('Sign Out', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

