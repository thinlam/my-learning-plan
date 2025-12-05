import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool isLoading = false;

  // ===========================
  //      REGISTER FUNCTION
  // ===========================
  Future<void> _register() async {
    if (name.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.trim().isEmpty) {
      _showMessage("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    if (password.text != confirm.text) {
      _showMessage("Mật khẩu xác nhận không trùng khớp");
      return;
    }

    try {
      setState(() => isLoading = true);

      // 1. Tạo tài khoản Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      final uid = userCredential.user!.uid;

      // 2. Lưu thông tin user lên Firestore
      await FirebaseFirestore.instance.collection("Users").doc(uid).set({
        "name": name.text.trim(),
        "email": email.text.trim(),
        "createdAt": DateTime.now(),
      });

      _showMessage("Tạo tài khoản thành công!");

      // 3. Điều hướng về Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? "Đã xảy ra lỗi không xác định");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Đăng ký",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.teal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: password,
              obscureText: obscure1,
              decoration: InputDecoration(
                labelText: "Mật khẩu",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => obscure1 = !obscure1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: confirm,
              obscureText: obscure2,
              decoration: InputDecoration(
                labelText: "Xác nhận mật khẩu",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => obscure2 = !obscure2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Đăng ký",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
