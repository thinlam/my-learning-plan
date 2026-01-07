import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'auth/login_page.dart';
import 'core/locale/locale_provider.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    final theme = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "StudyMate - Learning App",

      // 🌍 ĐA NGÔN NGỮ
      locale: locale,
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('ja'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🌗 THEME
      themeMode: theme.themeMode,

      /// 🌞 LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        cardColor: Colors.white,
        primaryColor: Colors.teal,

        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFF6B7280),
          textColor: Color(0xFF111827),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      /// 🌑 DARK THEME — ĐEN THẬT, NỔI KHỐI
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        primaryColor: Colors.teal,

        colorScheme: const ColorScheme.dark(
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
          primary: Colors.teal,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),

        listTileTheme: const ListTileThemeData(
          tileColor: Color(0xFF1E1E1E),
          iconColor: Color(0xFFB0B0B0),
          textColor: Colors.white,
        ),

        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),

      home: const SplashAnimation(),
    );
  }
}

/// =======================
/// ⭐ SPLASH ANIMATION
/// =======================
class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 90,
                  color: Colors.teal.shade500,
                ),
                const SizedBox(height: 16),
                Text(
                  "StudyMate",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Learning Made Easy",
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
