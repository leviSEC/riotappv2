// Gerekli Flutter kütüphaneleri ve Dart'tan bazı araçları içe aktarıyoruz
import 'package:flutter/material.dart';
import 'dart:math';

// Oyun widget'ını tanımlıyoruz
class ImageGuessGame extends StatefulWidget {
  final bool isDarkMode;

  ImageGuessGame({required this.isDarkMode});

  @override
  _ImageGuessGameState createState() => _ImageGuessGameState();
}

// Oyun durumunu yönetmek için bir sınıf tanımlıyoruz
class _ImageGuessGameState extends State<ImageGuessGame>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> characters = [
    {'image': 'assets/images/1.png', 'name': 'Thresh'},
    {'image': 'assets/images/2.png', 'name': 'Yasuo'},
    {'image': 'assets/images/3.png', 'name': 'Ahri'},
    {'image': 'assets/images/4.png', 'name': 'Soraka'},
    {'image': 'assets/images/5.png', 'name': 'Zed'},
    {'image': 'assets/images/6.png', 'name': 'Teemo'},
    {'image': 'assets/images/7.png', 'name': 'Riven'},
    {'image': 'assets/images/8.png', 'name': 'Heimerdinger'},
    {'image': 'assets/images/9.png', 'name': 'Trundle'},
    {'image': 'assets/images/10.png', 'name': 'Irelia'},
    {'image': 'assets/images/11.png', 'name': 'Zoe'},
    {'image': 'assets/images/12.png', 'name': 'Warwick'},
    {'image': 'assets/images/13.png', 'name': 'Gragas'},
    {'image': 'assets/images/14.png', 'name': 'Khazix'},
    {'image': 'assets/images/15.png', 'name': 'Vayne'},
    {'image': 'assets/images/16.png', 'name': 'Nami'},
    {'image': 'assets/images/17.png', 'name': 'Leona'},
    {'image': 'assets/images/18.png', 'name': 'Shen'},
    {'image': 'assets/images/19.png', 'name': 'Jhin'},
    {'image': 'assets/images/20.png', 'name': 'Fiora'},
    {'image': 'assets/images/21.png', 'name': 'Nunu and Willump'},
    {'image': 'assets/images/22.png', 'name': 'Malphite'},
    {'image': 'assets/images/23.png', 'name': 'Evelynn'},
    {'image': 'assets/images/24.png', 'name': 'Anivia'},
    {'image': 'assets/images/25.png', 'name': 'Darius'},
    {'image': 'assets/images/26.png', 'name': 'Lux'},
    {'image': 'assets/images/27.png', 'name': 'Talon'},

  ];

  // Cevap seçeneklerini ve diğer oyun değişkenlerini tanımlıyoruz
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

    String correctName = characters[correctIndex]['name']!;

    // Cevap seçeneklerini oluştur
    List<String> options = [correctName];
    while (options.length < 4) {
      String randomName = characters[random.nextInt(characters.length)]['name']!;
      if (!options.contains(randomName)) {
        options.add(randomName);
      }
    }
    options.shuffle();

    // Durumu güncelle
    setState(() {
      currentQuestionIndex = correctIndex;
      shuffledAnswers = options;
      correctAnswer = correctName;
      buttonColors = {for (var option in options) option: widget.isDarkMode ? Colors.grey[700]! : Colors.deepPurpleAccent.shade100};
      _animationController.reset();
      _animationController.forward();
    });
  }

  // Cevap kontrol fonksiyonu
  void _checkAnswer(String selectedAnswer) {
    setState(() {
      if (selectedAnswer == correctAnswer) {
        buttonColors[selectedAnswer] = Colors.green; // Doğru cevap yeşil
        score++;
        Future.delayed(Duration(milliseconds: 500), () {
          _prepareQuestion(); // Yeni soru yükle
        });
      } else {
        buttonColors[selectedAnswer] = Colors.red; // Yanlış cevap kırmızı
        buttonColors[correctAnswer!] = Colors.green; // Doğru cevabı göster
        score = 0; // Yanlış cevapta skor sıfırlanır
        Future.delayed(Duration(milliseconds: 500), () {
          _prepareQuestion(); // Yeni soru yükle
        });
      }
    });
  }



  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _prepareQuestion(); // İlk soruyu hazırla
  }

  @override
  void dispose() {
    _animationController.dispose(); // Animasyon kontrolcüsünü serbest bırak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şampiyon Tahmini"),
        centerTitle: true,
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.deepPurple,
      ),
      body: FadeTransition(
        opacity: _animationController,
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
                // Skoru göster
                Text(
                  'Doğru Sayısı: $score',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.greenAccent : Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Şampiyon resmi
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
                Text(
                  'Bu hangi şampiyon?',
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
