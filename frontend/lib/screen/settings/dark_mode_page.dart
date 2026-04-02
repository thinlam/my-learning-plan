import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

class DarkModePage extends StatelessWidget {
  const DarkModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Chế độ tối")),
      body: Column(
        children: [
          _option(
            context,
            icon: Icons.light_mode,
            title: "Sáng",
            value: ThemeMode.light,
            group: theme.themeMode,
          ),
          _option(
            context,
            icon: Icons.dark_mode,
            title: "Tối",
            value: ThemeMode.dark,
            group: theme.themeMode,
          ),
          _option(
            context,
            icon: Icons.phone_android,
            title: "Theo hệ thống",
            value: ThemeMode.system,
            group: theme.themeMode,
          ),
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context, {
    required IconData icon,
    required String title,
    required ThemeMode value,
    required ThemeMode group,
  }) {
    return RadioListTile<ThemeMode>(
      value: value,
      groupValue: group,
      onChanged: (v) => context.read<ThemeProvider>().setTheme(v!),
      secondary: Icon(icon),
      title: Text(title),
    );
  }
}
