// Gerekli Flutter kütüphanelerini ve diğer ekranları içe aktarıyoruz
import 'package:flutter/material.dart';
import 'image_challenge_screen.dart';
import 'character_hunt_screen.dart';
import 'image_guess_game.dart';
import 'image_guess_game2.dart';

// Uygulamayı başlatmak için ana fonksiyon
void main() {
  runApp(MyApp()); // MyApp widget'ını çalıştır
}

// Ana uygulama widget'ı (StatefulWidget) tanımlanıyor
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Uygulamanın durum yönetimini tanımlayan sınıf çağrılıyor
}

// Uygulamanın durumunu yöneten sınıf
class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Karanlık modun açık olup olmadığını belirten değişken

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulama için açık tema ayarları
      theme: ThemeData(
        primarySwatch: Colors.blue, // Ana renk teması mavi
        scaffoldBackgroundColor: Colors.blue[100], // Arka plan rengi
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800], // Uygulama çubuğu rengi
        ),
      ),
      // Uygulama için karanlık tema ayarları
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema parlaklığı karanlık
        primarySwatch: Colors.blue, // Ana renk teması mavi
        scaffoldBackgroundColor: Colors.grey[900], // Karanlık arka plan rengi
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900], // Uygulama çubuğu rengi
        ),
      ),
      // Kullanıcı seçimine göre tema modunu belirler
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Ana menü widget'ını yükler
      home: MainMenu(
        isDarkMode: isDarkMode,
        // Tema değiştirme işlevi
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode; // Tema modunu tersine çevir
          });
        },
      ),
    );
  }
}

// Ana menü widget'ı
class MainMenu extends StatefulWidget {
  final bool isDarkMode; // Karanlık modun açık olup olmadığını belirler
  final VoidCallback onThemeToggle; // Tema değiştirme işlevini alır

  MainMenu({required this.isDarkMode, required this.onThemeToggle}); // Ana menü için yapılandırıcı

  @override
  _MainMenuState createState() => _MainMenuState(); // Ana menünün durumunu yöneten sınıf
}

// Ana menü durum yönetimi
class _MainMenuState extends State<MainMenu> {
  // Her bir butonun animasyon ölçek faktörlerini tutar
  double _scaleFactor1 = 1.0;
  double _scaleFactor2 = 1.0;
  double _scaleFactor3 = 1.0;
  double _scaleFactor4 = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ana ekranın arka plan rengini ayarla
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.blue[900],
      appBar: AppBar(
        // Uygulama çubuğu başlığı
        title: Text(
          'League of Legends Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Yazı kalınlığı
            fontSize: 26, // Yazı boyutu
            shadows: [
              Shadow(
                offset: Offset(1, 1), // Gölgenin yatay ve dikey uzaklığı
                blurRadius: 3, // Gölgenin bulanıklığı
                color: Colors.black54, // Gölgenin rengi
              ),
            ],
          ),
        ),
        // Sağ üst köşede tema değiştirme düğmesi
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, // İkonu tema moduna göre seç
              color: widget.isDarkMode ? Colors.white : Colors.black, // İkon rengi
            ),
            onPressed: widget.onThemeToggle, // Tema değiştirme işlevini çağır
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Ana içeriği kaydırılabilir yap
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // İçerik minimum boyutta olacak şekilde ayarlanır
            children: [
              SizedBox(height: 1), // Boşluk
              // Uygulama logosunu gösterir
              Image.asset(
                'assets/images/lolquiz.png',
                width: 300,
                height: 300,
              ),
              SizedBox(height: 1), // Boşluk
              // Hoş geldin mesajını gösterir
              Text(
                'Hoş Geldin!',
                style: TextStyle(
                  fontSize: 35, // Yazı boyutu
                  color: Colors.white, // Yazı rengi
                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                  letterSpacing: 2, // Harfler arasındaki boşluk
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2), // Gölge uzaklığı
                      blurRadius: 6, // Gölge bulanıklığı
                      color: Colors.black87, // Gölge rengi
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Boşluk
              // Resim Mücadelesi düğmesi
              _buildAnimatedButton(
                context,
                'Resim Mücadelesi',
                Colors.blue,
                Colors.lightBlueAccent,
                Icons.image,
                // Tıklama işlevi
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
                    _scaleFactor1 = scale; // Ölçek faktörünü güncelle
                  });
                },
              ),
              SizedBox(height: 20),
              // Karakter Avı düğmesi
              _buildAnimatedButton(
                context,
                'Karakter Avı',
                Colors.teal,
                Colors.greenAccent,
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
                    _scaleFactor2 = scale; // Ölçek faktörünü güncelle
                  });
                },
              ),
              SizedBox(height: 20),
              // Resim Tahmini düğmesi
              _buildAnimatedButton(
                context,
                'Resim Tahmini Modu',
                Colors.orange,
                Colors.yellowAccent,
                Icons.quiz,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageGuessGame(
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                scaleFactor: _scaleFactor3,
                onScaleChanged: (scale) {
                  setState(() {
                    _scaleFactor3 = scale; // Ölçek faktörünü güncelle
                  });
                },
              ),
              SizedBox(height: 20),
              // Resim Tahmini Modu 2 düğmesi
              _buildAnimatedButton(
                context,
                'Resim Tahmini Modu 2',
                Colors.purple,
                Colors.deepPurpleAccent,
                Icons.people,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageGuessGame2(
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                scaleFactor: _scaleFactor4,
                onScaleChanged: (scale) {
                  setState(() {
                    _scaleFactor4 = scale; // Ölçek faktörünü güncelle
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Animasyonlu düğme oluşturma fonksiyonu
  Widget _buildAnimatedButton(
      BuildContext context,
      String title,
      Color startColor,
      Color endColor,
      IconData icon,
      VoidCallback onPressed, {
        required double scaleFactor,
        required Function(double) onScaleChanged,
      }) {
    final isDarkMode = widget.isDarkMode;

    // Karanlık modda özel renkler
    final darkStartColor = Colors.grey[800];
    final darkEndColor = Colors.grey[700];

    return GestureDetector(
      onTapDown: (_) => onScaleChanged(0.95), // Tıklandığında küçült
      onTapUp: (_) => onScaleChanged(1.0), // Bırakıldığında normale dön
      onTapCancel: () => onScaleChanged(1.0), // İptal edildiğinde normale dön
      child: Transform.scale(
        scale: scaleFactor, // Ölçeklendirme
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [darkStartColor!, darkEndColor!]
                  : [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30), // Yuvarlak köşeler
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed, // Düğme işlevi
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Düğme boyutlandırması
              backgroundColor: Colors.transparent, // Arka plan rengi
              shadowColor: Colors.transparent, // Gölge rengi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Yuvarlatılmış köşeler
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon, // Düğmenin simgesi
                  size: 22,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  title, // Düğmenin metni
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
