import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/services_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/settings_provider.dart';
import 'services/api_service.dart';
import 'utils/app_localizations.dart';

// TODO: Cloud Laundry App - API Integration Guide
// ===============================================
// This app is now configured to use your deployed API.
//
// ✅ API Configuration Complete:
//    - Base URL: https://cloud-laundry.onrender.com
//    - All providers enabled for API data
//
// Next steps:
// 1. Test authentication with your API
// 2. Verify all endpoints are working correctly
// 3. Update any API endpoints if needed
//
// 5. Update services/api_service.dart:
//    - ✅ Changed baseUrl to your deployed API endpoint
//    - ✅ Authentication headers configured
//
// 6. ✅ All functionality now uses your API
// ===============================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.initialize();
  runApp(const CloudLaundryApp());
}

class CloudLaundryApp extends StatelessWidget {
  const CloudLaundryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..loadSettings(),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Cloud Laundry App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Inter',
              brightness: settingsProvider.settings.darkMode
                  ? Brightness.dark
                  : Brightness.light,
              appBarTheme: AppBarTheme(
                backgroundColor: settingsProvider.settings.darkMode
                    ? const Color(0xFF1F2937)
                    : const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2563EB),
                brightness: settingsProvider.settings.darkMode
                    ? Brightness.dark
                    : Brightness.light,
              ),
            ),
            // Localization support
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('es', ''), // Spanish
              Locale('fr', ''), // French
              Locale('de', ''), // German
              Locale('ar', ''), // Arabic
              Locale('zh', ''), // Chinese
            ],
            locale: Locale(settingsProvider.settings.language),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
