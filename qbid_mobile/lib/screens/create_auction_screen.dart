import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  State<CreateAuctionScreen> createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final ApiService _api = ApiService();
  bool _isLoading = false;

  void _submitAuction() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen başlık ve fiyat girin")));
      return;
    }

    setState(() => _isLoading = true);

    // User ID'yi al
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen önce giriş yapın")));
      setState(() => _isLoading = false);
      return;
    }

    // Backend'e gönder
    final result = await _api.createAuction(
      _titleController.text,
      _descController.text,
      int.parse(_priceController.text),
      userId,
    );

    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      if (mounted) {
        Navigator.pop(context, true); // Geri dön ve sayfayı yenile sinyali ver
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ İlan başarıyla açıldı!"), backgroundColor: Colors.green));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: ${result['message']}"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Start Selling"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Listing Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),

            // Başlık
            _buildLabel("Listing Title"),
            _buildTextField(_titleController, "e.g. Vintage Camera", Icons.title),
            
            const SizedBox(height: 24),

            // Açıklama
            _buildLabel("Description"),
            _buildTextField(_descController, "Describe your item...", Icons.description, maxLines: 3),

            const SizedBox(height: 24),

            // Fiyat
            _buildLabel("Minimum Price (Hidden)"),
            _buildTextField(_priceController, "2500", Icons.attach_money, isNumber: true),
            const Text("This is the lowest price you accept. Bidders won't see this.", style: TextStyle(color: Colors.grey, fontSize: 12)),

            const SizedBox(height: 40),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitAuction,
                icon: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                  : const Icon(Icons.rocket_launch, color: Colors.white),
                label: const Text("Post Listing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C51F6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: const Color(0xFF1E202B),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}