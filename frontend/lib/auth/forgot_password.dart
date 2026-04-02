import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> _sendResetEmail() async {
    if (!emailCtrl.text.contains('@')) {
      _show("Email không hợp lệ");
      return;
    }

    setState(() => loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailCtrl.text.trim(),
      );

      _show("Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra Gmail.");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _show(_mapError(e.code));
    } finally {
      setState(() => loading = false);
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return "Email chưa được đăng ký";
      case 'invalid-email':
        return "Email không hợp lệ";
      default:
        return "Có lỗi xảy ra, vui lòng thử lại";
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quên mật khẩu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Khôi phục mật khẩu",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Nhập email đã đăng ký. Chúng tôi sẽ gửi liên kết đặt lại mật khẩu.",
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            const SizedBox(height: 24),

            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _sendResetEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Gửi email khôi phục"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
