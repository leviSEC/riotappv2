import 'package:flutter/material.dart';
import 'main_menu.dart'; // Ana menü ekranını içe aktarıyoruz

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'League of Legends Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: MainMenu(), // Ana menü ekranını başlat
    );
  }
}