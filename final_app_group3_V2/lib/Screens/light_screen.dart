import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class LightScreen extends StatefulWidget {
  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  int _lightValue = 0;
  bool _changeMode = false;
  int valuetosend = 0;
  double _value2 = 0;
  double _value1 = 0;
  final DatabaseReference _lightRef = FirebaseDatabase.instance.ref(
      '/board/modes/light/auto/intensity');
  final DatabaseReference _manualLightRef = FirebaseDatabase.instance.ref(
      'board/modes/light/manual/value');
  final DatabaseReference _modeRef = FirebaseDatabase.instance.ref(
      'board/modes/light/mode');
  late StreamSubscription<DatabaseEvent> _lightSubscription;
  late StreamSubscription<DatabaseEvent> _manualSubscription;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the light intensity value
    _lightSubscription = _lightRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newValue = event.snapshot.value as int;
        setState(() {
          int newValue2 = ((newValue / 255) * 100).round();
          _lightValue = newValue2;
        });
      }
    });
    _manualSubscription = _manualLightRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newvalue3 = event.snapshot.value as int;
        setState(() {
          int newvalue4 = 0;
          if (newvalue3 == 0) {
            newvalue4 = 0;
          } else if (newvalue3 == 1) {
            newvalue4 = 10;
          } else if (newvalue3 == 2) {
            newvalue4 = 25;
          } else if (newvalue3 == 3) {
            newvalue4 = 66;
          } else if (newvalue3 == 4) {
            newvalue4 = 100;
          }
          _lightValue = newvalue4;
        });
      }
    });
  }

  @override
  void dispose() {
    _lightSubscription.cancel();
    super.dispose();
  }

  void _updateLightIntensity(double value) {
    setState(() {
      _lightValue = value.toInt();
    });


    if (_lightValue == 0) {
      valuetosend = 0;
    } else if (_lightValue > 0 && _lightValue <= 10) {
      valuetosend = 1;
    } else if (_lightValue > 10 && _lightValue <= 25) {
      valuetosend = 2;
    } else if (_lightValue > 25 && _lightValue <= 66) {
      valuetosend = 3;
    } else if (_lightValue > 66) {
      valuetosend = 4;
    }
    _manualLightRef.set(valuetosend);
  }

  int _mode = 1; // Initial mode

  void _togglemode() {
    setState(() {
      if (_mode == 1) {
        _modeRef.set(0); // Set mode 2
        _mode = 0; // Update current mode
      } else {
        _modeRef.set(1); // Set mode 1
        _mode = 1; // Update current mode
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Light Control', style: TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Light Level', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Icon(Icons.wb_sunny, size: 100, color: Colors.yellow),
              SizedBox(height: 20),
              Text('$_lightValue %', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Slider(
                value: _lightValue.toDouble(),
                min: 0,
                max: 100,
                label: _lightValue.toString(),
                onChanged: (value) {
                  _updateLightIntensity(value);
                },
              ),
              ElevatedButton(
                onPressed: _togglemode,
                child: Text(_mode == 1 ? 'Auto' : 'Manual', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mode == 1 ? Colors.green : Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}