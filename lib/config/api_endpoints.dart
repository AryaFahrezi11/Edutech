class ApiEndpoints {
  // --- BASE URL ---
  static const String baseUrl = "http://127.0.0.1:5000/api";

  // --- AUTHENTICATION ---
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String googleLogin = "$baseUrl/google-login";

  // --- FITUR UJIAN ---
  static const String ujianMengeja = "$baseUrl/ujian-membaca";
  static const String ujianMenulis = "$baseUrl/ujian-menulis-gemini";
  
  // Nanti kamu bisa tambahkan endpoint lain di sini dengan mudah...
}