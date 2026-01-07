import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Bài học mới",
      "content": "Khóa Flutter cơ bản đã có bài học mới.",
      "icon": Icons.library_books,
      "color": Colors.blue,
      "time": "2 giờ trước",
    },
    {
      "title": "Nhắc nhở học tập",
      "content": "Bạn có 1 bài học chưa hoàn thành hôm nay.",
      "icon": Icons.alarm,
      "color": Colors.orange,
      "time": "5 giờ trước",
    },
    {
      "title": "Thành tích",
      "content": "Bạn đã đạt 5 ngày streak liên tiếp!",
      "icon": Icons.emoji_events,
      "color": Colors.amber,
      "time": "Hôm qua",
    },
    {
      "title": "Quiz mới",
      "content": "Có bài quiz mới trong lộ trình Flutter.",
      "icon": Icons.quiz,
      "color": Colors.purple,
      "time": "2 ngày trước",
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông báo")),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _notifications.length,
            itemBuilder: (_, i) =>
                _notificationItem(context, _notifications[i], i),
          ),
        ),
      ),
    );
  }

  Widget _notificationItem(BuildContext context, Map item, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500 + index * 100),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _icon(item["icon"], item["color"]),
          const SizedBox(width: 14),
          Expanded(child: _text(context, item)),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _text(BuildContext context, Map item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item["title"],
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(item["content"], style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 4),
            Text(item["time"], style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
