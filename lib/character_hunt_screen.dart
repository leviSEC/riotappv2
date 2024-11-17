import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CharacterHuntScreen extends StatefulWidget {
  @override
  _CharacterHuntScreenState createState() => _CharacterHuntScreenState();
}

class _CharacterHuntScreenState extends State<CharacterHuntScreen> {
  List<CharacterQuestion> questions = [
    CharacterQuestion("Bu Savaş Benim Başyapıtım Olacak.", "Aatrox"),
    CharacterQuestion("Göklerin temsilcisi olmayı istiyorsan,inanman yeter.", "Aphelios"),
    CharacterQuestion("Merhamet Dilenmek İçin Çok Geç.", "Ahri"),
    CharacterQuestion("Böylesine değişken bir kainatta, bu kadar durağan bir dünya içimi rahatlatıyor.", "Aurelion Sol"),
    CharacterQuestion("Shurima’sız bir gelecek düşünülemez.", "Azir"),
    CharacterQuestion("Burası fazla mı ısındı yoksa ben mi çok ateşliyim.", "Brand"),
    CharacterQuestion("Bazen donmuş bir yürek, sıcak bir tebessümle çözünür.", "Braum"),


    // Diğer soruları buraya ekleyin
  ];

  List<String> champions = [
    "Aatrox", "Ahri", "Akali", "Alistar", "Amumu", "Anivia", "Annie", "Aphelios",
    "Ashe", "Aurelion Sol", "Azir", "Bard", "Bel'Veth", "Blitzcrank", "Brand", "Braum",
    "Caitlyn", "Camille", "Cassiopeia", "Cho'Gath", "Corki", "Darius", "Diana", "Dr. Mundo",
    "Draven", "Ekko", "Elise", "Evelynn", "Fiddlesticks", "Fiora", "Fizz", "Galio",
    "Gangplank", "Garen", "Gnar", "Gragas", "Graves", "Gwen", "Hecarim", "Heimerdinger",
    "Illaoi", "Irelia", "Ivern", "Janna", "Jarvan IV", "Jax", "Jayce", "Jhin", "Jinx",
    "Kai'Sa", "Kalista", "Karma", "Karthus", "Kassadin", "Katarina", "Kayle", "Kayn",
    "Kennen", "Kha Zix", "Kled", "Kog Maw", "LeBlanc", "Lee Sin", "Leona", "Lillia",
    "Lissandra", "Lucian", "Lulu", "Lux", "Malphite", "Malzahar", "Maokai", "Master Yi",
    "Miss Fortune", "Mordekaiser", "Morgana", "Nami", "Nasus", "Nautilus", "Neeko",
    "Nidalee", "Nocturne", "Nunu & Willump", "Olaf", "Orianna", "Ornn", "Pantheon",
    "Poppy", "Pyke", "Qiyana", "Quinn", "Rakan", "Rammus", "Rek'Sai", "Rengar", "Riven",
    "Rumble", "Ryze", "Samira", "Sejuani", "Senna", "Seraphine", "Sett", "Shaco",
    "Shen", "Shyvana", "Singed", "Sion", "Sivir", "Skarner", "Sona", "Soraka", "Swain",
    "Sylas", "Syndra", "Tahm Kench", "Taliyah", "Talon", "Taric", "Teemo", "Thresh",
    "Tristana", "Trundle", "Tryndamere", "Twisted Fate", "Twitch", "Udyr", "Urgot",
    "Varus", "Vayne", "Veigar", "Vel'Koz", "Vex", "Vi", "Viktor", "Vladimir", "Volibear",
    "Warwick", "Wukong", "Xerath", "Xin Zhao", "Yone", "Yuumi", "Zac", "Zed", "Ziggs",
    "Zilean", "Zoe", "Zyra"
  ];

  List<List<String>> shuffledAnswers = [];
  int _correctAnswerCount = 0; // Doğru cevap sayısını tutacak değişken
  int currentQuestionIndex = 0;
  int score = 0;
  int timeLeft = 10; // Her soru için 10 saniye
  Timer? timer;

  void startTimer() {
    timeLeft = 10;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        timeLeft--;
        if (timeLeft == 0) {
          t.cancel();
          _showResult();
        }
      });
    });
  }

  void answerQuestion(int selectedIndex) {
    timer?.cancel();
    setState(() {
      // Doğru cevabı kontrol et
      if (shuffledAnswers[currentQuestionIndex][selectedIndex] == questions[currentQuestionIndex].correctAnswer) {
        score++;
        _correctAnswerCount++; // Doğru cevap sayısını artır
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResult();
      }
      shuffleAnswers(); // Cevapları karıştır
      startTimer();
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Oyun Bitti", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        content: Text("Toplam Puanınız: $score/${questions.length}", style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                _correctAnswerCount = 0; // Doğru cevap sayısını sıfırla
                shuffleAnswers(); // Cevapları karıştır
                startTimer();
              });
            },
            child: Text("Yeniden Oyna", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void shuffleAnswers() {
    shuffledAnswers = questions.map((q) {
      String correctAnswer = q.correctAnswer;
      List<String> answers = [correctAnswer];

      // Rastgele 3 farklı yanlış şampiyon ekle
      while (answers.length < 4) {
        String randomChampion;
        do {
          randomChampion = champions[Random().nextInt(champions.length)];
        } while (answers.contains(randomChampion) || randomChampion == correctAnswer); // Aynı cevabı ekleme

        answers.add(randomChampion);
      }
      answers.shuffle(Random()); // Cevapları karıştır
      return answers;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    shuffleAnswers(); // Oyun başladığında cevapları karıştır
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentAnswers = shuffledAnswers[currentQuestionIndex]; // Rastgele cevapları al

    return Scaffold(
      appBar: AppBar(
        title: Text("Karakter Avı", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[400]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doğru cevap sayısını göster
              Text(
                'Doğru Cevap Sayısı: $_correctAnswerCount',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                questions[currentQuestionIndex].questionText,
                style: TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text("Kalan Süre: $timeLeft", style: TextStyle(fontSize: 20, color: Colors.yellowAccent)),
              SizedBox(height: 20),
              ...currentAnswers.asMap().entries.map((entry) {
                int index = entry.key;
                String answer = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // buton arka plan rengi
                      foregroundColor: Colors.black, // buton metin rengi
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => answerQuestion(index),
                    child: Text(answer, style: TextStyle(fontSize: 18)),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class CharacterQuestion {
  String questionText;
  String correctAnswer;

  CharacterQuestion(this.questionText, this.correctAnswer);
}