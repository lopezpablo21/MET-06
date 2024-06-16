import 'package:flutter/material.dart';
import 'dart:async';



class LightScreen extends StatefulWidget {
  @override
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  double _lightValue = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Simulate light sensor data update
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _lightValue = (_lightValue + 10) % 100; // Simulating light sensor data
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nivel de Luz', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Icon(Icons.wb_sunny, size: 100, color: Colors.yellow),
          SizedBox(height: 20),
          Text('Lux: ${_lightValue.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}