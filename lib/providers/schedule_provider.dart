import 'package:flutter/foundation.dart';
import '../models/service.dart'; // This imports both LaundryService and Schedule
import '../services/api_service.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  bool _isLoading = false;
  String? _error;
  
  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchSchedules() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiService.getSchedules();
      if (response.success) {
        _schedules = response.data!;
        _error = null;
      } else {
        _error = response.error;
        // For now, provide empty list if API fails
        _schedules = [];
      }
    } catch (e) {
      _error = e.toString();
      // For now, provide empty list if API fails
      _schedules = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createSchedule({
    required String serviceId,
    required DateTime scheduledDate,
    required String timeSlot,
    required String addressId,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiService.createSchedule(
        serviceId: serviceId,
        scheduledDate: scheduledDate,
        timeSlot: timeSlot,
        addressId: addressId,
        notes: notes,
      );
      
      if (response.success) {
        _schedules.add(response.data!);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }
  
  Future<bool> cancelSchedule(String scheduleId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await ApiService.cancelSchedule(scheduleId);
      
      if (response.success) {
        _schedules.removeWhere((schedule) => schedule.id == scheduleId);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = response.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Schedule? getScheduleById(String id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<Schedule> getUpcomingSchedules() {
    final now = DateTime.now();
    return _schedules
        .where((schedule) => schedule.scheduledDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }
  
  List<Schedule> getPastSchedules() {
    final now = DateTime.now();
    return _schedules
        .where((schedule) => schedule.scheduledDate.isBefore(now))
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }
  
  void clearSchedules() {
    _schedules = [];
    _error = null;
    notifyListeners();
  }
}
