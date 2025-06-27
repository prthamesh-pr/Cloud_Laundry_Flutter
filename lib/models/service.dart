class LaundryService {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final String priceUnit; // 'per_item', 'per_kg', 'flat_rate'
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final int estimatedDurationHours;
  final List<String> instructions;

  LaundryService({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.priceUnit,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.estimatedDurationHours = 24,
    this.instructions = const [],
  });

  factory LaundryService.fromJson(Map<String, dynamic> json) {
    return LaundryService(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['price'] ?? json['base_price'] ?? 0).toDouble(),
      priceUnit: json['price_unit'] ?? 'per_item',
      category: json['category'] ?? 'wash',
      imageUrl: json['image'] ?? json['image_url'] ?? '',
      isAvailable: json['isActive'] ?? json['is_available'] ?? true,
      estimatedDurationHours:
          json['duration'] ?? json['estimated_duration_hours'] ?? 24,
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'price_unit': priceUnit,
      'category': category,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'estimated_duration_hours': estimatedDurationHours,
      'instructions': instructions,
    };
  }

  String get priceDisplay {
    switch (priceUnit) {
      case 'per_item':
        return '\$${basePrice.toStringAsFixed(2)} per item';
      case 'per_kg':
        return '\$${basePrice.toStringAsFixed(2)} per kg';
      case 'flat_rate':
        return '\$${basePrice.toStringAsFixed(2)}';
      default:
        return '\$${basePrice.toStringAsFixed(2)}';
    }
  }
}

class Schedule {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime scheduledDate;
  final String timeSlot;
  final String pickupAddress;
  final String deliveryAddress;
  final String status; // 'scheduled', 'confirmed', 'completed', 'cancelled'
  final String? specialInstructions;
  final bool needsPickup;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? addressId; // Added to support backend addressId reference

  Schedule({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledDate,
    required this.timeSlot,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.status,
    this.specialInstructions,
    this.needsPickup = true,
    required this.createdAt,
    required this.updatedAt,
    this.addressId,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? json['service_id']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? json['service_name']?.toString() ?? 'Unknown Service',
      scheduledDate: DateTime.parse(json['scheduledDate'] ?? json['scheduled_date'] ?? DateTime.now().toIso8601String()),
      timeSlot: json['timeSlot']?.toString() ?? json['time_slot']?.toString() ?? '',
      pickupAddress: json['pickupAddress']?.toString() ?? json['pickup_address']?.toString() ?? 'Address not specified',
      deliveryAddress: json['deliveryAddress']?.toString() ?? json['delivery_address']?.toString() ?? 'Address not specified',
      status: json['status']?.toString() ?? 'scheduled',
      specialInstructions: json['specialInstructions'] ?? json['special_instructions'] ?? json['notes'],
      needsPickup: json['needsPickup'] ?? json['needs_pickup'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? json['updated_at'] ?? DateTime.now().toIso8601String()),
      addressId: json['addressId']?.toString() ?? json['address_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'service_name': serviceName,
      'scheduled_date': scheduledDate.toIso8601String(),
      'time_slot': timeSlot,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'status': status,
      'special_instructions': specialInstructions,
      'needs_pickup': needsPickup,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplayName {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

class Address {
  final String id;
  final String userId;
  final String label; // 'Home', 'Office', 'Other'
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.label,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      userId: json['user_id'],
      label: json['label'],
      streetAddress: json['street_address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      country: json['country'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'label': label,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullAddress {
    return '$streetAddress, $city, $state $zipCode';
  }

  String get displayName {
    return '$label - $fullAddress';
  }
}
