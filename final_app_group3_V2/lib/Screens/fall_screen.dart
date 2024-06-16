import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FallSensorScreen extends StatefulWidget {
  @override
  _FallSensorScreenState createState() => _FallSensorScreenState();
}

class _FallSensorScreenState extends State<FallSensorScreen> {
  final DatabaseReference _fallSensorRef = FirebaseDatabase.instance.ref('board/modes/fall');
  bool _fallDetected = false;

  @override
  void initState() {
    super.initState();
    _fallSensorRef.onValue.listen((event) {
      final fallDetected = event.snapshot.value as bool;
      setState(() {
        _fallDetected = fallDetected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sensor de Caída', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          _fallDetected
              ? Text('¡Caída detectada!', style: TextStyle(fontSize: 20, color: Colors.red))
              : Text('No se detectó ninguna caída', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Lógica para simular caída (por ejemplo, actualizar el valor en la base de datos)
              _fallSensorRef.set(true);
            },
            child: Text('Simular Caída', style: TextStyle(fontSize: 20)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
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
