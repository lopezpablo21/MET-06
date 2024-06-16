import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FaucetScreen extends StatefulWidget {
  @override
  _FaucetScreenState createState() => _FaucetScreenState();
}

class _FaucetScreenState extends State<FaucetScreen> {
  double _value = 0.0;
  final DatabaseReference _faucetRef = FirebaseDatabase.instance.ref('board/modes/faucet');

  void _updateFaucetValue(double value) {
    _faucetRef.set(value.toInt());
  }

  void _emergencyStop() {
    _faucetRef.set(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grifo Control', style: TextStyle(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Grifo Control', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Slider(
              value: _value,
              min: 0,
              max: 2,
              divisions: 2,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
                _updateFaucetValue(value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _emergencyStop,
              child: Text('Emergency', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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

