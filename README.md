# SAM AT+ 🏗️

<div align="center">

<img src="images/tower.png" alt="SAM AT+ Logo" width="120"/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Google Apps Script](https://img.shields.io/badge/Google_Apps_Script-4285F4?style=for-the-badge&logo=google&logoColor=white)

**Material Administration System for Technical Assistance**

Comprehensive system for control and tracking of material records in technical assistance operations.

[Features](#-features) • [Installation](#-installation) • [Configuration](#-configuration) • [Usage](#-usage) • [Architecture](#-architecture)

</div>

---

## 📋 Description

**SAM AT+** is a multi-platform application developed in Flutter for material management and control in technical assistance operations. It enables inventory tracking, form management, operational debt control, and much more.

## ✨ Features

### Material Management
- 📦 **Inventory** - Complete stock control
- 📝 **Forms** - Document and record management
- 🔄 **Remissions** - Delivery and movement tracking
- 📊 **MB51/MB52** - Material movement reports

### Operational Control
- 💰 **Operational Debt** - Pending items tracking by operator
- 🏪 **Warehouse Debt** - Warehouse shortage control
- 📈 **Gross Debt** - Consolidated debt reports

### Additional Features
- 🔐 **Authentication** - Login system with Firebase Auth
- 🎨 **Customizable themes** - Dark mode and custom colors
- 📱 **Multi-platform** - Support for Web, Android, iOS, and Desktop
- 🔍 **LCL** - Location queries
- 🎫 **Security tokens** - Authorization system for sensitive operations

## 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| **Flutter** | Multi-platform development framework |
| **Dart** | Programming language |
| **Firebase** | Authentication, Firestore, Hosting |
| **Supabase** | PostgreSQL database |
| **Google Apps Script** | Spreadsheet integration APIs |
| **BLoC** | State management |

## 📂 Project Architecture

```
lib/
├── bloc/                    # State management (BLoC pattern)
│   ├── main_bloc.dart
│   ├── main_event.dart
│   └── main_state.dart
├── Home/                    # Main screen
├── Log/                     # Authentication
│   ├── login_page.dart
│   ├── auth_services.dart
│   └── register_screen.dart
├── resources/               # Configurations and utilities
│   ├── env_config.dart      # Environment variables
│   └── constants/
│       └── apis.dart
├── planilla/               # Forms module
├── inventario/             # Inventory module
├── remisiones/             # Remissions module
├── deuda_operativa/        # Operational debt module
├── deuda_almacen/          # Warehouse debt module
├── lcl/                    # LCL module
└── main.dart               # Entry point
```

## 🚀 Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.7.2)
- [Dart SDK](https://dart.dev/get-dart) (>=3.7.2)
- Firebase account
- Supabase account (optional, for LCL module)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/jozzer182/SAM_AT.git
   cd SAM_AT
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables** (see [Configuration](#-configuration) section)

4. **Run the application**
   ```bash
   # Web
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   ```

## ⚙️ Configuration

### Environment Variables

1. **Copy the example file**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` with your credentials**
   ```env
   # Firebase Configuration
   FIREBASE_API_KEY=your_api_key
   FIREBASE_APP_ID=your_app_id
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id
   FIREBASE_PROJECT_ID=your_project_id
   FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
   FIREBASE_STORAGE_BUCKET=your_project.appspot.com
   
   # Google Apps Script APIs
   API_ENVIAR_SOLPE=https://script.google.com/macros/s/YOUR_ID/exec
   API_FEM=https://script.google.com/macros/s/YOUR_ID/exec
   API_SAM=https://script.google.com/macros/s/YOUR_ID/exec
   API_SAMAT=https://script.google.com/macros/s/YOUR_ID/exec
   
   # Supabase Configuration
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_anon_key
   ```

### Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Authentication with Email/Password
4. Copy your web app credentials to `.env`

### Supabase Configuration (Optional)

1. Go to [Supabase Dashboard](https://app.supabase.com/)
2. Create a new project
3. Copy the URL and Anon Key to `.env`

For more details, see [docs/SETUP.md](docs/SETUP.md).

## 📱 Supported Platforms

| Platform | Status |
|----------|--------|
| Web | ✅ Complete |
| Android | ⚠️ In development |
| iOS | ⚠️ In development |
| macOS | ⚠️ In development |
| Windows | ⚠️ In development |
| Linux | ⚠️ In development |

## 🔧 Useful Commands

```bash
# Run in debug mode
flutter run

# Build for web
flutter build web

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## 🤝 Contributing

Contributions are welcome. Please:

1. Fork the project
2. Create a branch for your feature (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is private and for internal use.

## 📬 Contact

**José Zarabanda**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/zarabandajose/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/jozzer182)
[![Website](https://img.shields.io/badge/Website-FF7139?style=for-the-badge&logo=firefox&logoColor=white)](https://zarabanda-dev.web.app/)

---

<div align="center">

Made with ❤️ using Flutter

</div>
