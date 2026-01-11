import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionDetailScreen extends StatelessWidget {
  final int auctionId;

  const AuctionDetailScreen({super.key, required this.auctionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Resim arkada tam ekran dursun diye body'yi extend ediyoruz
      extendBodyBehindAppBar: true, 
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
           decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
           child: const Text("LIVE AUCTION", style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.share, size: 20)),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, size: 20)),
          ),
        ],
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Ürün Görseli (Slider gibi)
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=800&q=80",
                fit: BoxFit.cover,
              ),
            ),

            // 2. Detay Alanı (Yukarı doğru kavisli)
            Container(
              transform: Matrix4.translationValues(0, -30, 0), // Resmi biraz kapatsın
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF0B0D12), // Ana arka plan rengi
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF1E202B), borderRadius: BorderRadius.circular(8)),
                        child: const Text("ELECTRONICS", style: TextStyle(fontSize: 10, color: Color(0xFF5C51F6), fontWeight: FontWeight.bold)),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text("4.9 (124)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Sony Alpha a7 IV Mirrorless Camera", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 8),
                  Text("Excellent Condition - Original Box Included", style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                  const SizedBox(height: 24),

                  // Fiyat ve Teklif İstatistikleri
                  Row(
                    children: [
                      _buildStatCard("CURRENT BID", "\$1,850", true),
                      const SizedBox(width: 16),
                      _buildStatCard("TOTAL BIDS", "24 Active", false),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sayaç Başlığı
                  const Center(child: Text("TIME REMAINING", style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1))),
                  const SizedBox(height: 12),
                  
                  // Sayaç Kutuları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeBox("02", "HOURS"),
                      _buildTimeSeparator(),
                      _buildTimeBox("45", "MINS"),
                      _buildTimeSeparator(),
                      _buildTimeBox("12", "SECS"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Gizli Fiyat Uyarısı (Blind Bid Card)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151725),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF5C51F6).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFF5C51F6).withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.visibility_off, color: Color(0xFF5C51F6)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Invisible Minimum Price", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5C51F6))),
                              const SizedBox(height: 4),
                              Text("The seller has a hidden reserve price. If your bid meets it, you win instantly.", 
                                style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Satıcı Bilgisi
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/32.jpg")),
                    title: const Text("Alex Rivera", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("POWER SELLER", style: TextStyle(fontSize: 10, color: Colors.blue)),
                    trailing: const Text("99.8% Rating", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Açıklama
                  const Text("Item Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "The Sony a7 IV is the ultimate hybrid mirrorless camera. This unit has been meticulously cared for, with a shutter count of only 4,200. Used primarily in a studio setting.",
                    style: TextStyle(color: Colors.grey[400], height: 1.5),
                  ),
                  const SizedBox(height: 100), // Alt bar için boşluk
                ],
              ),
            ),
          ],
        ),
      ),

      // --- STICKY BOTTOM BAR (Sabit Alt Bar) ---
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E202B),
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("\$ 1860", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showBidBottomSheet(context) ,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C51F6), // Qbid Moru
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Place Your Bid", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: İstatistik Kartı
  Widget _buildStatCard(String label, String value, bool isPrimary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E202B),
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? Border.all(color: Colors.white12) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Sayaç Kutusu
  Widget _buildTimeBox(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF5C51F6), // Mavi/Mor kutular
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(":", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
// ... (build fonksiyonu bitişi)

  void _showBidBottomSheet(BuildContext context) {
    // Girilen değeri tutmak için controller
    final TextEditingController amountController = TextEditingController();
    final ApiService api = ApiService();
    bool isSubmitting = false; // Yükleniyor kontrolü için (Stateful olmadığı için StatefulBuilder kullanacağız)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // BottomSheet içinde ekranı yenilemek için StatefulBuilder şart!
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 600,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E202B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 24),
                  const Text("Place a Bid", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text("Enter your bid amount for Auction #$auctionId", style: TextStyle(color: Colors.grey[400])),
                  const SizedBox(height: 32),
                  
                  // INPUT
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      prefixText: "\$ ",
                      prefixStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF5C51F6)),
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.grey[800]),
                      filled: true,
                      fillColor: const Color(0xFF0B0D12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // BUTONLAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickBidButton("+\$10"),
                      _buildQuickBidButton("+\$50"),
                      _buildQuickBidButton("+\$100"),
                    ],
                  ),
                  const Spacer(),
                  
                  // ONAYLA BUTONU (Canlı)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () async {
                        // 1. Değer kontrolü
                        if (amountController.text.isEmpty) return;
                        int amount = int.tryParse(amountController.text) ?? 0;

                        // 2. Yükleniyor başlat
                        setModalState(() => isSubmitting = true);

                        // 3. User ID'yi telefondan al
                        final prefs = await SharedPreferences.getInstance();
                        int? userId = prefs.getInt('user_id');

                        if (userId != null) {
                          // 4. Backend'e gönder
                          final result = await api.createBid(auctionId, amount, userId);
                          
                          // 5. Sonuca göre işlem yap
                          setModalState(() => isSubmitting = false);
                          Navigator.pop(context); // Pencereyi kapat

                          if (result['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✅ Teklifiniz başarıyla verildi!"), backgroundColor: Colors.green),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ Hata: ${result['message']}"), backgroundColor: Colors.red),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5C51F6),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: isSubmitting 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Confirm Bid", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Yardımcı Widget: Hızlı Teklif Butonu
  Widget _buildQuickBidButton(String amount) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.grey[800]!),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }  
}