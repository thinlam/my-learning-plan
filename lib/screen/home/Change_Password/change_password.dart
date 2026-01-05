import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final user = FirebaseAuth.instance.currentUser;

  bool get hasUpper => _newCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get hasLower => _newCtrl.text.contains(RegExp(r'[a-z]'));
  bool get hasNumber => _newCtrl.text.contains(RegExp(r'[0-9]'));
  bool get hasMinLength => _newCtrl.text.length >= 8;
  bool get notSameAsOld =>
      _newCtrl.text.isNotEmpty && _newCtrl.text != _currentCtrl.text;
  bool get confirmMatch =>
      _newCtrl.text == _confirmCtrl.text && _confirmCtrl.text.isNotEmpty;

  bool get canSubmit =>
      hasUpper &&
      hasLower &&
      hasNumber &&
      hasMinLength &&
      notSameAsOld &&
      confirmMatch &&
      !_loading;

  Future<void> _changePassword() async {
    try {
      setState(() => _loading = true);

      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: _currentCtrl.text,
      );

      // 🔐 Re-auth
      await user!.reauthenticateWithCredential(cred);

      // 🔄 Update password on Firebase
      await user!.updatePassword(_newCtrl.text);

      _show("Đổi mật khẩu thành công");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? "Không thể đổi mật khẩu");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bảo mật tài khoản",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Mật khẩu mới phải đáp ứng đầy đủ các điều kiện bảo mật.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            _card(
              child: Column(
                children: [
                  _passwordField(
                    label: "Mật khẩu hiện tại",
                    controller: _currentCtrl,
                    obscure: _obscureCurrent,
                    onToggle: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  const SizedBox(height: 16),
                  _passwordField(
                    label: "Mật khẩu mới",
                    controller: _newCtrl,
                    obscure: _obscureNew,
                    onChanged: (_) => setState(() {}),
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  _passwordField(
                    label: "Xác nhận mật khẩu",
                    controller: _confirmCtrl,
                    obscure: _obscureConfirm,
                    onChanged: (_) => setState(() {}),
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 20),

                  /// Rules
                  _rule("Ít nhất 8 ký tự", hasMinLength),
                  _rule("Có chữ hoa (A-Z)", hasUpper),
                  _rule("Có chữ thường (a-z)", hasLower),
                  _rule("Có số (0-9)", hasNumber),
                  _rule("Khác mật khẩu cũ", notSameAsOld),
                  _rule("Xác nhận khớp", confirmMatch),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: canSubmit ? _changePassword : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  disabledBackgroundColor: Colors.orange.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Cập nhật mật khẩu",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    VoidCallback? onToggle,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _rule(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: ok ? Colors.green : Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }
}
