import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String username;
  final String password;

  SettingsScreen({required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: $username', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Password: $password', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}