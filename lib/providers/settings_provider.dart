import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final String language;
  final String currency;
  final bool darkMode;
  final bool autoPickup;
  final String defaultAddress;
  final String defaultPaymentMethod;

  AppSettings({
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.pushNotifications = true,
    this.language = 'en',
    this.currency = 'USD',
    this.darkMode = false,
    this.autoPickup = false,
    this.defaultAddress = '',
    this.defaultPaymentMethod = '',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      notificationsEnabled: json['notifications_enabled'] ?? true,
      emailNotifications: json['email_notifications'] ?? true,
      smsNotifications: json['sms_notifications'] ?? true,
      pushNotifications: json['push_notifications'] ?? true,
      language: json['language'] ?? 'en',
      currency: json['currency'] ?? 'USD',
      darkMode: json['dark_mode'] ?? false,
      autoPickup: json['auto_pickup'] ?? false,
      defaultAddress: json['default_address'] ?? '',
      defaultPaymentMethod: json['default_payment_method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'sms_notifications': smsNotifications,
      'push_notifications': pushNotifications,
      'language': language,
      'currency': currency,
      'dark_mode': darkMode,
      'auto_pickup': autoPickup,
      'default_address': defaultAddress,
      'default_payment_method': defaultPaymentMethod,
    };
  }

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
    String? language,
    String? currency,
    bool? darkMode,
    bool? autoPickup,
    String? defaultAddress,
    String? defaultPaymentMethod,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      darkMode: darkMode ?? this.darkMode,
      autoPickup: autoPickup ?? this.autoPickup,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
    );
  }
}

class SettingsProvider with ChangeNotifier {
  AppSettings _settings = AppSettings();
  bool _isLoading = false;
  String? _error;
  
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _settings = AppSettings(
        notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
        emailNotifications: prefs.getBool('email_notifications') ?? true,
        smsNotifications: prefs.getBool('sms_notifications') ?? true,
        pushNotifications: prefs.getBool('push_notifications') ?? true,
        language: prefs.getString('language') ?? 'en',
        currency: prefs.getString('currency') ?? 'USD',
        darkMode: prefs.getBool('dark_mode') ?? false,
        autoPickup: prefs.getBool('auto_pickup') ?? false,
        defaultAddress: prefs.getString('default_address') ?? '',
        defaultPaymentMethod: prefs.getString('default_payment_method') ?? '',
      );
      
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> updateSettings(AppSettings newSettings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save to local storage
      await prefs.setBool('notifications_enabled', newSettings.notificationsEnabled);
      await prefs.setBool('email_notifications', newSettings.emailNotifications);
      await prefs.setBool('sms_notifications', newSettings.smsNotifications);
      await prefs.setBool('push_notifications', newSettings.pushNotifications);
      await prefs.setString('language', newSettings.language);
      await prefs.setString('currency', newSettings.currency);
      await prefs.setBool('dark_mode', newSettings.darkMode);
      await prefs.setBool('auto_pickup', newSettings.autoPickup);
      await prefs.setString('default_address', newSettings.defaultAddress);
      await prefs.setString('default_payment_method', newSettings.defaultPaymentMethod);
      
      _settings = newSettings;
      _error = null;
      
      // TODO: Sync with server
      // await ApiService.updateSettings(newSettings);
      
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> toggleNotifications(bool enabled) async {
    final newSettings = _settings.copyWith(notificationsEnabled: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> toggleEmailNotifications(bool enabled) async {
    final newSettings = _settings.copyWith(emailNotifications: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> toggleSmsNotifications(bool enabled) async {
    final newSettings = _settings.copyWith(smsNotifications: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> togglePushNotifications(bool enabled) async {
    final newSettings = _settings.copyWith(pushNotifications: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> toggleDarkMode(bool enabled) async {
    final newSettings = _settings.copyWith(darkMode: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> toggleAutoPickup(bool enabled) async {
    final newSettings = _settings.copyWith(autoPickup: enabled);
    await updateSettings(newSettings);
  }
  
  Future<void> updateLanguage(String language) async {
    final newSettings = _settings.copyWith(language: language);
    await updateSettings(newSettings);
  }
  
  Future<void> updateCurrency(String currency) async {
    final newSettings = _settings.copyWith(currency: currency);
    await updateSettings(newSettings);
  }
  
  Future<void> updateDefaultAddress(String addressId) async {
    final newSettings = _settings.copyWith(defaultAddress: addressId);
    await updateSettings(newSettings);
  }
  
  Future<void> updateDefaultPaymentMethod(String paymentMethodId) async {
    final newSettings = _settings.copyWith(defaultPaymentMethod: paymentMethodId);
    await updateSettings(newSettings);
  }
  
  Future<void> resetSettings() async {
    await updateSettings(AppSettings());
  }
}
