import 'package:flutter/material.dart';
import 'api/api_service.dart';
import 'screens/main_wrapper.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qbid',
      debugShowCheckedModeBanner: false,
      // --- TASARIMINDAKİ DARK TEMA ---
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0D12), // Derin Siyah/Lacivert
        primaryColor: const Color(0xFF5C51F6), // Qbid Moru (Primary Indigo)
        cardColor: const Color(0xFF1E202B), // Kartların Rengi
        
        // Renk Şeması
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5C51F6),
          secondary: Color(0xFF2DD4BF), // Electric Teal
          surface: Color(0xFF1E202B),
          background: Color(0xFF0B0D12),
        ),

        // Yazı Stilleri (Manrope benzeri modern bir font için)
        fontFamily: 'Roboto', // İleride Google Fonts ekleriz
        
        // AppBar Teması
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String message = "Backend bekleniyor...";
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    testConnection();
  }

  void testConnection() async {
    String result = await api.checkConnection();
    setState(() {
      message = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qbid Bağlantı Testi")),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}