class ApiConstants {
  // BASE URL
  static const String baseUrl = "https://test.barpos.co.tz/api";

  //AUTH 
  static const String login = "$baseUrl/login";
  static const String registration = "$baseUrl/register/";
  static const String roles = "$baseUrl/roles/";

  // PASSWORD 
  static const String changePassword = "$baseUrl/change-password/";
  static const String forgotPassword = "$baseUrl/forgot-password";
  static const String tokenVerification = "$baseUrl/verify-email";
  static const String resetPassword = "$baseUrl/reset-password";


  // counter liost
   static const String fetchCounter = "$baseUrl/counters";

  // productlist
  static const String fetchProducts = "$baseUrl/counters";
  
}