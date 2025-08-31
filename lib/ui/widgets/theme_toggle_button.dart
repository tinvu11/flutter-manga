import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            _getThemeIcon(themeManager.themeMode),
            color: Theme.of(context).iconTheme.color,
          ),
          onSelected: (ThemeMode themeMode) {
            themeManager.setThemeMode(themeMode);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.brightness_auto,
                    color: themeManager.isSystemMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'System',
                    style: TextStyle(
                      color: themeManager.isSystemMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeManager.isSystemMode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: themeManager.isLightMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Light',
                    style: TextStyle(
                      color: themeManager.isLightMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeManager.isLightMode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: themeManager.isDarkMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Dark',
                    style: TextStyle(
                      color: themeManager.isDarkMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeManager.isDarkMode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
