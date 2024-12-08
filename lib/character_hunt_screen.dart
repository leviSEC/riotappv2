import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class CharacterHuntScreen extends StatefulWidget {
  @override
  _CharacterHuntScreenState createState() => _CharacterHuntScreenState();
}

class _CharacterHuntScreenState extends State<CharacterHuntScreen> {
  List<CharacterQuestion> questions = [
    CharacterQuestion("Bu savaş benim başyapıtım olacak.", "Aatrox"),
    CharacterQuestion("Bana güvenmiyor musun?", "Ahri"),
    CharacterQuestion("Soraka acımızı biliyor, ama hissetmememizi, özümüzü inkar etmemizi söylüyor.", "Aphelios"),
    CharacterQuestion("İmparatorunuz geri dönecek.", "Azir"),
    CharacterQuestion("Replikleri sadece ses efektlerinden oluşmaktadır.", "Bard"),
    CharacterQuestion("Gaza geldim, hizmete hazırım.", "Blitzcrank"),
    CharacterQuestion("Dünyayı ateşe vermeye hazır mısın? Heh heh.", "Brand"),
    CharacterQuestion("Cesur ol.", "Braum"),
    CharacterQuestion("Bu iş tam benlik.", "Caitlyn"),
    CharacterQuestion("Gelişim asla bekletilmemeli.", "Camille"),
    CharacterQuestion("Bildiğim dünyanın son bulmasını istiyorsun, evet!", "Cho’Gath"),
    CharacterQuestion("Göreve hazırım. Uçağım da yıkılıyor!", "Corki"),
    CharacterQuestion("Onları yoluma çıktıklarına pişman edeceğim.", "Darius"),
    CharacterQuestion("Yeni bir ay doğuyor.", "Diana"),
    CharacterQuestion("Mundo istediği yere gider.", "Dr.Mundo"),
    CharacterQuestion("Geri çekil, kimi öldürüyoruz? İşimi seviyorum. Hah hah", "Draven"),
    CharacterQuestion("Iıı şey. Havalarda bir tuhaf bu aralar. Bildiğin robot olmuşsun ya.", "Ekko"),
    CharacterQuestion("Onları ağıma düşüreceğim.", "Elise"),
    CharacterQuestion("Vahşetin ortasında şafak vakti açmış bir çiçek gibi ışıldıyorum.", "Jhin"),
    CharacterQuestion("Wujuu benden sorulur.", "Master Yi"),
    CharacterQuestion("Düşmandan yüz çevirmek korkaklıktır.", "Tryndamere"),
    CharacterQuestion("Ölümde rüzgar gibi, hep yanı başımda.", "Yasuo"),
    CharacterQuestion("Kardeşim, yollarımız yine kesişti. Kılıçlarımız da kesişecek mi?", "Yone"),
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
  int _correctAnswerCount = 0;
  int currentQuestionIndex = 0;
  int score = 0;
  int timeLeft = 10;
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
      if (shuffledAnswers[currentQuestionIndex][selectedIndex] == questions[currentQuestionIndex].correctAnswer) {
        score++;
        _correctAnswerCount++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        shuffleAnswers();
      } else {
        _showResult();
      }
      startTimer();
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blue[800],
        title: Text("Oyun Bitti", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        content: Text("Toplam Puanınız: $score/${questions.length}", style: TextStyle(fontSize: 20, color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                currentQuestionIndex = 0;
                score = 0;
                _correctAnswerCount = 0;
                shuffleAnswers();
                startTimer();
              });
            },
            child: Text("Yeniden Oyna", style: TextStyle(color: Colors.blue[200])),
          ),
        ],
      ),
    );
  }

  void shuffleAnswers() {
    shuffledAnswers = questions.map((q) {
      String correctAnswer = q.correctAnswer;
      List<String> answers = [correctAnswer];

      while (answers.length < 4) {
        String randomChampion;
        do {
          randomChampion = champions[Random().nextInt(champions.length)];
        } while (answers.contains(randomChampion) || randomChampion == correctAnswer);
        answers.add(randomChampion);
      }
      answers.shuffle(Random());
      return answers;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    questions.shuffle(); // Soruları karıştır
    shuffleAnswers();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Karakter Avı', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sorular: ${currentQuestionIndex + 1}/${questions.length}",
                  style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
                Text(
                  "Doğru Cevaplar: $_correctAnswerCount",
                  style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[currentQuestionIndex].question,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                    ),
                    SizedBox(height: 20),
                    for (int i = 0; i < shuffledAnswers[currentQuestionIndex].length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => answerQuestion(i),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
                            backgroundColor: Colors.blue[600], // Butonun arka plan rengi
                            foregroundColor: Colors.white, // Butonun metin rengi
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            shuffledAnswers[currentQuestionIndex][i],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    Text(
                      "Süre: $timeLeft saniye",
                      style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterQuestion {
  final String question;
  final String correctAnswer;

  CharacterQuestion(this.question, this.correctAnswer);
}
