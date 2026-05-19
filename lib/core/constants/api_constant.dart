class ApiConstants {
  // BASE URL
  static const String baseUrl = "https://test.barpos.co.tz/api";

  //AUTH
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";
  static const String registration = "$baseUrl/register/";
  static const String roles = "$baseUrl/roles/";

  // PASSWORD
  static const String changePassword = "$baseUrl/change-password/";
  static const String forgotPassword = "$baseUrl/forgot-password";
  static const String tokenVerification = "$baseUrl/verify-email";
  static const String resetPassword = "$baseUrl/reset-password";

  // counter list
  static const String fetchCounter = "$baseUrl/counters";

  // productlist
  static const String fetchProducts = "$baseUrl/counters";

  static const String submitOrder = "$baseUrl/orders/collect";
  static const String fetchOrder = "$baseUrl/orders/my-orders";
  static const String cancelOrder = "$baseUrl/orders";

  //counter orders
  static const String fetchCounterOrders = "$baseUrl/counters";

  //my counter
  static const String myCounter = "$baseUrl/counters/my-counters";

  //payment method

  static const String paymentMethod =
      "$baseUrl/payment-methods";

  // PICK / PROCESS ORDER
  static const String pickOrder =
      "$baseUrl/orders/process";


  // Counter submit order (pos)
  static const String counterSubmitOrder =
      "$baseUrl/orders/create";
}
