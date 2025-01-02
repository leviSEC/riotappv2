// Gerekli Flutter kütüphanesini ve ana menü widget'ını içe aktarıyoruz
import 'package:flutter/material.dart';
import 'main_menu.dart';

// Uygulamayı başlatmak için ana fonksiyon
void main() {
  runApp(MyApp()); // MyApp widget'ını çalıştır
}

// Ana uygulama widget'ı (StatefulWidget) tanımlanıyor
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Uygulamanın durum yönetimini sağlayacak sınıf çağrılıyor
}

// Uygulamanın durumunu yöneten sınıf
class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Karanlık modun açık olup olmadığını belirten değişken

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulama teması
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      // Eğer karanlık mod açıksa karanlık tema, değilse açık tema kullanılır

      // Ana menü widget'ını yükler
      home: MainMenu(
        isDarkMode: isDarkMode, // Tema modu bilgisini MainMenu'ye geçiriyoruz
        // Tema değiştirme işlevini tanımlıyoruz
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode; // Tema modunu tersine çevir
          });
        },
      ),
    );
  }
}
