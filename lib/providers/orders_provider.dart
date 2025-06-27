import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _error;
  bool _useApiData = true; // Set to true to use real API

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useApiData => _useApiData;

  // Sample orders data for development
  static final List<Order> _sampleOrders = [
    Order(
      id: 'ORD001',
      userId: 'sample_user_123',
      items: [
        OrderItem(
          id: 'item1',
          serviceId: 'service1',
          serviceName: 'Wash & Fold',
          quantity: 3,
          unitPrice: 2.50,
          totalPrice: 7.50,
        ),
      ],
      totalAmount: 7.50,
      status: OrderStatus.delivered,
      pickupAddress: '123 Main Street, New York, NY 10001',
      deliveryAddress: '123 Main Street, New York, NY 10001',
      scheduledPickupDate: DateTime.now().subtract(const Duration(days: 2)),
      actualPickupDate: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      actualDeliveryDate: DateTime.now().subtract(const Duration(days: 1)),
      specialInstructions: 'Please ring doorbell',
      trackingNumber: 'TRK123456',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: 'ORD002',
      userId: 'sample_user_123',
      items: [
        OrderItem(
          id: 'item2',
          serviceId: 'service2',
          serviceName: 'Dry Cleaning',
          quantity: 2,
          unitPrice: 8.99,
          totalPrice: 17.98,
        ),
      ],
      totalAmount: 17.98,
      status: OrderStatus.inProcess,
      pickupAddress: '123 Main Street, New York, NY 10001',
      deliveryAddress: '123 Main Street, New York, NY 10001',
      scheduledPickupDate: DateTime.now().subtract(const Duration(hours: 6)),
      actualPickupDate: DateTime.now().subtract(const Duration(hours: 5)),
      estimatedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
      specialInstructions: 'Call before delivery',
      trackingNumber: 'TRK789012',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  // Get all orders
  Future<void> fetchOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_useApiData) {
        // TODO: Use real API when ready
        final response = await ApiService.getOrders();

        if (response.success && response.data != null) {
          _orders = response.data!;
        } else {
          _error = response.error ?? 'Failed to fetch orders';
        }
      } else {
        // Use sample data for development
        await Future.delayed(const Duration(milliseconds: 800));
        _orders = List.from(_sampleOrders);
      }
    } catch (e) {
      _error = 'Error fetching orders: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create new order
  Future<bool> createOrder({
    required List<OrderItem> items,
    required String addressId,
    required String paymentMethodId,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.createOrder(
        items: items,
        addressId: addressId,
        paymentMethodId: paymentMethodId,
        notes: notes,
      );

      if (response.success && response.data != null) {
        _orders.insert(0, response.data!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.error ?? 'Failed to create order';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error creating order: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Update order status (called when receiving real-time updates)
  Future<void> updateOrderStatus(String orderId) async {
    try {
      final response = await ApiService.getOrderStatus(orderId);

      if (response.success && response.data != null) {
        final updatedOrder = response.data!;
        final index = _orders.indexWhere((order) => order.id == orderId);

        if (index != -1) {
          _orders[index] = updatedOrder;
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Error updating order status: ${e.toString()}';
      notifyListeners();
    }
  }

  // Filter orders by status
  List<Order> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // Get recent orders (last 10)
  List<Order> get recentOrders {
    final sorted = List<Order>.from(_orders);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }

  // Get orders for specific date range
  List<Order> getOrdersInDateRange(DateTime start, DateTime end) {
    return _orders.where((order) {
      return order.createdAt.isAfter(start) && order.createdAt.isBefore(end);
    }).toList();
  }

  // Calculate total spent
  double get totalSpent {
    return _orders.fold(0.0, (sum, order) => sum + order.finalAmount);
  }

  // Calculate total orders this month
  int get ordersThisMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return getOrdersInDateRange(startOfMonth, endOfMonth).length;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear all orders (for logout)
  void clear() {
    _orders.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
