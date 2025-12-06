import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_health_core/providers/theme_provider.dart';
import 'package:my_health_core/styles/app_colors.dart';

class DarkModeToggle extends StatelessWidget {
  const DarkModeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: isDark ? AppColors.darkModeText : AppColors.lightModeText,
      ),
      onPressed: () => themeProvider.toggleTheme(),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.light_mode,
          size: 20,
          color: isDark ? Colors.grey : AppColors.lightModeAccent,
        ),
        Switch(
          value: isDark,
          onChanged: (value) => themeProvider.toggleTheme(),
          activeColor: AppColors.darkModeButton,
          inactiveThumbColor: AppColors.lightModeButton,
        ),
        Icon(
          Icons.dark_mode,
          size: 20,
          color: isDark ? AppColors.darkModeAccent : Colors.grey,
        ),
      ],
    );
  }
}
