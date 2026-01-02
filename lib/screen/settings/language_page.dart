import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../../core/locale/locale_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    final current = provider.locale.languageCode;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Ngôn ngữ",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn ngôn ngữ hiển thị",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "Ngôn ngữ sẽ được áp dụng cho toàn bộ ứng dụng",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            _languageTile(
              context,
              code: 'vi',
              flag: '🇻🇳',
              title: 'Tiếng Việt',
              subtitle: 'Vietnamese',
              current: current,
            ),
            _languageTile(
              context,
              code: 'en',
              flag: '🇺🇸',
              title: 'English',
              subtitle: 'English',
              current: current,
            ),
            _languageTile(
              context,
              code: 'ja',
              flag: '🇯🇵',
              title: '日本語',
              subtitle: 'Japanese',
              current: current,
            ),
            _languageTile(
              context,
              code: 'ko',
              flag: '🇰🇷',
              title: '한국어',
              subtitle: 'Korean',
              current: current,
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageTile(
    BuildContext context, {
    required String code,
    required String flag,
    required String title,
    required String subtitle,
    required String current,
  }) {
    final isSelected = code == current;

    return InkWell(
      onTap: () {
        context.read<LocaleProvider>().setLocale(code);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.transparent,
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.purple,
                      key: ValueKey(true),
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.grey,
                      key: ValueKey(false),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
