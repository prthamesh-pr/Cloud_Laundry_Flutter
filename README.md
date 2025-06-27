# Cloud Laundry App

A modern, scalable Flutter laundry service application with comprehensive state management, authentication, and API integration capabilities.

## 🚀 Features

### Core Features
- ✅ **User Authentication** - Login/Logout with persistent sessions
- ✅ **Splash Screen** - Animated app introduction  
- ✅ **Onboarding Flow** - User-friendly app introduction
- ✅ **Dashboard/Home** - Service overview and recent activity
- ✅ **Service Management** - Browse available laundry services
- ✅ **Order Management** - Create, track, and manage orders
- ✅ **Schedule Management** - Pickup and delivery scheduling
- ✅ **Order History** - Complete order tracking
- ✅ **User Profile** - Profile management and settings
- ✅ **Settings** - App preferences and configurations
- ✅ **Notifications** - In-app notification system
- ✅ **Dark Mode Support** - Theme switching capability

### Technical Features
- ✅ **State Management** - Provider pattern implementation
- ✅ **Local Storage** - SharedPreferences for data persistence
- ✅ **Sample Data Mode** - Development-friendly mock data
- ✅ **API Ready** - Complete HTTP service layer
- ✅ **Responsive Design** - Adaptive UI for different screen sizes
- ✅ **Error Handling** - Comprehensive error management
- ✅ **Performance Optimized** - Efficient widget rebuilding

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd coud_laundry
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Production API Setup (Current Configuration)
The app is now configured to use your deployed API at `https://cloud-laundry.onrender.com`.

**API Configuration:**
- Base URL: `https://cloud-laundry.onrender.com`
- All providers enabled for real API data
- Authentication configured with Bearer tokens

### Development Mode
To switch back to sample data for testing:

1. **Update API Configuration**
   ```dart
   // In lib/services/api_service.dart
   static const String baseUrl = 'https://localhost:3000'; // or your dev server
   ```

2. **Disable API Mode in Providers**
   ```dart
   // In each provider file, change:
   bool _useApiData = false; // Set to false for sample data
   ```

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1              # State management
  http: ^1.1.0                  # HTTP client
  shared_preferences: ^2.2.2     # Local storage
  json_annotation: ^4.8.1       # JSON serialization
  image_picker: ^1.0.4          # Image selection
  cupertino_icons: ^1.0.8       # iOS icons
```

## 🎨 Design System

### Color Palette
- **Primary**: `#3B82F6` (Blue)
- **Secondary**: `#10B981` (Green)
- **Accent**: `#8B5CF6` (Purple)
- **Warning**: `#F59E0B` (Orange)
- **Error**: `#EF4444` (Red)

## 🔄 State Management

The app uses Provider pattern for state management:

```dart
// Accessing state
final authProvider = Provider.of<AuthProvider>(context);

// Listening to changes
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    return Text(authProvider.user?.name ?? 'Guest');
  },
)
```

## 🌐 API Integration

### Authentication Flow
```dart
// Login
final success = await authProvider.login(email, password);

// Check authentication
if (authProvider.isAuthenticated) {
  // User is logged in
}

// Logout
await authProvider.logout();
```

Built with ❤️ using Flutter
