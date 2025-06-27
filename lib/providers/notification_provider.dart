import 'package:flutter/foundation.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;
  final Map<String, dynamic>? data;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.data,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      type: json['type'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'type': type,
      'data': data,
    };
  }

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    Map<String, dynamic>? data,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }
}

class NotificationProvider with ChangeNotifier {
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _error;
  
  List<NotificationItem> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<NotificationItem> get unreadNotifications => 
      _notifications.where((notification) => !notification.isRead).toList();
  
  int get unreadCount => unreadNotifications.length;
  
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demonstration
      _notifications = [
        NotificationItem(
          id: '1',
          title: 'Order Confirmed',
          message: 'Your laundry order #12345 has been confirmed and will be picked up today.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          type: 'order_update',
        ),
        NotificationItem(
          id: '2',
          title: 'Pickup Scheduled',
          message: 'Your laundry will be picked up tomorrow between 9 AM - 11 AM.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          type: 'schedule_update',
          isRead: true,
        ),
        NotificationItem(
          id: '3',
          title: 'Order Delivered',
          message: 'Your laundry order #12344 has been delivered successfully.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: 'order_update',
          isRead: true,
        ),
        NotificationItem(
          id: '4',
          title: 'Special Offer',
          message: 'Get 20% off on your next order! Use code SAVE20.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: 'promotion',
        ),
      ];
      
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> markAsRead(String notificationId) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
        
        // TODO: Make API call to mark as read
        // await ApiService.markNotificationAsRead(notificationId);
        
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> markAllAsRead() async {
    try {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
      notifyListeners();
      
      // TODO: Make API call to mark all as read
      // await ApiService.markAllNotificationsAsRead();
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
      
      // TODO: Make API call to delete notification
      // await ApiService.deleteNotification(notificationId);
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  void clearNotifications() {
    _notifications = [];
    _error = null;
    notifyListeners();
  }
  
  List<NotificationItem> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }
}
