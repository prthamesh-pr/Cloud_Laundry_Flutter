import 'package:flutter/foundation.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServicesProvider with ChangeNotifier {
  List<LaundryService> _services = [];
  bool _isLoading = false;
  String? _error;
  bool _useApiData = true; // Set to true to use real API

  List<LaundryService> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useApiData => _useApiData;

  // Sample services data for development
  static final List<LaundryService> _sampleServices = [
    LaundryService(
      id: 'service1',
      name: 'Wash & Fold',
      description:
          'Professional washing and folding service for your everyday clothes',
      basePrice: 2.50,
      priceUnit: 'per_kg',
      category: 'Regular Laundry',
      imageUrl: '',
      isAvailable: true,
      estimatedDurationHours: 24,
      instructions: ['Separate colors', 'Use gentle detergent'],
    ),
    LaundryService(
      id: 'service2',
      name: 'Dry Cleaning',
      description: 'Expert dry cleaning for delicate and formal wear',
      basePrice: 8.99,
      priceUnit: 'per_item',
      category: 'Dry Cleaning',
      imageUrl: '',
      isAvailable: true,
      estimatedDurationHours: 48,
      instructions: ['Handle with care', 'Check for stains'],
    ),
    LaundryService(
      id: 'service3',
      name: 'Comforters',
      description: 'Special care for bulky comforters and bedding',
      basePrice: 25.00,
      priceUnit: 'per_item',
      category: 'Bedding',
      imageUrl: '',
      isAvailable: true,
      estimatedDurationHours: 72,
      instructions: ['Extra large capacity wash', 'Thorough drying'],
    ),
    LaundryService(
      id: 'service4',
      name: 'Ironing Service',
      description: 'Professional pressing and ironing service',
      basePrice: 3.99,
      priceUnit: 'per_item',
      category: 'Specialty',
      imageUrl: '',
      isAvailable: true,
      estimatedDurationHours: 24,
      instructions: ['Steam press', 'Hang immediately'],
    ),
  ];

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_useApiData) {
        // TODO: Use real API when ready
        final response = await ApiService.getServices();
        if (response.success) {
          _services = response.data!;
          _error = null;
        } else {
          _error = response.error;
        }
      } else {
        // Use sample data for development
        await Future.delayed(const Duration(milliseconds: 500));
        _services = List.from(_sampleServices);
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  LaundryService? getServiceById(String id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  List<LaundryService> getServicesByCategory(String category) {
    return _services.where((service) => service.category == category).toList();
  }

  List<String> get categories {
    return _services.map((service) => service.category).toSet().toList();
  }

  void clearServices() {
    _services = [];
    _error = null;
    notifyListeners();
  }
}
