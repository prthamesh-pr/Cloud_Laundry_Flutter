import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConnectionTest {
  static const String baseUrl = 'https://cloud-laundry.onrender.com';

  static Future<void> testConnection() async {
    print('🔄 Testing API connection to: $baseUrl');

    try {
      // Test basic connectivity
      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('✅ Connection successful!');
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response: ${response.body}');

      // Test auth endpoints availability
      await testAuthEndpoints();
    } catch (e) {
      print('❌ Connection failed: $e');
      print('🔍 Possible issues:');
      print('   - Backend not running');
      print('   - CORS configuration');
      print('   - Network connectivity');
      print('   - URL incorrect');
    }
  }

  static Future<void> testAuthEndpoints() async {
    print('\n🔐 Testing auth endpoints...');

    final endpoints = [
      '/api/v1/auth/login',
      '/api/v1/auth/register',
      '/api/v1/services',
      '/api/v1/orders',
    ];

    for (String endpoint in endpoints) {
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl$endpoint'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 5));

        print('✅ $endpoint - Status: ${response.statusCode}');
      } catch (e) {
        print('❌ $endpoint - Error: $e');
      }
    }
  }
}

// Run this test
void main() async {
  await ApiConnectionTest.testConnection();
}
