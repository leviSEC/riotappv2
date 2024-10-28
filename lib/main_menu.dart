import 'package:flutter/material.dart';
import 'image_challenge_screen.dart'; // Resim mücadelesi ekranını içe aktarıyoruz

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  double _scaleFactor1 = 1.0;
  double _scaleFactor2 = 1.0;

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
              _buildAnimatedButton(
                context,
                'Resim Mücadelesi',
                Colors.blue,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImageChallengeScreen()), // Resim Mücadelesi ekranına git
                  );
                },
                scaleFactor: _scaleFactor1,
                onScaleChanged: (scale) {
                  setState(() {
                    _scaleFactor1 = scale;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildAnimatedButton(
                context,
                'Karakter Avı',
                Colors.deepPurpleAccent,
                    () {
                  // Karakter Avı ekranına yönlendirme
                },
                scaleFactor: _scaleFactor2,
                onScaleChanged: (scale) {
                  setState(() {
                    _scaleFactor2 = scale;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(
      BuildContext context,
      String title,
      Color color,
      VoidCallback onPressed, {
        required double scaleFactor,
        required Function(double) onScaleChanged,
      }) {
    return GestureDetector(
      onTapDown: (_) => onScaleChanged(0.9), // Basıldığında küçült
      onTapUp: (_) => onScaleChanged(1.0), // Bırakıldığında büyüt
      onTapCancel: () => onScaleChanged(1.0), // İptal edildiğinde büyüt
      child: Transform.scale(
        scale: scaleFactor,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
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
        ),
      ),
    );
  }
}
