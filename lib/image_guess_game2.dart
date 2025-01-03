// Gerekli Flutter kütüphaneleri ve Dart araçlarını içe aktarıyoruz
import 'package:flutter/material.dart';
import 'dart:math';

// Oyunun ana widget'ını tanımlıyoruz
class ImageGuessGame2 extends StatefulWidget {
  final bool isDarkMode;

  ImageGuessGame2({required this.isDarkMode});

  @override
  _ImageGuessGame2State createState() => _ImageGuessGame2State();
}

// Widget'in durumu için bir sınıf tanımlıyoruz
class _ImageGuessGame2State extends State<ImageGuessGame2>
    with SingleTickerProviderStateMixin {
  // Şampiyon çiftlerini ve resimlerini içeren liste
  List<Map<String, String>> characters = [
    {'image': 'assets/images/1a.png', 'names': 'Thresh - Ahri'},
    {'image': 'assets/images/2a.png', 'names': 'Jinx - Mordekaiser'},
    {'image': 'assets/images/3a.png', 'names': 'Zed - Soraka'},
    {'image': 'assets/images/4a.png', 'names': 'Darius - Janna'},
    {'image': 'assets/images/5a.png', 'names': 'Draven - Morgana'},
    {'image': 'assets/images/6a.png', 'names': 'Elise - Braum'},
    {'image': 'assets/images/7a.png', 'names': 'Shyvana - Ezreal'},
    {'image': 'assets/images/8a.png', 'names': 'Kayn - Lux'},
    {'image': 'assets/images/9a.png', 'names': 'Nasus - Katarina'},
    {'image': 'assets/images/10a.png', 'names': 'Malphite - Janna'},
  ];

  // Oyun değişkenlerini tanımlıyoruz
  List<String> shuffledAnswers = [];
  String? correctAnswer;
  int currentQuestionIndex = 0;
  int score = 0;
  late AnimationController _animationController;
  Map<String, Color> buttonColors = {};

  // Yeni bir soru hazırlama fonksiyonu
  void _prepareQuestion() {
    Random random = Random();
    int correctIndex = random.nextInt(characters.length);

    String correctNames = characters[correctIndex]['names']!;

    // Cevap seçeneklerini oluştur
    List<String> options = [correctNames];
    while (options.length < 4) {
      String randomNames =
      characters[random.nextInt(characters.length)]['names']!;
      if (!options.contains(randomNames)) {
        options.add(randomNames);
      }
    }
    options.shuffle(); // Seçenekleri karıştır

    // Durumu güncelle
    setState(() {
      currentQuestionIndex = correctIndex;
      shuffledAnswers = options;
      correctAnswer = correctNames;
      buttonColors = {
        for (var option in options) option: widget.isDarkMode ? Colors.grey[700]! : Colors.deepPurpleAccent.shade100
      };
      _animationController.reset();
      _animationController.forward();
    });
  }

  // Cevap kontrol fonksiyonu
  void _checkAnswer(String selectedAnswer) {
    setState(() {
      if (selectedAnswer == correctAnswer) {
        buttonColors[selectedAnswer] = Colors.green; // Doğru cevap yeşil
        score++; // Skoru artır
        Future.delayed(Duration(milliseconds: 500), () {
          _prepareQuestion(); // Yeni soru hazırla
        });
      } else {
        buttonColors[selectedAnswer] = Colors.red; // Yanlış cevap kırmızı
        buttonColors[correctAnswer!] = Colors.green; // Doğru cevabı göster
        score = 0; // Yanlış cevapta skor sıfırlanır
        Future.delayed(Duration(milliseconds: 500), () {
          _prepareQuestion(); // Yeni soru hazırla
        });
      }
    });
  }

  // Widget'in yaşam döngüsü: başlatma
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Animasyon süresi
    );
    _prepareQuestion(); // İlk soruyu hazırla
  }

  // Widget'in yaşam döngüsü: temizleme
  @override
  void dispose() {
    _animationController.dispose(); // Animasyon kontrolcüsünü serbest bırak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resim Tahmini Modu 2",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor:
        widget.isDarkMode ? Colors.grey[900] : Colors.deepPurple,
      ),
      body: FadeTransition(
        opacity: _animationController, // Animasyon efektini uygula
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isDarkMode
                  ? [Colors.black87, Colors.grey[800]!]
                  : [Colors.purple.shade900, Colors.deepPurple.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Skor bilgisini göster
                Text(
                  'Doğru Sayısı: $score',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.greenAccent : Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Şampiyon resmini göster
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    characters[currentQuestionIndex]['image']!,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                // Soru metni
                Text(
                  'Bu hangi iki karakter?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                // Cevap butonları
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: shuffledAnswers.map((option) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: buttonColors[option],
                          foregroundColor: widget.isDarkMode
                              ? Colors.white
                              : Colors.deepPurple.shade900,
                          elevation: 3,
                          shadowColor: Colors.black45,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => _checkAnswer(option),
                        child: Text(option, textAlign: TextAlign.center),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}