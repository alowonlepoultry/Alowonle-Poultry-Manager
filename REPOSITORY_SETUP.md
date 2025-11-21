# Repository Setup Guide for Non-Technical Users

## 🎯 FLUTLAB.IO READY - NO TECHNICAL SKILLS NEEDED!

This repository is configured for **simple point-and-click building**.  
**Company needs ZERO technical knowledge** - just click buttons in FlutLab.io!

### ✅ What This Means:
- ✅ No command line needed
- ✅ No code generation needed
- ✅ No build_runner commands
- ✅ Just: Import → Click Build → Download AAB
- ✅ No Google account linking issues

---

## 📋 What's in the Repository

### ✅ INCLUDED (Everything needed to build):
- **All source code** (`lib/`, `test/`)
- **All assets** (logos, images)
- **All configuration** (pubspec.yaml, build files)
- **All generated code** (`*.g.dart`) - Pre-generated!
- **All platform configs** (Android, iOS settings)

### ❌ EXCLUDED (Personal/system-specific files):
- **Your IDE settings** (`.vscode/`, `.idea/`) - Could link to your system
- **Build outputs** (FlutLab regenerates)
- **Dependencies** (FlutLab auto-downloads)
- **Local paths** (`local.properties`, Gradle cache)
- **Signing keys** (Company handles separately)

---

## 🚀 For Company: How to Build (3 EASY STEPS!)

### Method 1: FlutLab.io (RECOMMENDED - No Technical Skills Needed!)

**STEP 1:** Go to https://flutlab.io
   - Sign up or log in with your company account
   - Click "Import Project"
   - Connect to GitHub
   - Select "Alowonle Poultry Manager" repository
   - Click "Import"

**STEP 2:** Wait for FlutLab to set up (2-3 minutes)
   - FlutLab will automatically download dependencies
   - You'll see "Project Ready" when done
   - No commands to run - it's automatic!

**STEP 3:** Build the AAB
   - Click the "Build" button (top right)
   - Select "Android App Bundle (AAB)"
   - Wait for build (5-10 minutes)
   - Click "Download" when complete

**THAT'S IT!** 🎉
   - No technical knowledge needed
   - No commands to type
   - Everything works automatically
   - Upload the AAB file to Google Play Console

### Method 2: Using GitHub Actions (Automated)

1. **Add GitHub Actions workflow**
   - See `BUILD_INSTRUCTIONS.md` for the workflow file
   - Place it in `.github/workflows/build.yml`

2. **Push to GitHub**
   - Every push will trigger an automatic build
   - Download artifacts from GitHub Actions

3. **Configure Secrets** (for signed releases)
   - Add signing keystore to GitHub Secrets
   - Configure `key.properties` values as secrets

### Method 3: Local Build

```bash
# Clone the repository
git clone <repository-url>
cd Alowonle-Poultry-Manager

# Install dependencies
flutter pub get

# Build APK
flutter build apk --release

# Build AAB (for Play Store)
flutter build appbundle --release
```

---

## 🔧 Generated Files Configuration

**Current Setting:** Generated files (`.g.dart`) **ARE INCLUDED** in the repository.

### Why?
- ✅ FlutLab.io can build immediately
- ✅ No need to run build_runner in CI/CD
- ✅ Simpler setup for builders
- ✅ Works on all platforms

### Want a cleaner repo?
If you prefer to exclude generated files:

1. Edit `.gitignore`
2. Uncomment these lines:
   ```gitignore
   *.g.dart
   *.freezed.dart
   *.gr.dart
   ```
3. Remove existing generated files from Git:
   ```bash
   git rm --cached lib/**/*.g.dart
   git commit -m "Remove generated files from tracking"
   ```
4. Update CI/CD to run before building:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## 🔐 App Signing for Release

### For the Company to Sign the App:

1. **Generate Keystore** (one-time, keep secure!)
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Create `android/key.properties`** (NOT in Git!)
   ```properties
   storePassword=<password-from-step-1>
   keyPassword=<password-from-step-1>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

3. **Place keystore file** in `android/` directory

4. **Build signed AAB**
   ```bash
   flutter build appbundle --release
   ```

5. **Upload to Google Play Console**
   - File will be at: `build/app/outputs/bundle/release/app-release.aab`

---

## 📂 Repository Structure

```
Alowonle-Poultry-Manager/
├── lib/                          # Source code ✅
│   ├── core/                     # Core functionality
│   ├── data/                     # Data models
│   └── features/                 # App features
├── assets/                       # Images & resources ✅
│   └── images/
│       ├── logo_bg.png
│       └── logo_sm.png
├── android/                      # Android config ✅
│   └── app/
│       └── src/main/
├── ios/                          # iOS config ✅
├── test/                         # Tests ✅
├── pubspec.yaml                  # Dependencies ✅
├── .gitignore                    # Git exclusions ✅
├── BUILD_INSTRUCTIONS.md         # Build guide ✅
└── REPOSITORY_SETUP.md          # This file ✅
```

---

## ⚠️ Important Notes

### For You (Developer):
- ✅ You can push code without any Google account
- ✅ No account linking issues
- ✅ Clean repository with only necessary files
- ✅ Company handles all signing and publishing

### For Company (Builder):
- ✅ Clone repo and build immediately
- ✅ No need to run code generation
- ✅ FlutLab.io works out of the box
- ✅ Can set up automated CI/CD easily

### Security:
- ✅ No API keys in repository
- ✅ No signing keys in repository
- ✅ No local configurations in repository
- ✅ Safe to push to public/private GitHub

---

## 🆘 Troubleshooting

### "Asset not found" error
**Solution:** Run `flutter pub get`

### "Build failed" on FlutLab
**Solution:** Check that all assets are properly listed in `pubspec.yaml`

### "Gradle sync failed"
**Solution:** 
1. Check `android/build.gradle.kts` configuration
2. Ensure Java 11+ is installed
3. Clear Gradle cache if needed

### "Code generation issue"
**Solution:** The generated files are already in the repo, but if you need to regenerate:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📞 Support

For build issues:
- Check `BUILD_INSTRUCTIONS.md` for detailed steps
- Review Flutter documentation: https://docs.flutter.dev
- FlutLab.io documentation: https://flutlab.io/docs

---

**Last Updated:** November 21, 2024  
**Repository Status:** ✅ Ready for CI/CD and FlutLab.io

