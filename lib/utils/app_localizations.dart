import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // App General
  String get appName => _localizedString('app_name', 'Cloud Laundry');
  String get appTagline => _localizedString('app_tagline', 'Your Clothes, Our Care');
  
  // Navigation
  String get home => _localizedString('home', 'Home');
  String get schedule => _localizedString('schedule', 'Schedule');
  String get history => _localizedString('history', 'History');
  String get settings => _localizedString('settings', 'Settings');
  String get profile => _localizedString('profile', 'Profile');
  
  // Onboarding
  String get skip => _localizedString('skip', 'Skip');
  String get next => _localizedString('next', 'Next');
  String get getStarted => _localizedString('get_started', 'Get Started');
  String get previous => _localizedString('previous', 'Previous');
  
  // Auth
  String get login => _localizedString('login', 'Login');
  String get logout => _localizedString('logout', 'Logout');
  String get email => _localizedString('email', 'Email');
  String get password => _localizedString('password', 'Password');
  String get forgotPassword => _localizedString('forgot_password', 'Forgot Password?');
  String get signUp => _localizedString('sign_up', 'Sign Up');
  String get welcome => _localizedString('welcome', 'Welcome');
  String get welcomeBack => _localizedString('welcome_back', 'Welcome Back');
  
  // Orders
  String get trackOrder => _localizedString('track_order', 'Track Order');
  String get placeOrder => _localizedString('place_order', 'Place Order');
  String get orderHistory => _localizedString('order_history', 'Order History');
  String get orderDetails => _localizedString('order_details', 'Order Details');
  
  // Common Actions
  String get save => _localizedString('save', 'Save');
  String get cancel => _localizedString('cancel', 'Cancel');
  String get delete => _localizedString('delete', 'Delete');
  String get edit => _localizedString('edit', 'Edit');
  String get close => _localizedString('close', 'Close');
  String get confirm => _localizedString('confirm', 'Confirm');
  
  // Notifications
  String get notifications => _localizedString('notifications', 'Notifications');
  String get noNotifications => _localizedString('no_notifications', 'No notifications');
  
  // Services
  String get washAndFold => _localizedString('wash_and_fold', 'Wash & Fold');
  String get dryCleaning => _localizedString('dry_cleaning', 'Dry Cleaning');
  String get ironingService => _localizedString('ironing_service', 'Ironing Service');
  
  String _localizedString(String key, String defaultValue) {
    // This is a simplified version. In a real app, you'd load from JSON files
    // or use a more sophisticated localization system
    switch (locale.languageCode) {
      case 'es':
        return _getSpanishTranslation(key, defaultValue);
      case 'fr':
        return _getFrenchTranslation(key, defaultValue);
      case 'de':
        return _getGermanTranslation(key, defaultValue);
      case 'ar':
        return _getArabicTranslation(key, defaultValue);
      case 'zh':
        return _getChineseTranslation(key, defaultValue);
      default:
        return defaultValue; // English
    }
  }

  String _getSpanishTranslation(String key, String defaultValue) {
    const translations = {
      'app_name': 'Lavandería en la Nube',
      'app_tagline': 'Tu Ropa, Nuestro Cuidado',
      'home': 'Inicio',
      'schedule': 'Programar',
      'history': 'Historial',
      'settings': 'Configuración',
      'profile': 'Perfil',
      'login': 'Iniciar Sesión',
      'logout': 'Cerrar Sesión',
      'welcome_back': 'Bienvenido de Vuelta',
      'track_order': 'Rastrear Pedido',
      'place_order': 'Hacer Pedido',
      'notifications': 'Notificaciones',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'edit': 'Editar',
      'close': 'Cerrar',
    };
    return translations[key] ?? defaultValue;
  }

  String _getFrenchTranslation(String key, String defaultValue) {
    const translations = {
      'app_name': 'Blanchisserie Cloud',
      'app_tagline': 'Vos Vêtements, Notre Soin',
      'home': 'Accueil',
      'schedule': 'Planifier',
      'history': 'Historique',
      'settings': 'Paramètres',
      'profile': 'Profil',
      'login': 'Connexion',
      'logout': 'Déconnexion',
      'welcome_back': 'Bon Retour',
      'track_order': 'Suivre Commande',
      'place_order': 'Passer Commande',
      'notifications': 'Notifications',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'edit': 'Modifier',
      'close': 'Fermer',
    };
    return translations[key] ?? defaultValue;
  }

  String _getGermanTranslation(String key, String defaultValue) {
    const translations = {
      'app_name': 'Cloud Wäscherei',
      'app_tagline': 'Ihre Kleidung, Unsere Pflege',
      'home': 'Startseite',
      'schedule': 'Planen',
      'history': 'Verlauf',
      'settings': 'Einstellungen',
      'profile': 'Profil',
      'login': 'Anmelden',
      'logout': 'Abmelden',
      'welcome_back': 'Willkommen Zurück',
      'track_order': 'Bestellung Verfolgen',
      'place_order': 'Bestellung Aufgeben',
      'notifications': 'Benachrichtigungen',
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'edit': 'Bearbeiten',
      'close': 'Schließen',
    };
    return translations[key] ?? defaultValue;
  }

  String _getArabicTranslation(String key, String defaultValue) {
    const translations = {
      'app_name': 'مغسلة السحابة',
      'app_tagline': 'ملابسك، عنايتنا',
      'home': 'الرئيسية',
      'schedule': 'جدولة',
      'history': 'التاريخ',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'welcome_back': 'مرحباً بعودتك',
      'track_order': 'تتبع الطلب',
      'place_order': 'إجراء طلب',
      'notifications': 'الإشعارات',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'edit': 'تعديل',
      'close': 'إغلاق',
    };
    return translations[key] ?? defaultValue;
  }

  String _getChineseTranslation(String key, String defaultValue) {
    const translations = {
      'app_name': '云洗衣',
      'app_tagline': '您的衣服，我们的关怀',
      'home': '首页',
      'schedule': '预约',
      'history': '历史',
      'settings': '设置',
      'profile': '个人资料',
      'login': '登录',
      'logout': '登出',
      'welcome_back': '欢迎回来',
      'track_order': '追踪订单',
      'place_order': '下订单',
      'notifications': '通知',
      'save': '保存',
      'cancel': '取消',
      'edit': '编辑',
      'close': '关闭',
    };
    return translations[key] ?? defaultValue;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'de', 'ar', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
