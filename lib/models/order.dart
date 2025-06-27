enum OrderStatus {
  pending,
  confirmed,
  pickedUp,
  inProcess,
  readyForDelivery,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double totalAmount;
  final double taxAmount;
  final double discountAmount;
  final String pickupAddress;
  final String deliveryAddress;
  final DateTime scheduledPickupDate;
  final DateTime? actualPickupDate;
  final DateTime? estimatedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final String? specialInstructions;
  final PaymentMethod? paymentMethod;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.totalAmount,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.scheduledPickupDate,
    this.actualPickupDate,
    this.estimatedDeliveryDate,
    this.actualDeliveryDate,
    this.specialInstructions,
    this.paymentMethod,
    this.trackingNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
      ),
      totalAmount: json['total_amount'].toDouble(),
      taxAmount: json['tax_amount']?.toDouble() ?? 0.0,
      discountAmount: json['discount_amount']?.toDouble() ?? 0.0,
      pickupAddress: json['pickup_address'],
      deliveryAddress: json['delivery_address'],
      scheduledPickupDate: DateTime.parse(json['scheduled_pickup_date']),
      actualPickupDate: json['actual_pickup_date'] != null
          ? DateTime.parse(json['actual_pickup_date'])
          : null,
      estimatedDeliveryDate: json['estimated_delivery_date'] != null
          ? DateTime.parse(json['estimated_delivery_date'])
          : null,
      actualDeliveryDate: json['actual_delivery_date'] != null
          ? DateTime.parse(json['actual_delivery_date'])
          : null,
      specialInstructions: json['special_instructions'],
      paymentMethod: json['payment_method'] != null
          ? PaymentMethod.fromJson(json['payment_method'])
          : null,
      trackingNumber: json['tracking_number'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
      'total_amount': totalAmount,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'scheduled_pickup_date': scheduledPickupDate.toIso8601String(),
      'actual_pickup_date': actualPickupDate?.toIso8601String(),
      'estimated_delivery_date': estimatedDeliveryDate?.toIso8601String(),
      'actual_delivery_date': actualDeliveryDate?.toIso8601String(),
      'special_instructions': specialInstructions,
      'payment_method': paymentMethod?.toJson(),
      'tracking_number': trackingNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.inProcess:
        return 'In Process';
      case OrderStatus.readyForDelivery:
        return 'Ready for Delivery';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  double get finalAmount => totalAmount + taxAmount - discountAmount;
}

class OrderItem {
  final String id;
  final String serviceId;
  final String serviceName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  OrderItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'service_name': serviceName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'notes': notes,
    };
  }
}

class PaymentMethod {
  final String id;
  final String type; // 'credit_card', 'debit_card', 'paypal', etc.
  final String cardNumber; // Last 4 digits only
  final String cardHolder;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryMonth,
    required this.expiryYear,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: json['type'],
      cardNumber: json['card_number'],
      cardHolder: json['card_holder'],
      expiryMonth: json['expiry_month'],
      expiryYear: json['expiry_year'],
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'card_number': cardNumber,
      'card_holder': cardHolder,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'is_default': isDefault,
    };
  }

  String get displayName {
    final typeDisplay = type == 'credit_card' ? 'Credit Card' : 
                       type == 'debit_card' ? 'Debit Card' : 
                       type.toUpperCase();
    return '$typeDisplay **** $cardNumber';
  }
}
