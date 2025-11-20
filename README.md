# mobile_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#VS Code

B1. Tải Flutter SDK về:

- https://flutter.dev/docs/get-started/install

- Chọn Custom setup → install manually 

- Chọn Windows → Download ZIP.

B2. Giải nén vào thư mục:

- C:\src\flutter

B3. Thêm vào PATH:

- C:\src\flutter\bin

B4. Mở lại VS Code → bấm Locate SDK → chọn thư mục:

- C:\src\flutter

#Android Studio 

B1. Tải Flutter SDK về:

- https://flutter.dev/docs/get-started/install

- Chọn Custom setup → install manually 

- Chọn Windows → Download ZIP.

B2. Open Android Studio → Setting → Plugins → Marketplace → search flutter & dart → install → Click Yes when prompted to install the plugin → Click Restart 

B3. Click New Flutter Project → Generators → Flutter → click ... → chọn folder flutter nãy tải → select folder → next 

B4. Create Project or Clone Project 



# open folder

B1: Nếu lỗi  
fatal: detected dubious ownership in repository at 'G:/flutter'  
'G:/flutter' is on a file system that does not record ownership  
Error: Unable to determine engine version...

- Mở CMD (Admin)
- git config --global --add safe.directory G:/flutter
- hoặc git config --global --add safe.directory G:/flutter/flutter
- flutter doctor
- flutter clean + flutter pub get + flutter run

---

B2: Nếu lỗi  
Building with plugins requires symlink support.  
Please enable Developer Mode...

- Win + R
- chạy: start ms-settings:developers
- bật Developer Mode
- restart máy (khuyến nghị)
- flutter clean + flutter pub get + flutter run

---

B3: Nếu lỗi  
[!] Android toolchain - Some Android licenses not accepted.

- flutter doctor --android-licenses
- Khi hỏi “Do you accept the license? (y/N)” → bấm y liên tục
- flutter doctor

---

B4: Nếu lỗi  
Your project is configured with Android NDK 26.x  
nhưng plugin yêu cầu NDK 27.x (như path_provider_android)

- Mở file: android/app/build.gradle.kts
- Trong block android thêm:
  ndkVersion = "27.0.12077973"
- flutter clean + flutter pub get + flutter run

---

B5: Nếu lỗi  
Target of URI doesn't exist: 'package:google_fonts/google_fonts.dart'  
Undefined name 'GoogleFonts'.

- Mở pubspec.yaml
- Thêm vào dependencies:
  google_fonts: ^6.2.1
- flutter pub get
- flutter run

---

B6: Nếu lỗi Flutter không chạy HomeScreen

- Kiểm tra file nằm ở: lib/screens/home_screen.dart
- Mở main.dart → thêm:

import 'screens/home_screen.dart';

home: const HomeScreen(),

---

B7: Nếu lỗi Engine version hoặc Flutter SDK hỏng

- Kiểm tra thư mục G:/flutter có folder .git chưa
- Nếu không có → tải lại Flutter từ GitHub:
  https://github.com/flutter/flutter/archive/refs/heads/stable.zip
- Giải nén lại vào G:/flutter
- flutter doctor

---

B8: Nếu lỗi cmdline-tools hoặc Android SDK thiếu

- Mở Android Studio → SDK Manager
- Install:
  ✔ Android SDK Platform  
  ✔ Android SDK Tools  
  ✔ Android SDK Command-line tools
- flutter doctor

---

B9: Nếu lỗi Gradle hoặc build failed chung

- flutter clean
- xóa thư mục android/.gradle
- chạy lại: flutter pub get + flutter run

---

B10: Nếu lỗi pubspec.yaml bị sai formatting

- Không dùng tab, chỉ dùng space
- Check khoảng cách thụt dòng đúng format YAML
- flutter pub get






