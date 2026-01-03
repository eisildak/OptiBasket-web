# OptiBasket Development Guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- VS Code or Android Studio
- iOS/Android Emulator or Physical Device

### Installation Steps

1. **Install Dependencies**
   ```bash
   cd OptiBasket
   flutter pub get
   ```

2. **Generate Code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App**
   
   For Web:
   ```bash
   flutter run -d chrome
   ```
   
   For Android:
   ```bash
   flutter run -d android
   ```
   
   For iOS:
   ```bash
   flutter run -d ios
   ```

## 📁 Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── constants/         # App constants and endpoints
│   ├── network/           # Network configuration (Dio)
│   ├── router/            # Navigation (GoRouter)
│   └── theme/             # App theme and colors
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   │   └── presentation/
│   │       └── screens/
│   ├── products/          # Product management
│   ├── cart/              # Shopping cart
│   ├── comparison/        # Price comparison
│   └── admin/             # Admin dashboard
└── shared/                # Shared components
    ├── models/            # Data models
    ├── services/          # API services
    └── presentation/      # Shared UI components
```

## 🔧 Key Technologies

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: Hive + Shared Preferences
- **Code Generation**: Freezed + JSON Serializable
- **Charts**: FL Chart

## 📝 Development Workflow

### Adding a New Feature

1. Create feature folder in `lib/features/`
2. Add presentation layer (screens, widgets)
3. Add data layer (models, services)
4. Add business logic (providers, controllers)

### Code Generation

When you modify models or API services:

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-rebuild)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Adding Translations

1. Add new keys to all translation files in `assets/translations/`
2. Languages supported: de.json, en.json, nl.json, tr.json

## 🔐 Environment Configuration

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://api.optibasket.com/v1
API_TIMEOUT=30000
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🐛 Common Issues

### Code Generation Errors
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Platform-Specific Issues
- **iOS**: Ensure you have Xcode installed and configured
- **Android**: Ensure you have Android SDK installed
- **Web**: Use Chrome for development

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Run tests
4. Submit a pull request

## 📄 License

Copyright © 2026 OptiBasket. All rights reserved.
