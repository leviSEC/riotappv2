import 'package:flutter/material.dart'; // Flutter materyal paketini içe aktarıyoruz.
import 'package:http/http.dart' as http; // HTTP istekleri için http paketini içe aktarıyoruz.
import 'dart:convert'; // JSON verilerini işlemek için gerekli kütüphane.
import 'dart:typed_data'; // Byte veri türlerini kullanmak için gerekli kütüphane.
import 'dart:math'; // Rastgele sayılar için gerekli kütüphane.
import 'package:image/image.dart' as img; // Resim işleme için gerekli kütüphane.

class ImageChallengeScreen extends StatefulWidget {
  @override
  _ImageChallengeScreenState createState() => _ImageChallengeScreenState();
}

class _ImageChallengeScreenState extends State<ImageChallengeScreen> with SingleTickerProviderStateMixin {
  List<String> _championImages = []; // Şampiyon resimlerini tutan liste.
  List<String> _championNames = []; // Şampiyon isimlerini tutan liste.
  Uint8List? _combinedImageBytes; // Birleşik resim verileri.
  final String _apiKey = 'RGAPI-8eb51bdb-ea9a-408e-b56a-797aef4ffdf7'; // API anahtarı.
  String? _correctAnswer; // Doğru cevap.
  List<String> _answerOptions = []; // Cevap seçeneklerini tutan liste.
  String? _selectedAnswer; // Kullanıcının seçtiği cevap.
  bool _isAnswerCorrect = false; // Cevabın doğru olup olmadığını kontrol eden bayrak.
  bool _isButtonEnabled = true; // Buton durumunu kontrol eden bayrak.

  // Buton animasyon kontrolörü ve animasyon değişkenleri
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _fetchChampionImages(); // Şampiyon resimlerini yükle.

    // Buton animasyon kontrolörü
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  // Şampiyon resimlerini API'den yükleyen fonksiyon
  Future<void> _fetchChampionImages() async {
    final response = await http.get(Uri.parse(
        'https://ddragon.leagueoflegends.com/cdn/12.19.1/data/en_US/champion.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      data['data'].forEach((key, value) {
        String imageUrl =
            'https://ddragon.leagueoflegends.com/cdn/12.19.1/img/champion/${value['id']}.png';
        _championImages.add(imageUrl); // Resim URL'sini listeye ekle.
        _championNames.add(value['name']); // Şampiyon adını listeye ekle.
      });
      setState(() {
        _combineImages(); // Resimleri birleştir.
      });
    } else {
      throw Exception('Şampiyon resimleri yüklenemedi');
    }
  }

  // İki şampiyon resmini birleştiren fonksiyon
  Future<void> _combineImages() async {
    if (_championImages.length < 2) return; // Yeterli resim yoksa çık.

    Random random = Random();
    int index1 = random.nextInt(_championImages.length); // Rastgele ilk resim indeksi.
    int index2 = random.nextInt(_championImages.length); // Rastgele ikinci resim indeksi.

    // Aynı resim olmaması için kontrol et.
    while (index1 == index2) {
      index2 = random.nextInt(_championImages.length);
    }

    String imageUrl1 = _championImages[index1]; // İlk resim URL'si.
    String imageUrl2 = _championImages[index2]; // İkinci resim URL'si.
    String name1 = _championNames[index1]; // İlk şampiyon adı.
    String name2 = _championNames[index2]; // İkinci şampiyon adı.

    // Resimleri indir.
    final response1 = await http.get(Uri.parse(imageUrl1));
    final response2 = await http.get(Uri.parse(imageUrl2));

    img.Image? image1 = img.decodeImage(response1.bodyBytes); // İlk resmi decode et.
    img.Image? image2 = img.decodeImage(response2.bodyBytes); // İkinci resmi decode et.

    if (image1 != null && image2 != null) {
      img.Image blurredImage1 = img.gaussianBlur(image1, 3); // İlk resmi bulanıklaştır.
      img.Image blurredImage2 = img.gaussianBlur(image2, 3); // İkinci resmi bulanıklaştır.

      int width = max(blurredImage1.width, blurredImage2.width); // Genişlik.
      int height = max(blurredImage1.height, blurredImage2.height); // Yükseklik.

      img.Image combinedImage = img.Image(width, height); // Birleşik resmi oluştur.
      combinedImage.fill(0xFFFFFFFF); // Arka planı beyaz yap.

      // Piksel piksel karıştırma işlemi
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          int color1 = (x < blurredImage1.width && y < blurredImage1.height) ? blurredImage1.getPixel(x, y) : 0xFFFFFFFF;
          int color2 = (x < blurredImage2.width && y < blurredImage2.height) ? blurredImage2.getPixel(x, y) : 0xFFFFFFFF;
          int mixedColor = _mixColors(color1, color2); // Renkleri karıştır.
          combinedImage.setPixel(x, y, mixedColor); // Birleşik resme piksel ekle.
        }
      }

      _combinedImageBytes = Uint8List.fromList(img.encodePng(combinedImage)); // Birleşik resmi byte dizisine çevir.
      setState(() {
        _correctAnswer = '$name1 - $name2'; // Doğru cevabı ayarla.
        _buildAnswerOptions(name1, name2); // Cevap seçeneklerini oluştur.
        _selectedAnswer = null; // Seçilen cevabı sıfırla.
        _isAnswerCorrect = false; // Cevap durumunu sıfırla.
      });
    }
  }

  // İki rengi karıştıran fonksiyon
  int _mixColors(int color1, int color2) {
    int r1 = img.getRed(color1);
    int g1 = img.getGreen(color1);
    int b1 = img.getBlue(color1);
    int r2 = img.getRed(color2);
    int g2 = img.getGreen(color2);
    int b2 = img.getBlue(color2);

    int r = ((r1 + r2) / 2).round(); // Kırmızı renk değeri.
    int g = ((g1 + g2) / 2).round(); // Yeşil renk değeri.
    int b = ((b1 + b2) / 2).round(); // Mavi renk değeri.

    return img.getColor(r, g, b); // Karıştırılmış rengi döndür.
  }

  // Cevap seçeneklerini oluşturan fonksiyon
  void _buildAnswerOptions(String name1, String name2) {
    _answerOptions = []; // Cevap seçeneklerini sıfırla.
    _answerOptions.add(_correctAnswer!); // Doğru cevabı ekle.

    Random random = Random();
    while (_answerOptions.length < 4) { // 4 seçenek olana kadar döngü.
      String randomName1 = _championNames[random.nextInt(_championNames.length)]; // Rastgele ilk şampiyon adı.
      String randomName2 = _championNames[random.nextInt(_championNames.length)]; // Rastgele ikinci şampiyon adı.

      // Seçenekler arasında tekrar yoksa ekle.
      if (randomName1 != randomName2 && !_answerOptions.contains('$randomName1 - $randomName2')) {
        _answerOptions.add('$randomName1 - $randomName2');
      }
    }

    _answerOptions.shuffle(); // Seçenekleri karıştır.
  }

  // Cevabı kontrol eden fonksiyon
  void _checkAnswer(String selectedAnswer) {
    if (!_isButtonEnabled) return; // Butonlar devre dışıysa çık.

    setState(() {
      _selectedAnswer = selectedAnswer; // Seçilen cevabı ayarla.
      _isAnswerCorrect = selectedAnswer == _correctAnswer; // Cevabın doğru olup olmadığını kontrol et.

      // Buton animasyonunu başlat
      if (_isAnswerCorrect) {
        _buttonController.forward().then((_) {
          _buttonController.reverse();
        });
      } else {
        _buttonController.forward().then((_) {
          _buttonController.reverse();
        });
      }

      // Butonları devre dışı bırak
      _isButtonEnabled = false;
    });

    // 3 saniye bekledikten sonra yeni girdiye izin ver
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isButtonEnabled = true; // Butonları yeniden etkinleştir.
      });

      // Eğer cevap doğruysa, beklemeden sonra yeni bir soru yükle
      if (_isAnswerCorrect) {
        _combineImages(); // Yeni resim kombinasyonu oluştur.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resim Mücadelesi'), // Uygulama başlığı
        backgroundColor: Colors.blueAccent, // Uygulama çubuğu rengi
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( // Arka plan gradyanı
            colors: [Colors.blue[800]!, Colors.blue[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView( // Kaydırılabilir içerik
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_combinedImageBytes != null) ...[ // Eğer birleşik resim varsa
                  Image.memory(
                    _combinedImageBytes!,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Bu karışım hangi iki karakterden oluşuyor?', // Soruyu göster
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: _answerOptions.map((option) { // Cevap seçeneklerini göster
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 1.0,
                            end: _isAnswerCorrect && _selectedAnswer == option ? 1.2 : 1.1,
                          ).animate(
                            CurvedAnimation(
                              parent: _buttonController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled ? () => _checkAnswer(option) : null, // Buton devre dışıysa tıklama
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: _selectedAnswer == option
                                  ? (_isAnswerCorrect ? Colors.green : Colors.red)
                                  : Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose(); // Kontrolörü serbest bırak
    super.dispose();
  }
}