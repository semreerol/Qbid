import 'package:flutter/material.dart';
import 'main_wrapper.dart'; // Giriş başarılı olursa buraya gideceğiz
import 'package:shared_preferences/shared_preferences.dart'; // ID'yi kaydetmek için
import '../api/api_service.dart'; // Backend servisi

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form verilerini tutacak kontrolcüler
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _api = ApiService();
  
  bool _isLoading = false; // Butonda dönen çark için
  bool _isObscure = true; // Şifre gizli mi?
  bool _rememberMe = false; // Beni hatırla seçili mi?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12), // Ana koyu arka plan
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {}, // Geri butonu (şu an işlevsiz)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // 1. Logo ve Başlık Alanı
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E202B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.bolt, size: 32, color: Color(0xFF5C51F6)), // Qbid Logosu
              ),
            ),
            const SizedBox(height: 32),
            
            const Center(
              child: Text(
                "Welcome Back",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Enter your details to access the bidding floor.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),

            // 2. Email Alanı
            const Text("Email", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController, 
              hint: "yourname@email.com",
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),

            // 3. Şifre Alanı
            const Text("Password", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _passwordController,
              hint: "••••••••",
              icon: Icons.lock_outline,
              isPassword: true,
            ),

            // 4. Beni Hatırla ve Şifremi Unuttum
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: const Color(0xFF5C51F6),
                        side: BorderSide(color: Colors.grey[600]!),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() => _rememberMe = val!);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("Remember me", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?", style: TextStyle(color: Color(0xFF5C51F6), fontSize: 12)),
                )
              ],
            ),

            const SizedBox(height: 32),

            // 5. Login Butonu
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () async {
  // 1. Boş mu diye kontrol et
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları doldurun")));
    return;
  }

  // 2. Yükleniyor durumuna geç
  setState(() => _isLoading = true);

  // 3. Backend'e sor
  final result = await _api.login(_emailController.text, _passwordController.text);

  // 4. Yükleniyor durumunu kapat
  if (mounted) setState(() => _isLoading = false);

  if (result['status'] == 'success') {
    // --- BAŞARILI ---
    
    // User ID'yi telefona kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', result['user_id']);
    await prefs.setString('email', result['email']);

    if (mounted) {
      // Ana Sayfaya Git
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const MainWrapper()),
      );
    }
  } else {
    // --- HATA ---
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Bir hata oluştu"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C51F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading 
    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
    : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 32),

            // 6. Sosyal Giriş Ayracı
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[800])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("OR CONTINUE WITH", style: TextStyle(fontSize: 10, color: Colors.grey[600], letterSpacing: 1)),
                ),
                Expanded(child: Divider(color: Colors.grey[800])),
              ],
            ),
            const SizedBox(height: 24),

            // 7. Sosyal Butonlar
            Row(
              children: [
                _buildSocialButton("Google", Icons.g_mobiledata), // Google ikonu asset gerektirir, şimdilik ikon koydum
                const SizedBox(width: 16),
                _buildSocialButton("Apple", Icons.apple),
              ],
            ),

            const SizedBox(height: 40),

            // 8. Kayıt Ol Linki
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: TextStyle(color: Colors.grey[500])),
                GestureDetector(
                  onTap: () {}, // Register sayfasına gidecek
                  child: const Text("Create an account", style: TextStyle(color: Color(0xFF5C51F6), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Yardımcı Widget: Özel TextField Tasarımı
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: const Color(0xFF1E202B), // Input arka plan rengi
        prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  // Yardımcı Widget: Sosyal Medya Butonu
  Widget _buildSocialButton(String label, IconData icon) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[800]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}