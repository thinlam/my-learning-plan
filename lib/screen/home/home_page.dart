// home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Constants
  static const _animationDuration = Duration(milliseconds: 600);
  static const _quoteChangeDuration = Duration(seconds: 5);
  static const _progressAnimationDuration = Duration(seconds: 2);

  final List<String> _inspirationalQuotes = [
    "Học không bao giờ là muộn.",
    "Thành công đến từ sự kiên trì.",
    "Mỗi ngày học một chút, thành công một bước.",
    "Kiến thức là sức mạnh.",
    "Đầu tư vào tri thức mang lại lợi nhuận cao nhất.",
  ];

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  String _currentQuote = "";
  int _currentIndex = 0;
  bool _isWelcomeAnimated = false;
  bool _isProgressAnimated = false;
  bool _isTopicsAnimated = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeData() {
    _currentQuote = _inspirationalQuotes.first;
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _animationController.forward();

    // Staggered animations for different sections
    final delays = [500, 700, 900];
    for (var i = 0; i < delays.length; i++) {
      await Future.delayed(Duration(milliseconds: delays[i]));
      if (!mounted) return;

      setState(() {
        switch (i) {
          case 0:
            _isWelcomeAnimated = true;
          case 1:
            _isProgressAnimated = true;
          case 2:
            _isTopicsAnimated = true;
        }
      });
    }

    _startQuoteRotation();
  }

  void _startQuoteRotation() {
    _shuffleQuote();
  }

  void _shuffleQuote() {
    Future.delayed(_quoteChangeDuration, () {
      if (!mounted) return;

      setState(() {
        final currentIndex = _inspirationalQuotes.indexOf(_currentQuote);
        final nextIndex = (currentIndex + 1) % _inspirationalQuotes.length;
        _currentQuote = _inspirationalQuotes[nextIndex];
      });

      _shuffleQuote();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.teal,
      elevation: 1,
      title: _buildAppBarTitle(),
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildAppBarTitle() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * 20),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          _buildIconContainer(
            icon: Icons.school,
            color: Colors.teal.withOpacity(0.1),
          ),
          const SizedBox(width: 12),
          Text(
            'Study Path',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.teal.shade800,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      ScaleTransition(
        scale: _scaleAnimation,
        child: _buildNotificationButton(),
      ),
      const SizedBox(width: 8),
      SlideTransition(position: _slideAnimation, child: _buildProfileButton()),
    ];
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.notifications_outlined, size: 26),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      onPressed: () => _showNotifications(context),
      tooltip: 'Thông báo',
    );
  }

  Widget _buildProfileButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _showProfileMenu(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.teal.shade300, width: 2),
          ),
          child: const Icon(Icons.person, color: Colors.teal),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedSection(
            isAnimated: _isWelcomeAnimated,
            child: _buildWelcomeSection(),
          ),
          const SizedBox(height: 24),
          _buildAnimatedSection(
            isAnimated: _isProgressAnimated,
            child: _buildLearningProgress(),
          ),
          const SizedBox(height: 24),
          _buildAnimatedSection(
            isAnimated: _isTopicsAnimated,
            child: _buildFeaturedTopics(),
          ),
          const SizedBox(height: 24),
          _buildInspirationalQuote(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection({
    required bool isAnimated,
    required Widget child,
  }) {
    return AnimatedOpacity(
      duration: _animationDuration,
      opacity: isAnimated ? 1.0 : 0.0,
      child: AnimatedPadding(
        duration: _animationDuration,
        padding: EdgeInsets.only(top: isAnimated ? 0.0 : 20.0),
        child: child,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: _buildGradientBoxDecoration(
            colors: [Colors.teal.shade500, Colors.teal.shade700],
            shadowColor: Colors.teal,
          ),
          child: Row(
            children: [
              Expanded(child: _buildWelcomeContent()),
              const SizedBox(width: 16),
              _buildWelcomeIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedText(
          'Xin chào, Hải! 👋',
          duration: const Duration(milliseconds: 500),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildAnimatedText(
          'Chúc bạn một ngày học tập hiệu quả và tràn đầy năng lượng!',
          duration: const Duration(milliseconds: 700),
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color.fromRGBO(255, 255, 255, 0.9),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        _buildStreakBadge(),
      ],
    );
  }

  Widget _buildStreakBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
          const SizedBox(width: 6),
          Text(
            'Học liên tiếp 4 ngày',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.rocket_launch, color: Colors.white, size: 36),
    );
  }

  Widget _buildLearningProgress() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: _buildCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                icon: Icons.timeline,
                title: 'Tiến độ học tập của bạn',
                trailing: AnimatedCounter(
                  count: 60,
                  duration: _progressAnimationDuration,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProgressIndicator(0.6),
              const SizedBox(height: 8),
              _buildAnimatedText(
                'Đã hoàn thành 60% lộ trình 🎯',
                duration: const Duration(milliseconds: 500),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              _buildProgressStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return TweenAnimationBuilder<double>(
      duration: _progressAnimationDuration,
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0.0, end: progress),
      builder: (context, value, child) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 12.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(
                  height: 12.0,
                  width: MediaQuery.of(context).size.width * value,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(value * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressStats() {
    final stats = [
      {
        'icon': Icons.library_books,
        'value': '12',
        'label': 'Bài đã học',
        'color': Colors.blue,
      },
      {
        'icon': Icons.timer,
        'value': '8h',
        'label': 'Thời gian',
        'color': Colors.orange,
      },
      {
        'icon': Icons.emoji_events,
        'value': '5',
        'label': 'Chứng chỉ',
        'color': Colors.purple,
      },
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < stats.length; i++)
            _buildAnimatedStatItem(
              icon: stats[i]['icon'] as IconData,
              value: stats[i]['value'] as String,
              label: stats[i]['label'] as String,
              color: stats[i]['color'] as Color,
              delay: i * 200,
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required int delay,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.elasticOut,
      transform: Matrix4.translationValues(0, _isProgressAnimated ? 0 : 50, 0),
      child: Opacity(
        opacity: _isProgressAnimated ? 1.0 : 0.0,
        child: Column(
          children: [
            _buildIconContainer(icon: icon, color: color.withAlpha(25)),
            const SizedBox(height: 8),
            AnimatedCounter(
              count: int.tryParse(value) ?? 0,
              duration: Duration(milliseconds: 1500 + delay),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            _buildAnimatedText(
              label,
              duration: Duration(milliseconds: 800 + delay),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTopics() {
    final topics = [
      {
        'name': 'Lập trình',
        'icon': Icons.code,
        'color': Colors.blue,
        'courses': 24,
      },
      {
        'name': 'Ngoại ngữ',
        'icon': Icons.language,
        'color': Colors.green,
        'courses': 18,
      },
      {
        'name': 'Kinh doanh',
        'icon': Icons.business,
        'color': Colors.orange,
        'courses': 15,
      },
      {
        'name': 'Khoa học dữ liệu',
        'icon': Icons.analytics,
        'color': Colors.purple,
        'courses': 12,
      },
      {
        'name': 'Thiết kế đồ họa',
        'icon': Icons.design_services,
        'color': Colors.pink,
        'courses': 20,
      },
      {
        'name': 'Kỹ năng mềm',
        'icon': Icons.people,
        'color': Colors.teal,
        'courses': 16,
      },
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.category,
              title: 'Chủ đề nổi bật',
              trailing: TextButton(
                onPressed: () {},
                child: Text(
                  'Xem tất cả',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: topics.length,
              itemBuilder: (context, index) =>
                  _buildAnimatedTopicCard(topics[index], index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTopicCard(Map<String, dynamic> topic, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.elasticOut,
      transform: Matrix4.translationValues(0, _isTopicsAnimated ? 0 : 100, 0),
      child: Opacity(
        opacity: _isTopicsAnimated ? 1.0 : 0.0,
        child: _buildTopicCard(topic),
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return GestureDetector(
      onTap: () => _showTopicSelected(context, topic['name']),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: _buildCardDecoration(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconContainer(
                icon: topic['icon'] as IconData,
                color: (topic['color'] as Color).withAlpha(25),
                size: 20,
              ),
              const SizedBox(height: 8),
              _buildAnimatedText(
                topic['name'],
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              _buildAnimatedText(
                '${topic['courses']} khóa',
                duration: const Duration(milliseconds: 400),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationalQuote() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.lightbulb_outline,
            title: 'Câu nói truyền cảm hứng hôm nay',
            iconColor: Colors.amber,
            textColor: Colors.purple.shade800,
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            child: Text(
              _currentQuote,
              key: ValueKey<String>(_currentQuote),
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: _buildAnimatedText(
              '~ Study Path ~',
              duration: const Duration(milliseconds: 400),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.assignment,
        'title': 'Bài tập',
        'subtitle': '2 bài chờ hoàn thành',
        'color': Colors.orange,
      },
      {
        'icon': Icons.quiz,
        'title': 'Kiểm tra',
        'subtitle': '1 bài test sắp tới',
        'color': Colors.purple,
      },
      {
        'icon': Icons.video_library,
        'title': 'Video',
        'subtitle': '5 video mới',
        'color': Colors.blue,
      },
      {
        'icon': Icons.forum,
        'title': 'Thảo luận',
        'subtitle': '3 cuộc thảo luận mới',
        'color': Colors.green,
      },
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(icon: Icons.flash_on, title: 'Hành động nhanh'),
            const SizedBox(height: 16),
            ..._buildQuickActionRows(actions),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuickActionRows(List<Map<String, dynamic>> actions) {
    return [
      for (var i = 0; i < actions.length; i += 2)
        Padding(
          padding: EdgeInsets.only(bottom: i + 2 < actions.length ? 12 : 0),
          child: Row(
            children: [
              for (var j = 0; j < 2 && i + j < actions.length; j++)
                Expanded(
                  child: _buildAnimatedQuickActionCard(
                    icon: actions[i + j]['icon'] as IconData,
                    title: actions[i + j]['title'] as String,
                    subtitle: actions[i + j]['subtitle'] as String,
                    color: actions[i + j]['color'] as Color,
                    delay: (i + j) * 200,
                  ),
                ),
              if (i + 1 < actions.length) const SizedBox(width: 12),
            ],
          ),
        ),
    ];
  }

  Widget _buildAnimatedQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required int delay,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.elasticOut,
      transform: Matrix4.translationValues(0, _isTopicsAnimated ? 0 : 50, 0),
      child: Opacity(
        opacity: _isTopicsAnimated ? 1.0 : 0.0,
        child: _buildQuickActionCard(
          icon: icon,
          title: title,
          subtitle: subtitle,
          color: color,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(16),
          decoration: _buildCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconContainer(
                icon: icon,
                color: color.withAlpha(25),
                size: 18,
                padding: const EdgeInsets.all(8),
              ),
              const SizedBox(height: 8),
              _buildAnimatedText(
                title,
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              _buildAnimatedText(
                subtitle,
                duration: const Duration(milliseconds: 400),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          elevation: 0,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Khám phá',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Lịch học',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color iconColor = Colors.teal,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildIconContainer(icon: icon, color: iconColor.withAlpha(25)),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor ?? Colors.grey.shade800,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
    double size = 24,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8),
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      padding: padding,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: _getIconColor(color), size: size),
    );
  }

  Color _getIconColor(Color backgroundColor) {
    final hsl = HSLColor.fromColor(backgroundColor);
    return hsl.lightness > 0.7 ? Colors.teal : Colors.white;
  }

  Widget _buildAnimatedText(
    String text, {
    required Duration duration,
    required TextStyle style,
    TextAlign textAlign = TextAlign.start,
  }) {
    return AnimatedDefaultTextStyle(
      duration: duration,
      style: style,
      child: Text(text, textAlign: textAlign),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  BoxDecoration _buildGradientBoxDecoration({
    required List<Color> colors,
    required Color shadowColor,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  // Dialog methods
  void _showTopicSelected(BuildContext context, String topicName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Bạn đã chọn: $topicName'),
          ],
        ),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.elasticOut,
        ),
        child: FadeTransition(
          opacity: ModalRoute.of(context)!.animation!,
          child: AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  'Thông báo',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNotificationItem(
                  'Bài học mới',
                  'Khóa học Lập trình Python đã có bài học mới',
                  Icons.library_books,
                  Colors.blue,
                ),
                _buildNotificationItem(
                  'Nhắc nhở học tập',
                  'Bạn có 2 bài tập cần hoàn thành',
                  Icons.assignment,
                  Colors.orange,
                ),
                _buildNotificationItem(
                  'Thành tích',
                  'Chúc mừng! Bạn đã hoàn thành cấp độ Beginner',
                  Icons.emoji_events,
                  Colors.amber,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  content,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ..._buildProfileMenuItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileMenuItems() {
    final items = [
      {'icon': Icons.person, 'title': 'Hồ sơ cá nhân', 'color': Colors.teal},
      {'icon': Icons.settings, 'title': 'Cài đặt', 'color': Colors.teal},
      {'icon': Icons.help, 'title': 'Trợ giúp', 'color': Colors.teal},
      {'icon': Icons.logout, 'title': 'Đăng xuất', 'color': Colors.red},
    ];

    return [
      for (var i = 0; i < items.length; i++)
        _buildAnimatedProfileMenuItem(
          icon: items[i]['icon'] as IconData,
          title: items[i]['title'] as String,
          color: items[i]['color'] as Color,
          delay: i * 100,
        ),
    ];
  }

  Widget _buildAnimatedProfileMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required int delay,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, _isTopicsAnimated ? 0 : 50, 0),
      child: Opacity(
        opacity: _isTopicsAnimated ? 1.0 : 0.0,
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: GoogleFonts.poppins()),
          onTap: () {},
        ),
      ),
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final int count;
  final Duration duration;
  final TextStyle style;

  const AnimatedCounter({
    super.key,
    required this.count,
    required this.duration,
    required this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = IntTween(
      begin: 0,
      end: widget.count,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _animation = IntTween(
        begin: oldWidget.count,
        end: widget.count,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text('${_animation.value}', style: widget.style);
      },
    );
  }
}
