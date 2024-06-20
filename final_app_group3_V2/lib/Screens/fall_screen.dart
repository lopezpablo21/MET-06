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
    return Scaffold(
      appBar: AppBar(
        title: Text('Fall Detection', style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.purple[400],
      ),
      body: Stack(
        fit: StackFit.expand,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _fallDetected
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 160,
                        color: Colors.red,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'FALL DETECTED!',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                      : Icon(
                    Icons.check_circle,
                    size: 120,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



