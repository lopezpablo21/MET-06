import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class LightScreen extends StatefulWidget {
  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  int _lightValue = 0;
  final DatabaseReference _lightRef = FirebaseDatabase.instance.ref('board/modes/light/intensity');
  late StreamSubscription<DatabaseEvent> _lightSubscription;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the light intensity value
    _lightSubscription = _lightRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newValue = event.snapshot.value as int;
        setState(() {
          _lightValue = newValue;
        });
      }
    });
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light Control', style: TextStyle(fontSize: 24)),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/main');
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nivel de Luz', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Icon(Icons.wb_sunny, size: 100, color: Colors.yellow),
              SizedBox(height: 20),
              Text('Lux: $_lightValue', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
