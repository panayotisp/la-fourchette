/// API Configuration
class ApiConfig {
  // Change this to your backend URL
  // For local development: http://localhost:3000
  // For production: your deployed backend URL
  static const String baseUrl = 'http://localhost:3000';
  
  static const String menuEndpoint = '/api/menu/week';
  static const String ordersEndpoint = '/api/orders';
}
