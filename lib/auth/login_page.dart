import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Pages
import 'register_page.dart';
import '../auth/forgot_password.dart';
import '../learning_path/page/survey_page.dart';
import '../screen/home/page/navigation_page.dart';
import 'package:my_learning_plan/screen/admin/admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final email = TextEditingController();
  final password = TextEditingController();

  bool obscure = true;
  bool isLoading = false;

  // Animation
  late AnimationController _controller;
  late Animation<double> _bgPulse;
  late Animation<double> _headerFade;
  late Animation<double> _cardFade;
  late Animation<Offset> _cardSlide;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _bgPulse = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );

    _cardFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOut),
      ),
    );

    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _buttonScale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String msg, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ================= LOGIN =================
  Future<void> _login() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ Email và Mật khẩu");
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = credential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        setState(() => isLoading = false);
        _showMessage("Tài khoản chưa có dữ liệu!");
        return;
      }

      final data = userDoc.data()!;
      final String role = data['role'] ?? 'user';
      final bool surveyCompleted = data['surveyCompleted'] == true;

      setState(() => isLoading = false);

      // ===== ĐIỀU HƯỚNG =====
      Widget nextPage;
      if (role == 'admin') {
        nextPage = const AdminDashboard();
      } else {
        nextPage =
            surveyCompleted ? const NavigationPage() : const SurveyPage();
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, animation, __) => nextPage,
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      if (e.code == 'user-not-found') {
        _showMessage("Email không tồn tại");
      } else if (e.code == 'wrong-password') {
        _showMessage("Sai mật khẩu");
      } else {
        _showMessage(e.message ?? "Đăng nhập thất bại");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage("Có lỗi xảy ra");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgPulse,
        builder: (_, __) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFe0f7fa), Color(0xFFf1f8ff)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              Positioned(
                top: -80 * (1 - _bgPulse.value),
                left: -40,
                child: _blurCircle(160, Colors.teal.withOpacity(0.25)),
              ),
              Positioned(
                top: size.height * 0.28,
                right: -50 * (1 - _bgPulse.value),
                child: _blurCircle(140, Colors.blue.withOpacity(0.18)),
              ),
              Positioned(
                bottom: -60,
                left: size.width * 0.3,
                child: _blurCircle(120, Colors.tealAccent.withOpacity(0.18)),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: _headerFade,
                        child: Column(
                          children: [
                            Icon(Icons.lock_outline,
                                size: 50, color: Colors.teal),
                            const SizedBox(height: 12),
                            Text("Chào mừng trở lại",
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _cardFade,
                        child: SlideTransition(
                          position: _cardSlide,
                          child: _loginCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _loginCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          _input("Email", email, Icons.email, false),
          const SizedBox(height: 14),
          _input("Mật khẩu", password, Icons.lock, true),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordPage(),
                ),
              ),
              child: const Text("Quên mật khẩu?"),
            ),
          ),
          ScaleTransition(
            scale: _buttonScale,
            child: ElevatedButton(
              onPressed: isLoading ? null : _login,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Đăng nhập"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            ),
            child: const Text("Chưa có tài khoản? Đăng ký"),
          ),
        ],
      ),
    );
  }

  Widget _input(
      String label, TextEditingController ctrl, IconData icon, bool pass) {
    return TextField(
      controller: ctrl,
      obscureText: pass ? obscure : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: pass
            ? IconButton(
                icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () =>
                    setState(() => obscure = !obscure),
              )
            : null,
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
