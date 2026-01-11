import 'package:dio/dio.dart';
import '../models/auction.dart';

class ApiService {
  // Android Emülatör için: "http://10.0.2.2:8000"
  // iOS Simülatör veya Web için: "http://127.0.0.1:8000"
  // Gerçek Telefon için: Bilgisayarının IP adresi (örn: 192.168.1.35:8000)
  final String baseUrl = "http://10.0.2.2:8000"; 
  final Dio _dio = Dio();

  Future<String> checkConnection() async {
    try {
      final response = await _dio.get('$baseUrl/');
      return response.data['message']; // Backend'den gelen "Qbid API Hazır!" mesajı
    } catch (e) {
      return "Bağlantı Hatası: $e";
    }
  }
  // ... mevcut kodların altına sınıfın içine ekle ...

  // Login Fonksiyonu
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('$baseUrl/login/', data: {
        "email": email,
        "password": password,
      });
      return response.data; // {status: success, user_id: 1, ...} dönecek
    } on DioException catch (e) {
      // Hata durumunda (404 veya 400 gelirse)
      if (e.response != null) {
        return {"status": "error", "message": e.response?.data['detail']};
      }
      return {"status": "error", "message": "Sunucuya ulaşılamadı"};
    }
  }
  // Teklif Verme Fonksiyonu
  Future<Map<String, dynamic>> createBid(int auctionId, int amount, int userId) async {
    try {
      final response = await _dio.post('$baseUrl/auctions/$auctionId/bids/', data: {
        "amount": amount,
      }, queryParameters: {
        "user_id": userId // Backend'de user_id'yi query param olarak almıştık
      });
      return {"status": "success", "data": response.data};
    } on DioException catch (e) {
      if (e.response != null) {
        return {"status": "error", "message": e.response?.data['detail'] ?? "Hata oluştu"};
      }
      return {"status": "error", "message": "Sunucu hatası"};
    }
  }
  // Tüm İlanları Getir
  Future<List<Auction>> getAuctions() async {
    try {
      final response = await _dio.get('$baseUrl/auctions/');
      
      // Gelen JSON listesini, Auction listesine çeviriyoruz
      List<dynamic> data = response.data;
      return data.map((json) => Auction.fromJson(json)).toList();
    } catch (e) {
      print("Veri çekme hatası: $e");
      return []; // Hata olursa boş liste dön
    }
  }
  // İlan Oluşturma
  Future<Map<String, dynamic>> createAuction(String title, String description, int minPrice, int userId) async {
    try {
      final response = await _dio.post('$baseUrl/auctions/', data: {
        "title": title,
        "description": description,
        "min_price": minPrice
      }, queryParameters: {
        "user_id": userId
      });
      return {"status": "success", "data": response.data};
    } catch (e) {
      return {"status": "error", "message": "İlan oluşturulamadı"};
    }
  }
}