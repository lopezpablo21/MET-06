import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final DatabaseReference _faucetRef = FirebaseDatabase.instance.ref('/board/modes/faucet/faucetval');
  final DatabaseReference _lightRef = FirebaseDatabase.instance.ref('/board/modes/light/auto/intensity');
  final DatabaseReference _fallRef = FirebaseDatabase.instance.ref('/board/modes/fall/falled');


  late StreamSubscription<DatabaseEvent> _faucetSubscription;
  late StreamSubscription<DatabaseEvent> _lightSubscription;
  late StreamSubscription<DatabaseEvent> _fallSubscription;


  String _faucetState = 'Loading...';
  String _lightState = 'Loading...';
  String _fallState = 'Loading...';
  String _medicineState = 'Not needed';

  @override
  void initState() {
    super.initState();

    _faucetSubscription = _faucetRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newValue = event.snapshot.value as int;
        setState(() {
          if (newValue == 0) {
            _faucetState = 'Faucet closed';
          } else {
            _faucetState = 'Faucet open';
          }
        });
      }
    });

    _lightSubscription = _lightRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final int newValue = event.snapshot.value as int;
        setState(() {
          if (newValue == 0) {
            _lightState = 'Light off';
          } else {
            _lightState = 'Light on';
          }
        });
      }
    });

    _fallSubscription = _fallRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final bool fallDetected = event.snapshot.value as bool;
        setState(() {
          if (fallDetected) {
            _fallState = 'Fall detected';
          } else {
            _fallState = 'No falls';
          }
        });
      }
    });


  }

  @override
  void dispose() {
    _faucetSubscription.cancel();
    _lightSubscription.cancel();
    _fallSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status', style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.purple[400],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(204, 159, 255, 1),
                  Colors.white,
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
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    children: [
                      _buildStatusCard(
                        icon: Icons.tap_and_play,
                        title: 'Faucet State',
                        subtitle: _faucetState,
                      ),
                      _buildStatusCard(
                        icon: Icons.lightbulb_outline,
                        title: 'Light State',
                        subtitle: _lightState,
                      ),
                      _buildStatusCard(
                        icon: Icons.warning,
                        title: 'Fall Alarm',
                        subtitle: _fallState,
                      ),
                      _buildStatusCard(
                        icon: Icons.medication,
                        title: 'Medicines',
                        subtitle: _medicineState,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.purple[400]),
          SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple[400])),
          SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}



