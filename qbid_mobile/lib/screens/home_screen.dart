import 'package:flutter/material.dart';
import '../widgets/auction_card.dart';
import 'auction_detail_screen.dart';
import '../api/api_service.dart';
import '../models/auction.dart';
import 'auction_detail_screen.dart';
import 'create_auction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- APP BAR ---
      appBar: AppBar(
        title: Row(
          children: [
            // Logo niyetine ikon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text("QBID", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ],
        ),
        actions: [
  Container(
    margin: const EdgeInsets.only(right: 16),
    child: ElevatedButton.icon(
      // 1. Tıklama Olayı (Sayfa Gitme ve Yenileme)
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateAuctionScreen()),
        );

        // İlan eklendiyse sayfayı yenile
        if (result == true) {
          // ignore: use_build_context_synchronously
          (context as Element).markNeedsBuild();
        }
      },
      
      // 2. ZORUNLU İKON
      icon: const Icon(Icons.add_circle_outline, size: 16),
      
      // 3. ZORUNLU ETİKET (Hatayı veren kısım burasıydı)
      label: const Text("Start Selling"),
      
      // 4. Stil Ayarları
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2DD4BF), // Teal rengi
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  )
],
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Arama Çubuğu
            TextField(
              decoration: InputDecoration(
                hintText: 'Search items, brands...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: Icon(Icons.tune, color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF1E202B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Kategoriler (Chip Listesi)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip("All", true),
                  _buildCategoryChip("Electronics", false),
                  _buildCategoryChip("Fashion", false),
                  _buildCategoryChip("Collectibles", false),
                  _buildCategoryChip("Art", false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Başlık: Live Auctions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text("Live Auctions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.circle, size: 8, color: Colors.redAccent), // Canlı kırmızı nokta
                  ],
                ),
                TextButton(onPressed: () {}, child: const Text("View all", style: TextStyle(color: Colors.grey)))
              ],
            ),
            const SizedBox(height: 12),

            // 4. Müzayede Listesi (Grid)
            // 1. Veriyi çekecek Future (Gelecek) tanımı
FutureBuilder<List<Auction>>(
  future: ApiService().getAuctions(), // API'ye git ve verileri al
  builder: (context, snapshot) {
    // A. Veri Bekleniyor mu?
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF5C51F6)));
    }
    
    // B. Hata mı var?
    if (snapshot.hasError) {
      return Center(child: Text("Hata: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
    }

    // C. Veri geldi mi?
    final auctions = snapshot.data ?? [];

    if (auctions.isEmpty) {
      return const Center(child: Text("Henüz hiç ilan yok.", style: TextStyle(color: Colors.grey)));
    }

    // D. Listeyi Çiz
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: auctions.length,
      itemBuilder: (context, index) {
        final auction = auctions[index];
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // Tıklanan ürünün gerçek ID'sini detay sayfasına gönderiyoruz!
                builder: (context) => AuctionDetailScreen(auctionId: auction.id),
              ),
            );
          },
          child: AuctionCard(
            title: auction.title,
            // Şimdilik fiyat ve süreyi rastgele/sabit gösteriyoruz (Backend'de bu alanları geliştirince bağlarız)
            currentBid: "\$ --", 
            timeRemaining: "Live", 
            // Her ID için farklı bir resim atayalım ki güzel görünsün
            imageUrl: "https://picsum.photos/seed/${auction.id}/500/500", 
          ),
        );
      },
    );
  },
),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: const Color(0xFF1E202B),
        selectedColor: const Color(0xFF5C51F6),
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}