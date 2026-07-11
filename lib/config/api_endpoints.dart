class ApiEndpoints {
  // --- BASE URL ---
  static const String baseUrl = "https://be-edutech.vercel.app/api";

  // --- AUTHENTICATION ---
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String googleLogin = "$baseUrl/google-login";
  static const String updateProfile = "$baseUrl/update-profile";
  static const String forgotPassword = "$baseUrl/forgot-password";
  static const String resetPassword = "$baseUrl/reset-password";

  // --- FITUR UJIAN ---
  static const String ujianMengeja = "$baseUrl/ujian-membaca";
  static const String ujianMenulis = "$baseUrl/ujian-menulis-gemini";

  // --- GAMIFIKASI & PROGRESS ---
  static const String syncProgress = "$baseUrl/sync-progress";
  static const String getProgress = "$baseUrl/get-progress";
  static const String leaderboard = "$baseUrl/leaderboard";

  // LOGS
  static const String addActivityLog = "$baseUrl/activity/log";
  static const String getActivityLogs = "$baseUrl/activity/logs";

  // Nanti kamu bisa tambahkan endpoint lain di sini dengan mudah...
}
