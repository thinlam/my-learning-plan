import 'package:flutter/material.dart';

/// =======================================================
/// FORUM UI – ONLY GIAO DIỆN
/// Có: List + Filter Lớp 10/11/12/ĐH + Detail + Create
/// =======================================================

class ForumPost {
  final String title;
  final String author;
  final String grade; // "Lớp 10" | "Lớp 11" | "Lớp 12" | "Đại học"
  final String time;
  final String likes;
  final String comments;

  const ForumPost({
    required this.title,
    required this.author,
    required this.grade,
    required this.time,
    required this.likes,
    required this.comments,
  });
}

class ForumUI extends StatefulWidget {
  const ForumUI({super.key});

  @override
  State<ForumUI> createState() => _ForumUIState();
}

class _ForumUIState extends State<ForumUI> {
  static const List<String> _grades = [
    "Tất cả",
    "Lớp 10",
    "Lớp 11",
    "Lớp 12",
    "Đại học",
  ];

  String _selectedGrade = "Tất cả";

  final List<ForumPost> _posts = const [
    ForumPost(
      title: "Lộ trình Toán lớp 10 từ mất gốc",
      author: "Giáo viên Toán",
      grade: "Lớp 10",
      time: "2 giờ trước",
      likes: "45",
      comments: "12",
    ),
    ForumPost(
      title: "Cách học Hóa lớp 11 hiệu quả",
      author: "Thầy Minh",
      grade: "Lớp 11",
      time: "Hôm qua",
      likes: "62",
      comments: "18",
    ),
    ForumPost(
      title: "Ôn thi THPT Quốc Gia môn Toán",
      author: "Mentor 12",
      grade: "Lớp 12",
      time: "3 ngày trước",
      likes: "120",
      comments: "34",
    ),
    ForumPost(
      title: "Lộ trình học CNTT cho sinh viên năm nhất",
      author: "Mentor Đại học",
      grade: "Đại học",
      time: "1 tuần trước",
      likes: "210",
      comments: "55",
    ),
  ];

  List<ForumPost> get _filteredPosts {
    if (_selectedGrade == "Tất cả") return _posts;
    return _posts.where((p) => p.grade == _selectedGrade).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Diễn đàn học tập"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // ===== FILTER CẤP HỌC (Facebook style) =====
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _grades.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final label = _grades[i];
                final selected = _selectedGrade == label;

                return _FilterChip(
                  label: label,
                  selected: selected,
                  onSelected: () {
                    setState(() => _selectedGrade = label);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // ===== LIST BÀI VIẾT =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                final post = _filteredPosts[index];
                return _PostCard(
                  title: post.title,
                  author: post.author,
                  grade: post.grade,
                  time: post.time,
                  likes: post.likes,
                  comments: post.comments,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForumDetailUI(post: post),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ===== CREATE BUTTON =====
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.edit),
        label: const Text("Tạo bài"),
        onPressed: () {
          // default grade: nếu đang lọc theo 1 cấp học, đem qua create luôn
          final defaultGrade = (_selectedGrade == "Tất cả")
              ? "Lớp 10"
              : _selectedGrade;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ForumCreateUI(initialGrade: defaultGrade),
            ),
          );
        },
      ),
    );
  }
}

/// =======================================================
/// POST CARD
/// =======================================================
class _PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String grade;
  final String time;
  final String likes;
  final String comments;
  final VoidCallback? onTap;

  const _PostCard({
    required this.title,
    required this.author,
    required this.grade,
    required this.time,
    required this.likes,
    required this.comments,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== GRADE BADGE =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      grade,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ===== TITLE =====
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),

              // ===== STATS =====
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_alt_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(likes),
                    const SizedBox(width: 14),
                    const Icon(Icons.chat_bubble_outline, size: 18),
                    const SizedBox(width: 4),
                    Text(comments),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// FILTER CHIP
/// =======================================================
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: Colors.teal,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) => onSelected(),
    );
  }
}

/// =======================================================
/// DETAIL UI
/// =======================================================
class ForumDetailUI extends StatelessWidget {
  final ForumPost post;

  const ForumDetailUI({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text("Chi tiết bài viết")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PostCard(
            title: post.title,
            author: post.author,
            grade: post.grade,
            time: post.time,
            likes: post.likes,
            comments: post.comments,
            onTap: null, // detail thì không tap nữa
          ),
          const SizedBox(height: 12),

          // ===== COMMENT BOX =====
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Viết bình luận...",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Colors.teal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// CREATE POST UI (CÓ CHỌN CẤP HỌC)
/// =======================================================
class ForumCreateUI extends StatefulWidget {
  final String initialGrade;

  const ForumCreateUI({super.key, this.initialGrade = "Lớp 10"});

  @override
  State<ForumCreateUI> createState() => _ForumCreateUIState();
}

class _ForumCreateUIState extends State<ForumCreateUI> {
  static const List<String> _gradeOptions = [
    "Lớp 10",
    "Lớp 11",
    "Lớp 12",
    "Đại học",
  ];

  late String _selectedGrade;

  @override
  void initState() {
    super.initState();
    _selectedGrade = widget.initialGrade;
    if (!_gradeOptions.contains(_selectedGrade)) {
      _selectedGrade = "Lớp 10";
    }
  }

  Future<void> _pickGrade() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Chọn cấp học",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                ..._gradeOptions.map((g) {
                  return RadioListTile<String>(
                    value: g,
                    groupValue: _selectedGrade,
                    onChanged: (v) => Navigator.pop(context, v),
                    title: Text(g),
                    activeColor: Colors.teal,
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _selectedGrade = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Tạo bài viết"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: InkWell(
                onTap: () {
                  // UI-only
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("UI demo: Đã bấm Đăng")),
                  );
                },
                child: const Text(
                  "Đăng",
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== SELECT GRADE (BẤM ĐỂ CHỌN) =====
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _pickGrade,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.school_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Cấp học: $_selectedGrade",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== TITLE =====
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tiêu đề bài viết",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ===== CONTENT =====
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText:
                          "Chia sẻ kinh nghiệm, câu hỏi hoặc lộ trình học...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
