# Alowonle Poultry Manager 🐔

A comprehensive Flutter application for managing poultry farm operations, tracking production, inventory, and generating reports.

![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 📱 Features

### ✅ Production Management
- Daily egg production tracking
- Production trend visualization with interactive charts
- 7-day production history

### ✅ Inventory Management
- Track feed, medicine, and other supplies
- Low stock alerts
- Add, edit, and delete inventory items

### ✅ Pen Management
- Organize birds by pens/houses
- Track bird count per pen
- Monitor mortality rates

### ✅ Daily Logs
- Record daily activities
- Track feed consumption
- Monitor health issues
- Water consumption logs

### ✅ Reports & Analytics
- Generate comprehensive reports
- Export data (coming soon)
- Production analytics
- Inventory reports

---

## 🚀 Quick Start

### 👥 Choose Your Path:

#### **For Company/Non-Technical Users:**
> Just want to build and get the AAB file? No technical skills needed!

📖 **READ: [FLUTLAB_GUIDE.md](FLUTLAB_GUIDE.md)**
- Simple step-by-step guide
- No command line required
- Just click buttons in FlutLab.io
- Get AAB file in 15 minutes!

#### **For Developers:**
> Want to develop or modify the code?

```bash
# Clone the repository
git clone <repository-url>
cd Alowonle-Poultry-Manager

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build appbundle --release
```

📖 **READ: [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)** for details

---

## 🏗️ Building for Production

### **Non-Technical Users:**
See **[FLUTLAB_GUIDE.md](FLUTLAB_GUIDE.md)** - No installation needed, use FlutLab.io web interface!

### **Developers with Flutter Installed:**

```bash
# Android APK (for testing)
flutter build apk --release

# Android App Bundle (for Google Play)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

---

## 📦 Tech Stack

- **Framework:** Flutter 3.24+
- **State Management:** Riverpod
- **Local Database:** Hive
- **Navigation:** Go Router
- **Charts:** FL Chart
- **PDF Generation:** PDF & Printing packages

---

## 📁 Project Structure

```
lib/
├── core/                 # Core functionality (routing, storage)
├── data/                 # Data models (Hive models)
├── features/             # Feature modules
│   ├── dashboard/        # Dashboard & analytics
│   ├── inventory/        # Inventory management
│   ├── logs/             # Daily logs
│   ├── pens/             # Pen management
│   ├── reports/          # Reports generation
│   └── splash/           # Splash screen
└── main.dart             # App entry point
```

---

## 🔧 Configuration

### Assets
Logo and assets are located in `assets/images/`:
- `logo_bg.png` - Main logo with background
- `logo_sm.png` - Small logo variant

### Database
The app uses Hive for local storage. Data is stored locally on the device.

---

## 🌐 CI/CD & FlutLab.io

This repository is optimized for:
- ✅ FlutLab.io direct building
- ✅ GitHub Actions CI/CD
- ✅ Clean repository structure
- ✅ No unnecessary files

See [REPOSITORY_SETUP.md](REPOSITORY_SETUP.md) for detailed CI/CD instructions.

---

## 📝 Development

### Code Generation
This project uses code generation for:
- Hive type adapters
- Riverpod providers
- Go Router routes

Generated files (*.g.dart) are included in the repository for easier CI/CD builds.

If you need to regenerate:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Linting
```bash
flutter analyze
```

### Testing
```bash
flutter test
```

---

## 📸 Screenshots

*(Add screenshots of your app here)*

---

## 🤝 Contributing

This is a proprietary project. For contributions or issues, contact the development team.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Developer

Developed for Alowonle Poultry Farm

---

## 📞 Support

For issues or questions:
- Check documentation in `BUILD_INSTRUCTIONS.md`
- Review `REPOSITORY_SETUP.md` for CI/CD setup
- Contact the development team

---

## 🔄 Version History

- **v1.0.0** - Initial release
  - Dashboard with production charts
  - Inventory management
  - Pen management
  - Daily logs
  - Reports generation
  - Custom splash screen

---

**Built with ❤️ using Flutter**
