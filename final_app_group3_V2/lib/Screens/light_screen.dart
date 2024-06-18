import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class LightScreen extends StatefulWidget {
  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  int _lightValue = 0;
  final DatabaseReference _lightRef = FirebaseDatabase.instance.ref('/board/modes/light/auto/intensity');
  final DatabaseReference _manualLightRef = FirebaseDatabase.instance.ref('board/modes/light/manual/value');
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

  void _increaseLightIntensity() {
    if (_lightValue < 3) {
      setState(() {
        _lightValue++;
      });
      _manualLightRef.set(_lightValue);
    }
  }

  void _decreaseLightIntensity() {
    if (_lightValue > 0) {
      setState(() {
        _lightValue--;
      });
      _manualLightRef.set(_lightValue);
    }
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _decreaseLightIntensity,
                    child: Text('Disminuir', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _increaseLightIntensity,
                    child: Text('Aumentar', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
