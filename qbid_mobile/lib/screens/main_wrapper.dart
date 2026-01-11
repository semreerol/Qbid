import 'package:flutter/material.dart';
import 'home_screen.dart'; // Birazdan yapacağız

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  // Sayfalar Listesi
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Watchlist (Yakında)")),
    const Center(child: Text("My Bids (Yakında)")),
    const Center(child: Text("Profile (Yakında)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Seçili sayfayı göster
      body: _pages[_currentIndex],
      
      // --- MODERN ALT MENÜ ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0B0D12),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF5C51F6), // Seçili ikon mor
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Watchlist'),
            BottomNavigationBarItem(icon: Icon(Icons.gavel), label: 'My Bids'), // Ortadaki ikon
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
      // Tasarımdaki gibi ortada yüzen bir "Sat" butonu eklemek istersek:
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF5C51F6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}