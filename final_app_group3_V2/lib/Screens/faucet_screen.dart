import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class FaucetScreen extends StatefulWidget {
  @override
  _FaucetScreenState createState() => _FaucetScreenState();
}

class _FaucetScreenState extends State<FaucetScreen> {
  double _value = 0.0;
  final DatabaseReference _faucetRef = FirebaseDatabase.instance.ref('/board/modes/faucet/faucetval');
  late StreamSubscription<DatabaseEvent> _faucetSubscription;
  bool _isEmergency = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the faucet value
    _faucetSubscription = _faucetRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newValue = event.snapshot.value as int;
        setState(() {
          if (newValue == 3) {
            _isEmergency = true;
          } else {
            _isEmergency = false;
            _value = newValue.toDouble();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _faucetSubscription.cancel();
    super.dispose();
  }

  void _updateFaucetValue(double value) {
    _faucetRef.set(value.toInt());
  }

  void _toggleEmergency() {
    if (_isEmergency) {
      _faucetRef.set(0);  // Salir de la emergencia
    } else {
      _faucetRef.set(3);  // Entrar en la emergencia
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faucet Control', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Regulate Opening', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Slider(
              value: _isEmergency ? 0.0 : _value,
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) {
                if (!_isEmergency) {
                  setState(() {
                    _value = value;
                  });
                  _updateFaucetValue(value);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleEmergency,
              child: Text('Emergency', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEmergency ? Colors.red : Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
