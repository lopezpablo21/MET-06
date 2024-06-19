import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class FallSensorScreen extends StatefulWidget {
  @override
  _FallSensorScreenState createState() => _FallSensorScreenState();
}

class _FallSensorScreenState extends State<FallSensorScreen> {
  final DatabaseReference _fallSensorRef = FirebaseDatabase.instance.ref('/board/modes/fall/falled');
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
    Color color = _fallDetected ? Colors.red : Colors.green;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fall Detection Widget', style: TextStyle(fontSize: 24, color: Colors.white)), // Ajustar color del texto del título
        backgroundColor: Colors.purple[400], // Ajustar color del fondo del AppBar
      ),
      body: Stack(
        children: [
          // Fondo difuminado lila
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(204, 159, 255, 1), // Lila más fuerte
                  Colors.white, // Color blanco para mezclar
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fall Detection', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                _fallDetected
                    ? Text('¡FALL DETECTED!', style: TextStyle(fontSize: 20, color: Colors.red))
                    : Text('No Fall Detected', style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  color: color,
                  child: Center(
                    child: Text(
                      '', // Reemplazar con el contenido de texto real
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
