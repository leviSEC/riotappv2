import 'package:flutter/material.dart';
import 'image_challenge_screen.dart'; // Resim mücadelesi ekranını içe aktarıyoruz

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('League of Legends Quiz'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[800]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hoş Geldin!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _buildMenuButton(context, 'Resim Mücadelesi', Colors.blue, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageChallengeScreen()), // Resim Mücadelesi ekranına git
                );
              }),
              SizedBox(height: 20),
              _buildMenuButton(context, 'Karakter Avı', Colors.deepPurpleAccent, () {
                // Karakter Avı ekranına yönlendirme
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Değişiklik burada
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
