class Auction {
  final int id;
  final String title;
  final String description;
  final int ownerId;
  final bool isActive;
  // Resim URL'si şimdilik backend'de yok, o yüzden rastgele atayacağız veya boş bırakacağız.
  
  Auction({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.isActive,
  });

  // JSON'dan nesneye dönüştürme fabrikası
  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      ownerId: json['owner_id'],
      isActive: json['is_active'] ?? true,
    );
  }
}