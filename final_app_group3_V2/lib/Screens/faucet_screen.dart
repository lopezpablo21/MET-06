import 'package:flutter/material.dart';
import 'dart:async';

class FaucetScreen extends StatefulWidget {
  @override
  _FaucetScreenState createState() => _FaucetScreenState();
}

class _FaucetScreenState extends State<FaucetScreen> {
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Emergency action
            },
            child: Text('Emergency', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _value = 0.0;
              });
            },
            child: Text('Stop', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}