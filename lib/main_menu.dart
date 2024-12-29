import 'package:flutter/material.dart';
import 'image_challenge_screen.dart'; // Resim mücadelesi ekranını içe aktarıyoruz
import 'character_hunt_screen.dart'; // Karakter Avı ekranını içe aktarıyoruz

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[100], // Aydınlık modda mavi arka plan
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[700],
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainMenu(
        isDarkMode: isDarkMode,
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  MainMenu({required this.isDarkMode, required this.onThemeToggle});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  double _scaleFactor1 = 1.0;
  double _scaleFactor2 = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.blue[900], // Zorla arka plan rengi ayarı
      appBar: AppBar(
        title: Text(
          'League of Legends Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/images/lolquiz.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              'Hoş Geldin!',
              style: TextStyle(
                fontSize: 42,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 6,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildAnimatedButton(
              context,
              'Resim Mücadelesi',
              widget.isDarkMode ? Colors.blueGrey[700]! : Colors.blue[600]!,
              Icons.image,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageChallengeScreen(
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
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
              widget.isDarkMode ? Colors.blueGrey[600]! : Colors.blue[700]!,
              Icons.person_search,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharacterHuntScreen(
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
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
    );
  }

  Widget _buildAnimatedButton(
      BuildContext context,
      String title,
      Color color,
      IconData icon,
      VoidCallback onPressed, {
        required double scaleFactor,
        required Function(double) onScaleChanged,
      }) {
    return GestureDetector(
      onTapDown: (_) => onScaleChanged(0.9),
      onTapUp: (_) => onScaleChanged(1.0),
      onTapCancel: () => onScaleChanged(1.0),
      child: Transform.scale(
        scale: scaleFactor,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadowColor: Colors.black54,
            elevation: 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 28,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
