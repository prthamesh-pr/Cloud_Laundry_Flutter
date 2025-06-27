import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _useApiData = true; // Set to true to use real API

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get useApiData => _useApiData;

  // Sample user data for development
  static final User _sampleUser = User(
    id: 'sample_user_123',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1 (555) 123-4567',
    address: '123 Main Street, New York, NY 10001',
    profileImageUrl: null,
    isEmailVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  // Initialize provider - check for stored auth status
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (_useApiData) {
        // TODO: Use real API when ready
        await ApiService.initialize();

        if (ApiService.isAuthenticated) {
          final response = await ApiService.getUserProfile();
          if (response.success && response.data != null) {
            _user = response.data;
          } else {
            await ApiService.logout();
            await prefs.setBool('is_logged_in', false);
          }
        }
      } else {
        // Use sample data for development
        if (isLoggedIn) {
          _user = _sampleUser;
        }
      }
    } catch (e) {
      _error = 'Failed to initialize: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login method with sample data support
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_useApiData) {
        // TODO: Use real API when ready
        final response = await ApiService.login(email, password);

        if (response.success && response.data != null) {
          _user = response.data;
          _error = null;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          notifyListeners();
          return true;
        } else {
          _error = response.error ?? 'Login failed';
          notifyListeners();
          return false;
        }
      } else {
        // Use sample data for development
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Simple validation for demo (accept any email/password for demo)
        if (email.isNotEmpty && password.isNotEmpty) {
          _user = _sampleUser.copyWith(email: email);
          _error = null;

          // Store login state
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_email', email);

          notifyListeners();
          return true;
        } else {
          _error = 'Please enter both email and password';
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      _error = 'Login failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Register method with sample data support
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_useApiData) {
        // TODO: Use real API when ready
        final response = await ApiService.register(
          name: name,
          email: email,
          password: password,
          phone: phone,
          address: address,
        );

        if (response.success && response.data != null) {
          _user = response.data;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          notifyListeners();
          return true;
        } else {
          _error = response.error ?? 'Registration failed';
          notifyListeners();
          return false;
        }
      } else {
        // Use sample data for development
        await Future.delayed(const Duration(seconds: 1));

        if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
          _user = User(
            id: 'sample_user_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            email: email,
            phone: phone,
            address: address,
            profileImageUrl: null,
            isEmailVerified: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _error = null;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          await prefs.setString('user_email', email);

          notifyListeners();
          return true;
        } else {
          _error = 'Please fill in all required fields';
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      _error = 'Registration failed: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_useApiData) {
        await ApiService.logout();
      }

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.remove('user_email');

      _user = null;
      _error = null;
    } catch (e) {
      _error = 'Logout error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImageUrl,
  }) async {
    if (_user == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_useApiData) {
        // TODO: Use real API when ready
        final response = await ApiService.updateProfile(
          name: name ?? _user!.name,
          phone: phone ?? _user!.phone,
          address: address ?? _user!.address,
        );

        if (response.success && response.data != null) {
          _user = response.data;
          notifyListeners();
          return true;
        } else {
          _error = response.error ?? 'Failed to update profile';
          notifyListeners();
          return false;
        }
      } else {
        // Use sample data for development
        await Future.delayed(const Duration(milliseconds: 500));

        _user = _user!.copyWith(
          name: name ?? _user!.name,
          phone: phone ?? _user!.phone,
          address: address ?? _user!.address,
          profileImageUrl: profileImageUrl ?? _user!.profileImageUrl,
        );

        notifyListeners();
        return true;
      }
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Switch between API and sample data (for development)
  void toggleApiMode(bool useApi) {
    _useApiData = useApi;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  // Local login method for testing
  Future<void> loginLocal(String email) async {
    _user = _sampleUser.copyWith(email: email);

    // Store login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', email);

    notifyListeners();
  }
}
