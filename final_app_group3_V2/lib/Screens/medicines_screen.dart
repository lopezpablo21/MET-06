import 'package:flutter/material.dart';

class MedicinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines Screen', style: TextStyle(fontSize: 24, color: Colors.white)),
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
        ],
      ),
    );
  }
}
