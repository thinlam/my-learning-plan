import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  bool isLoading = true;
  bool isAvatarLoading = true;

  String? selectedAvatarUrl;

  static const List<String> avatarFolders = [
    'classic',
    'squid_game',
    'One_Piece',
  ];

  final Map<String, List<String>> avatarGroups = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadAvatarGroups();
  }

  // =========================
  // LOAD PROFILE
  // =========================
  Future<void> _loadProfile() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();

    final data = doc.data();
    _nameCtrl.text = data?['name'] ?? '';
    selectedAvatarUrl = data?['avatarUrl'];
    _emailCtrl.text = user!.email ?? '';

    setState(() => isLoading = false);
  }

  // =========================
  // LOAD AVATAR GROUPS
  // =========================
  Future<void> _loadAvatarGroups() async {
    try {
      for (final folder in avatarFolders) {
        final ref = FirebaseStorage.instance.ref('avatar_presets/$folder');
        final result = await ref.listAll();
        if (result.items.isEmpty) continue;

        avatarGroups[folder] = await Future.wait(
          result.items.map((e) => e.getDownloadURL()),
        );
      }
    } catch (e) {
      debugPrint('Load avatar error: $e');
    }

    setState(() => isAvatarLoading = false);
  }

  // =========================
  // AVATAR ITEM (GỌN – PRO)
  // =========================
  Widget _avatarItem(String url, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.02 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.teal.withOpacity(0.35)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28, // 👈 size gọn
              backgroundImage: NetworkImage(url),
              backgroundColor: Colors.grey.shade800,
            ),
          ),
          if (isSelected)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.28),
              ),
            ),
          if (isSelected)
            const Icon(Icons.check_circle, color: Colors.tealAccent, size: 22),
        ],
      ),
    );
  }

  // =========================
  // AVATAR PICKER (GỌN)
  // =========================
  void _showAvatarPicker() {
    if (isAvatarLoading || avatarGroups.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đang tải avatar...')));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: avatarGroups.entries.map((entry) {
                  final groupName = entry.key;
                  final avatars = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            groupName.replaceAll('_', ' ').toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Divider(
                              color: Colors.white.withOpacity(0.12),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: avatars.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                            ),
                        itemBuilder: (_, index) {
                          final url = avatars[index];
                          final isSelected = url == selectedAvatarUrl;

                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedAvatarUrl = url);
                              Navigator.pop(context);
                            },
                            child: _avatarItem(url, isSelected),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // SAVE PROFILE
  // =========================
  Future<void> _saveProfile() async {
    if (user == null) return;

    setState(() => isLoading = true);

    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'name': _nameCtrl.text.trim(),
      'avatarUrl': selectedAvatarUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật hồ sơ')));
    Navigator.pop(context);
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showAvatarPicker,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.teal.shade200,
                      backgroundImage: selectedAvatarUrl != null
                          ? NetworkImage(selectedAvatarUrl!)
                          : null,
                      child: selectedAvatarUrl == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tên hiển thị',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _emailCtrl,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Lưu thay đổi',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
