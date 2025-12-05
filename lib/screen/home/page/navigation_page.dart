import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import các màn hình trong app
import 'home_page.dart';
import 'notifications_page.dart' hide NotificationsPage;
import 'profile_page.dart';

// ⭐ Import Learning Path
import '../../../learning_path/page/path_selection_page.dart';

// ⭐ Import Progress Page
import '../../../progress/progress_page.dart';
// ⭐ import notidication
import '../../../notification/notification_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fade = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slide = Tween(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ⭐ DANH SÁCH MÀN HÌNH (ĐÃ THÊM PROGRESS PAGE)
  late final List<Widget> _screens = [
    const HomeScreen(),
    const PathSelectionPage(),
    const ProgressPage(), // ⭐ Thêm tab Tiến độ học
    const NotificationsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ⭐ BOTTOM NAVIGATION BAR (ĐÃ THÊM TAB TIẾN ĐỘ)
  Widget _buildBottomBar() {
    return NavigationBar(
      height: 68,
      selectedIndex: _currentIndex,
      indicatorColor: Colors.teal.withOpacity(0.15),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (i) {
        setState(() {
          _currentIndex = i;
          _controller.forward(from: 0);
        });
      },
      destinations: [
        _navItem(Icons.home_outlined, Icons.home, "Trang chủ"),
        _navItem(Icons.explore_outlined, Icons.explore, "Khám phá"),
        _navItem(
          Icons.insights_outlined,
          Icons.insights,
          "Tiến độ",
        ), // ⭐ Tab mới
        _navItem(
          Icons.notifications_outlined,
          Icons.notifications,
          "Thông báo",
        ),
        _navItem(Icons.person_outline, Icons.person, "Cá nhân"),
      ],
    );
  }

  NavigationDestination _navItem(
    IconData icon,
    IconData selected,
    String label,
  ) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selected, color: Colors.teal),
      label: label,
    );
  }
}
