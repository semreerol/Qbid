import 'package:flutter/material.dart';

class AuctionCard extends StatelessWidget {
  final String title;
  final String currentBid;
  final String timeRemaining;
  final String imageUrl; // İnternetten resim çekmek için

  const AuctionCard({
    super.key,
    required this.title,
    required this.currentBid,
    required this.timeRemaining,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E202B), // Kart Rengi
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Resim Alanı ve Süre Etiketi
          Expanded(
            child: Stack(
              children: [
                // Arka Plan Resmi
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Sol Üst Süre Sayacı
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          timeRemaining,
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // Sağ Üst Kalp İkonu
                const Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 12,
                    child: Icon(Icons.favorite_border, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Bilgi Alanı
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("CURRENT BID", style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                        Text(
                          currentBid,
                          style: const TextStyle(color: Color(0xFF5C51F6), fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C51F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text("12 Bids", style: TextStyle(fontSize: 10, color: Color(0xFF5C51F6))),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}