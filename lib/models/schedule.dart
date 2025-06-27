enum ScheduleStatus { pending, confirmed, completed, cancelled }

class Schedule {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime scheduledDate;
  final String timeSlot;
  final String addressId;
  final String? notes;
  final ScheduleStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Schedule({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledDate,
    required this.timeSlot,
    required this.addressId,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      serviceId:
          json['serviceId']?.toString() ?? json['service_id']?.toString() ?? '',
      serviceName:
          json['serviceName']?.toString() ??
          json['service_name']?.toString() ??
          '',
      scheduledDate: DateTime.parse(
        json['scheduledDate'] ??
            json['scheduled_date'] ??
            DateTime.now().toIso8601String(),
      ),
      timeSlot:
          json['timeSlot']?.toString() ?? json['time_slot']?.toString() ?? '',
      addressId:
          json['addressId']?.toString() ?? json['address_id']?.toString() ?? '',
      notes: json['notes']?.toString(),
      status: _parseStatus(json['status']?.toString() ?? 'pending'),
      createdAt: DateTime.parse(
        json['createdAt'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ??
            json['updated_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  static ScheduleStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return ScheduleStatus.confirmed;
      case 'completed':
        return ScheduleStatus.completed;
      case 'cancelled':
        return ScheduleStatus.cancelled;
      default:
        return ScheduleStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'service_name': serviceName,
      'scheduled_date': scheduledDate.toIso8601String(),
      'time_slot': timeSlot,
      'address_id': addressId,
      'notes': notes,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusDisplay {
    switch (status) {
      case ScheduleStatus.pending:
        return 'Pending';
      case ScheduleStatus.confirmed:
        return 'Confirmed';
      case ScheduleStatus.completed:
        return 'Completed';
      case ScheduleStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isUpcoming {
    return scheduledDate.isAfter(DateTime.now()) &&
        (status == ScheduleStatus.pending ||
            status == ScheduleStatus.confirmed);
  }

  bool get canCancel {
    return status == ScheduleStatus.pending ||
        status == ScheduleStatus.confirmed;
  }

  Schedule copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? serviceName,
    DateTime? scheduledDate,
    String? timeSlot,
    String? addressId,
    String? notes,
    ScheduleStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Schedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      timeSlot: timeSlot ?? this.timeSlot,
      addressId: addressId ?? this.addressId,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
