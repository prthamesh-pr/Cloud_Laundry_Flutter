import 'package:http/http.dart' as http;
import 'dart:convert';

// Simple test to verify API connection
void main() async {
  const String baseUrl = 'https://cloud-laundry.onrender.com';

  print('🔄 Testing API connection...');

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

    print('✅ API is reachable');
    print('📊 Status: ${response.statusCode}');
    print('📄 Response: ${response.body}');
  } catch (e) {
    print('❌ Connection test failed: $e');

    // Try alternative endpoints
    try {
      final authTest = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': 'test@example.com',
              'password': 'test123',
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('🔐 Auth endpoint status: ${authTest.statusCode}');
      print('📄 Auth response: ${authTest.body}');
    } catch (authError) {
      print('❌ Auth endpoint test failed: $authError');
    }
  }
}
