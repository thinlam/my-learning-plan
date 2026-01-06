import 'package:flutter/material.dart';
import 'package:my_learning_plan/forum/ui/forum_ui.dart';

// Import các màn hình trong app
import 'home_page.dart';
import 'profile_page.dart';

// Learning Path
import '../../../learning_path/page/path_selection_page.dart';

// Progress Page
import '../../../progress/progress_page.dart';

// Notification
import '../../../notification/notification_page.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;

  const NavigationPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // ⭐ DANH SÁCH MÀN HÌNH (BỎ const LIST)
  final List<Widget> _screens = [
    const HomeScreen(),
    const PathSelectionPage(),
    const ProgressPage(),
    const NotificationsPage(),
    const ProfilePage(),
    const ForumUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final fade =
              Tween<double>(begin: 0, end: 1).animate(animation);
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ⭐ BOTTOM NAVIGATION BAR
  Widget _buildBottomBar() {
    return NavigationBar(
      height: 68,
      selectedIndex: _currentIndex,
      indicatorColor: Colors.teal.withOpacity(0.15),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (i) {
        if (i == _currentIndex) return;

        setState(() {
          _currentIndex = i;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Colors.teal),
          label: "Trang chủ",
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore, color: Colors.teal),
          label: "Khám phá",
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights, color: Colors.teal),
          label: "Tiến độ",
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_outlined),
          selectedIcon: Icon(Icons.notifications, color: Colors.teal),
          label: "Thông báo",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Colors.teal),
          label: "Cá nhân",
        ),
        NavigationDestination(
          icon: Icon(Icons.forum_outlined),
          selectedIcon: Icon(Icons.forum, color: Colors.teal),
          label: "Diễn đàn",
        ),
      ],
    );
  }
}
