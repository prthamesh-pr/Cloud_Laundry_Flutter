import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/service.dart';

class ApiService {
  static const String baseUrl = 'https://cloud-laundry.onrender.com';
  static String? _authToken;

  // Initialize API service with stored token
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
  }

  // Headers for API requests
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Error handling wrapper
  static Future<ApiResponse<T>> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check if response body is empty or null
        if (response.body.isEmpty) {
          return ApiResponse.error('Empty response from server');
        }

        final data = json.decode(response.body);

        // Check if decoded data is null
        if (data == null) {
          return ApiResponse.error('Invalid response format from server');
        }

        // If data is not a Map, try to extract the actual data
        Map<String, dynamic> responseData;
        if (data is Map<String, dynamic>) {
          responseData = data;
        } else {
          return ApiResponse.error('Invalid response format from server');
        }

        return ApiResponse.success(fromJson(responseData));
      } else if (response.statusCode == 401) {
        await _clearAuthToken();
        return ApiResponse.error('Authentication failed. Please login again.');
      } else {
        // Handle error responses safely
        try {
          final errorData = json.decode(response.body);
          final message = errorData['message'] ?? 'An error occurred';
          return ApiResponse.error(message);
        } catch (e) {
          return ApiResponse.error(
            'Request failed with status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // List wrapper for handling list responses
  static Future<ApiResponse<List<T>>> _handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Check if response body is empty or null
        if (response.body.isEmpty) {
          return ApiResponse.error('Empty response from server');
        }

        final data = json.decode(response.body);

        // Check if decoded data is null
        if (data == null) {
          return ApiResponse.error('Invalid response format from server');
        }

        // Handle different response formats
        List<dynamic> listData;
        if (data is List) {
          listData = data;
        } else if (data is Map<String, dynamic>) {
          listData = data['data'] ?? data['items'] ?? [];
        } else {
          return ApiResponse.error('Invalid response format from server');
        }

        final List<T> items = listData.map((item) {
          if (item is Map<String, dynamic>) {
            return fromJson(item);
          } else {
            throw Exception('Invalid item format in response');
          }
        }).toList();

        return ApiResponse.success(items);
      } else if (response.statusCode == 401) {
        await _clearAuthToken();
        return ApiResponse.error('Authentication failed. Please login again.');
      } else {
        // Handle error responses safely
        try {
          final errorData = json.decode(response.body);
          final message = errorData['message'] ?? 'An error occurred';
          return ApiResponse.error(message);
        } catch (e) {
          return ApiResponse.error(
            'Request failed with status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Store auth token
  static Future<void> _storeAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Clear auth token
  static Future<void> _clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Check if user is authenticated
  static bool get isAuthenticated => _authToken != null;

  // Authentication endpoints
  static const String loginEndpoint = '$baseUrl/api/v1/auth/login';
  static const String registerEndpoint = '$baseUrl/api/v1/auth/register';
  static const String refreshTokenEndpoint = '$baseUrl/api/v1/auth/refresh';
  static const String logoutEndpoint = '$baseUrl/api/v1/auth/logout';
  static const String getMeEndpoint = '$baseUrl/api/v1/auth/me';

  // User endpoints
  static const String userProfileEndpoint = '$baseUrl/api/v1/users/profile';
  static const String updateProfileEndpoint = '$baseUrl/api/v1/users/profile';
  static const String changePasswordEndpoint =
      '$baseUrl/api/v1/users/change-password';

  // Order endpoints
  static const String ordersEndpoint = '$baseUrl/api/v1/orders';
  static const String createOrderEndpoint = '$baseUrl/api/v1/orders';
  static const String orderStatusEndpoint = '$baseUrl/api/v1/orders';

  // Schedule endpoints
  static const String schedulesEndpoint = '$baseUrl/api/v1/schedules';
  static const String createScheduleEndpoint = '$baseUrl/api/v1/schedules';
  static const String updateScheduleEndpoint = '$baseUrl/api/v1/schedules';
  static const String cancelScheduleEndpoint = '$baseUrl/api/v1/schedules';

  // Services endpoints
  static const String servicesEndpoint = '$baseUrl/api/v1/services';
  static const String serviceDetailsEndpoint = '$baseUrl/api/v1/services';

  // Payment endpoints
  static const String paymentMethodsEndpoint =
      '$baseUrl/api/v1/payments/methods';
  static const String addPaymentMethodEndpoint =
      '$baseUrl/api/v1/payments/methods';
  static const String removePaymentMethodEndpoint =
      '$baseUrl/api/v1/payments/methods';

  // Notification endpoints
  static const String notificationsEndpoint = '$baseUrl/api/v1/notifications';
  static const String markAsReadEndpoint = '$baseUrl/api/v1/notifications';

  // Address endpoints
  static const String addressesEndpoint = '$baseUrl/api/v1/users/addresses';
  static const String addAddressEndpoint = '$baseUrl/api/v1/users/addresses';
  static const String updateAddressEndpoint = '$baseUrl/api/v1/users/addresses';
  static const String deleteAddressEndpoint = '$baseUrl/api/v1/users/addresses';

  // Settings endpoints
  static const String settingsEndpoint = '$baseUrl/api/v1/users/settings';
  static const String updateSettingsEndpoint = '$baseUrl/api/v1/users/settings';

  // Support endpoints
  static const String supportTicketsEndpoint = '$baseUrl/support/tickets';
  static const String createSupportTicketEndpoint = '$baseUrl/support/tickets';

  // Upload endpoints
  static const String uploadImageEndpoint = '$baseUrl/upload/image';
  static const String uploadDocumentEndpoint = '$baseUrl/upload/document';

  // Analytics endpoints
  static const String userStatsEndpoint = '$baseUrl/analytics/user-stats';
  static const String orderStatsEndpoint = '$baseUrl/analytics/order-stats';

  // Promotional endpoints
  static const String promosEndpoint = '$baseUrl/promos';
  static const String applyPromoEndpoint = '$baseUrl/promos/apply';

  // Feedback endpoints
  static const String feedbackEndpoint = '$baseUrl/feedback';
  static const String ratingsEndpoint = '$baseUrl/ratings';

  // Configuration endpoints
  static const String appConfigEndpoint = '$baseUrl/config/app';
  static const String serviceAreasEndpoint = '$baseUrl/config/service-areas';

  // ==================== AUTH METHODS ====================

  static Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: _headers,
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Check if response body is empty
        if (response.body.isEmpty) {
          return ApiResponse.error('Empty response from server');
        }

        final data = json.decode(response.body);

        // Check if response contains required fields
        if (data == null) {
          return ApiResponse.error('Invalid response format from server');
        }

        // Handle different response formats
        String? token;
        Map<String, dynamic>? userData;

        if (data is Map<String, dynamic>) {
          token = data['token'] ?? data['access_token'];
          // Backend returns data: { user: {...} }
          userData = data['data']?['user'] ?? data['user'] ?? data['data'];
        }

        if (token == null || userData == null) {
          return ApiResponse.error('Invalid login response format');
        }

        await _storeAuthToken(token);
        return ApiResponse.success(User.fromJson(userData));
      } else {
        // Handle error responses safely
        try {
          final errorData = json.decode(response.body);
          return ApiResponse.error(errorData['message'] ?? 'Login failed');
        } catch (e) {
          return ApiResponse.error(
            'Login failed with status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: _headers,
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        String? token = data['token'];
        Map<String, dynamic>? userData = data['data']?['user'];

        if (token == null || userData == null) {
          return ApiResponse.error('Invalid registration response format');
        }

        await _storeAuthToken(token);
        return ApiResponse.success(User.fromJson(userData));
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse.error(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<void>> logout() async {
    try {
      await http.post(Uri.parse(logoutEndpoint), headers: _headers);
      await _clearAuthToken();
      return ApiResponse.success(null);
    } catch (e) {
      await _clearAuthToken(); // Clear token even if request fails
      return ApiResponse.success(null);
    }
  }

  static Future<ApiResponse<User>> getMe() async {
    try {
      final response = await http.get(
        Uri.parse(getMeEndpoint),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Map<String, dynamic>? userData = data['data']?['user'];

        if (userData == null) {
          return ApiResponse.error('Invalid user data format');
        }

        return ApiResponse.success(User.fromJson(userData));
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse.error(
          errorData['message'] ?? 'Failed to get user data',
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // ==================== USER METHODS ====================

  static Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse(userProfileEndpoint),
        headers: _headers,
      );

      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (address != null) body['address'] = address;

      final response = await http.put(
        Uri.parse(updateProfileEndpoint),
        headers: _headers,
        body: json.encode(body),
      );

      return _handleResponse(response, (data) => User.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(changePasswordEndpoint),
        headers: _headers,
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(null);
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse.error(
          errorData['message'] ?? 'Password change failed',
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // ==================== ORDER METHODS ====================

  static Future<ApiResponse<List<Order>>> getOrders() async {
    try {
      final response = await http.get(
        Uri.parse(ordersEndpoint),
        headers: _headers,
      );

      return _handleListResponse(response, (data) => Order.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Order>> createOrder({
    required List<OrderItem> items,
    required String addressId,
    required String paymentMethodId,
    String? notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(createOrderEndpoint),
        headers: _headers,
        body: json.encode({
          'items': items.map((item) => item.toJson()).toList(),
          'address_id': addressId,
          'payment_method_id': paymentMethodId,
          'notes': notes,
        }),
      );

      return _handleResponse(response, (data) => Order.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Order>> getOrderStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$orderStatusEndpoint/$orderId'),
        headers: _headers,
      );

      return _handleResponse(response, (data) => Order.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // ==================== SERVICE METHODS ====================

  static Future<ApiResponse<List<LaundryService>>> getServices() async {
    try {
      final response = await http.get(
        Uri.parse(servicesEndpoint),
        headers: _headers,
      );

      return _handleListResponse(
        response,
        (data) => LaundryService.fromJson(data),
      );
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<LaundryService>> getServiceDetails(
    String serviceId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$serviceDetailsEndpoint/$serviceId'),
        headers: _headers,
      );

      return _handleResponse(response, (data) => LaundryService.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // ==================== SCHEDULE METHODS ====================
  
  static Future<ApiResponse<List<Schedule>>> getSchedules() async {
    try {
      final response = await http.get(
        Uri.parse(schedulesEndpoint),
        headers: _headers,
      );

      return _handleListResponse(response, (data) => Schedule.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Schedule>> createSchedule({
    required String serviceId,
    required DateTime scheduledDate,
    required String timeSlot,
    required String addressId,
    String? notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(createScheduleEndpoint),
        headers: _headers,
        body: json.encode({
          'serviceId': serviceId,
          'scheduledDate': scheduledDate.toIso8601String(),
          'timeSlot': timeSlot,
          'addressId': addressId,
          'notes': notes ?? '',
        }),
      );

      return _handleResponse(response, (data) => Schedule.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<void>> cancelSchedule(String scheduleId) async {
    try {
      final response = await http.delete(
        Uri.parse('$cancelScheduleEndpoint/$scheduleId'),
        headers: _headers,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(null);
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse.error(
          errorData['message'] ?? 'Failed to cancel schedule',
        );
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Schedule>> updateSchedule({
    required String scheduleId,
    DateTime? scheduledDate,
    String? timeSlot,
    String? addressId,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (scheduledDate != null) body['scheduledDate'] = scheduledDate.toIso8601String();
      if (timeSlot != null) body['timeSlot'] = timeSlot;
      if (addressId != null) body['addressId'] = addressId;
      if (notes != null) body['notes'] = notes;

      final response = await http.put(
        Uri.parse('$updateScheduleEndpoint/$scheduleId'),
        headers: _headers,
        body: json.encode(body),
      );

      return _handleResponse(response, (data) => Schedule.fromJson(data));
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}

// API Response wrapper class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse.success(this.data) : success = true, error = null;
  ApiResponse.error(this.error) : success = false, data = null;
}
