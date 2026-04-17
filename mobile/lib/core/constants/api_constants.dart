class ApiConstants {
  // Gunakan localhost untuk iOS Simulator, 10.0.2.2 untuk Android Emulator
  // Atau gunakan IP local machine Anda (contoh: 192.168.1.xx) jika ke device fisik
  static const String baseUrl = 'http://localhost:8080/v1';
 
  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';
 
  // Product endpoints
  static const String products = '/products';
 
  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
