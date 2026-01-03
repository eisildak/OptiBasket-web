# OptiBasket 🛒

OptiBasket - Intelligent Price Comparison Platform for B2B Customers

## 📱 Overview

OptiBasket is a comprehensive B2B price comparison application that helps customers compare their current supplier prices with your catalog prices. The app supports historical price tracking (up to 4 weeks) and provides detailed savings analysis.

## ✨ Features

- 🔐 **Secure Authentication** - User registration with admin approval workflow
- 🛒 **Smart Cart Management** - Create and manage shopping carts with price comparison
- 📊 **Price History Tracking** - Compare prices for up to 4 weeks back
- 📈 **Savings Analytics** - Detailed savings calculations and visualizations
- 🌍 **Multi-language Support** - German, Dutch, English, Turkish
- 👨‍💼 **Admin Dashboard** - Customer approval and product management
- 📱 **Cross-Platform** - Web, iOS, Android support

## 🏗️ Architecture

The project follows Clean Architecture principles with feature-based organization:

```
lib/
├── core/              # Core functionality
│   ├── config/        # App configuration
│   ├── constants/     # Constants and enums
│   ├── router/        # Navigation setup
│   ├── theme/         # App theming
│   └── utils/         # Utilities
├── features/          # Feature modules
│   ├── auth/          # Authentication
│   ├── products/      # Product management
│   ├── cart/          # Shopping cart
│   ├── comparison/    # Price comparison
│   └── admin/         # Admin dashboard
└── shared/            # Shared components
    ├── models/        # Data models
    ├── widgets/       # Reusable widgets
    └── services/      # Shared services
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.2.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code (recommended)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/optibasket.git
cd optibasket
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **API Client**: Dio + Retrofit
- **Local Storage**: Hive + Shared Preferences
- **Code Generation**: Freezed + JSON Serializable
- **Charts**: FL Chart
- **Localization**: Flutter Intl

## 📋 Development

### Code Generation

Run this command whenever you modify models or API services:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Adding Translations

Add new translations in `assets/translations/` directory for each supported language.

## 🌐 Supported Languages

- 🇩🇪 German (Deutsch)
- 🇳🇱 Dutch (Nederlands)
- 🇬🇧 English
- 🇹🇷 Turkish (Türkçe)

## 📝 License

Copyright © 2026 OptiBasket. All rights reserved.

## 🤝 Contributing

This is a private project. For questions or support, please contact the development team.

---

Made with ❤️ using Flutter
