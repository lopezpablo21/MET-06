import 'package:flutter/material.dart';

class MedicinesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text('Medicines Screen', style: TextStyle(fontSize: 24)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
            ),
          ),
        ],
      ),
    );
  }
}
