import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello Flutter!',
              style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w500, color:Color(0xFF2196F3)),
            ),
            SizedBox(height: 8),
            Text('Ini teks biasa dengan ukuran kecil',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  ));
}