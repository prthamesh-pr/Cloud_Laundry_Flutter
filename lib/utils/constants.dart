import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Cloud Laundry';
  static const String appVersion = '1.0.0';
  static const String tagline = 'Your Clothes, Our Care';
  
  // Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color secondaryBlue = Color(0xFF60A5FA);
  static const Color lightBlue = Color(0xFFDBEAFE);
  
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color primaryOrange = Color(0xFFF59E0B);
  static const Color primaryRed = Color(0xFFEF4444);
  
  static const Color gray900 = Color(0xFF1F2937);
  static const Color gray800 = Color(0xFF374151);
  static const Color gray700 = Color(0xFF4B5563);
  static const Color gray600 = Color(0xFF6B7280);
  static const Color gray500 = Color(0xFF9CA3AF);
  static const Color gray400 = Color(0xFFD1D5DB);
  static const Color gray300 = Color(0xFFE5E7EB);
  static const Color gray200 = Color(0xFFEFEFEF);
  static const Color gray100 = Color(0xFFF9FAFB);
  
  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: gray900,
    height: 1.2,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: gray900,
    height: 1.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: gray900,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: gray700,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: gray600,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: gray500,
    height: 1.4,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusCircle = 999.0;
  
  // Shadows
  static const List<BoxShadow> shadowS = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> shadowM = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> shadowL = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 15,
      offset: Offset(0, 8),
    ),
  ];
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // API Configuration
  static const String apiBaseUrl = 'https://api.cloudlaundry.com/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int maxNameLength = 100;
  static const int maxAddressLength = 500;
  static const int maxNotesLength = 1000;
  
  // Feature Flags
  static const bool enableNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  
  // Service Categories
  static const List<String> serviceCategories = [
    'Wash & Fold',
    'Dry Cleaning',
    'Comforters',
    'Specialty Items',
  ];
  
  // Time Slots
  static const List<String> timeSlots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 2:00 PM',
    '2:00 PM - 4:00 PM',
    '4:00 PM - 6:00 PM',
    '6:00 PM - 8:00 PM',
  ];
  
  // Order Status Colors
  static const Map<String, Color> orderStatusColors = {
    'pending': primaryOrange,
    'confirmed': primaryBlue,
    'picked_up': primaryPurple,
    'in_process': primaryOrange,
    'ready_for_delivery': primaryGreen,
    'out_for_delivery': primaryBlue,
    'delivered': primaryGreen,
    'cancelled': primaryRed,
  };
  
  // Contact Information
  static const String supportEmail = 'support@cloudlaundry.com';
  static const String supportPhone = '+1 (555) 123-WASH';
  static const String companyAddress = '123 Clean Street, Laundry City, LC 12345';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/cloudlaundry';
  static const String twitterUrl = 'https://twitter.com/cloudlaundry';
  static const String instagramUrl = 'https://instagram.com/cloudlaundry';
  
  // App Store URLs
  static const String iosAppStoreUrl = 'https://apps.apple.com/app/cloudlaundry';
  static const String androidPlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.cloudlaundry.app';
  
  // Legal URLs
  static const String privacyPolicyUrl = 'https://cloudlaundry.com/privacy';
  static const String termsOfServiceUrl = 'https://cloudlaundry.com/terms';
  static const String cookiePolicyUrl = 'https://cloudlaundry.com/cookies';
}
