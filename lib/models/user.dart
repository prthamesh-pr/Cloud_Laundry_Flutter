class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isPremiumMember;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified = false,
    this.isPremiumMember = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        address: _parseAddress(json['address']),
        profileImageUrl:
            json['profileImageUrl']?.toString() ??
            json['profile_image_url']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : (json['created_at'] != null
                  ? DateTime.parse(json['created_at'])
                  : DateTime.now()),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : (json['updated_at'] != null
                  ? DateTime.parse(json['updated_at'])
                  : DateTime.now()),
        isEmailVerified:
            json['isVerified'] ?? json['is_email_verified'] ?? false,
        isPremiumMember:
            json['isPremiumMember'] ?? json['is_premium_member'] ?? false,
      );
    } catch (e) {
      throw Exception('Failed to parse User from JSON: ${e.toString()}');
    }
  }

  static String _parseAddress(dynamic address) {
    if (address == null) return '';
    if (address is String) return address;
    if (address is Map<String, dynamic>) {
      final street = address['street'] ?? '';
      final city = address['city'] ?? '';
      final state = address['state'] ?? '';
      final zipCode = address['zipCode'] ?? '';
      return '$street, $city, $state $zipCode'
          .replaceAll(RegExp(r',\s*,'), ',')
          .trim();
    }
    return address.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_premium_member': isPremiumMember,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPremiumMember,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPremiumMember: isPremiumMember ?? this.isPremiumMember,
    );
  }
}
