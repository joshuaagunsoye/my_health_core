import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  static const lightModeBackground = Color(0xFFE0F7F7); // Light Mint
  static const lightModeSurface = Color(0xFFFFFFFF); // White
  static const lightModeText = Color(0xFF000000); // Black
  static const lightModeButton = Color(0xFFB2DFDB); // Pale Mint
  static const lightModeAccent = Color(0xFF00A896); // Rich Teal
  
  // Dark Mode Colors
  static const darkModeBackground = Color(0xFF121212); // Dark Gray
  static const darkModeSurface = Color(0xFF272727); // Darker Gray
  static const darkModeText = Color(0xFFFFFFFF); // White for better visibility
  static const darkModeButton = Color(0xFF00A896); // Rich Teal
  static const darkModeAccent = Color(0xFFB2EBF2); // Light Teal

  // Theme-aware getters
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeBackground
        : lightModeBackground;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeSurface
        : lightModeSurface;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeText
        : lightModeText;
  }

  static Color getButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeButton
        : lightModeButton;
  }

  static Color getAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeAccent
        : lightModeAccent;
  }

  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF00A896).withOpacity(0.2) // Teal with opacity for dark mode
        : mintGreen; // Mint green (#94D1C5) for light mode
  }

  static const lightTeal = Color(0xFFEDF7F6);
  static const mintGreen = Color(0xFF94D1C5);
  static const mintGreen60 = Color(0x94D1C566);
  // static const selected = Color(0xFF94D1C5);
  // static const optionBg = Color(0xFF94D1C3);
  static const Color selected = Color(0xFF00C853);   // Example green
  // static const Color correct = Color(0xFF4CAF50);    // Example darker green
  // static const Color incorrect = Color(0xFFE53935);  // Example red








  static const primary = Color(0xffFBD512);
  static const font = Color(0xFFFBE5B6); //bananaMania
  static const font2 = Color(0xFFF8B735);
  static const font3 = Color.fromARGB(255, 30, 30, 30);
  static const disabledFont = Color(0xffA7A7A7);
  static const disabledButton = Color(0xff303030);
  // static const background = Color.fromARGB(255, 0, 0, 0); //chocolateCosmos
  static const background = Color(0xFF94D1C5); //chocolateCosmos
  static const black = Color(0xff000000);
  static const white = Color(0xffffffff);
  static const yellow = Color(0xFFFFFF00);
  static const blue = Color(0xFF0000FF);
  static const indigo = Color(0xFF561217);
  // static const Color selected = Color(0xFF2196F3);
  static const carousel_background = Color(0xFFF8B735); //saffron

  static const buttonDisplay = Color(0xFFFBE5B6); //bananamania

  static const myHealthConnectBar = Color(0xFFF8B735); //saffron

  static const appbarHeading = Color(0xFF94D1C5);
  static const chocolateCosmos = Color(0xFF561217);
  static const bananaMania = Color(0xFFFBE5B6);
  // static const saffron = Color(0xFFF8B735);
  static const saffron = Color(0xFF94D1C5); // every safrron is mintgreen
  static const beer = Color(0xFFF38218);

  // static const myrtleGreen = Color(0xFF2C6E63);
  static const myrtleGreen = Color(0xFF007A4D);
  // static const backgroundGreen = Color(0xFF2C6E63);
  static const backgroundGreen = Color(0xFF94D1C5); // every backgroundgreen is mintgreen
  static const bottomNavigation = Color(0xFF007A4D);

  //new pallet
  // static const black = Color(0xFF000000); // Black
  static const gold = Color(0xFFFFB612); // Gold
  // static const myrtleGreen = Color(0xFF007A4D); // Myrtle Green
  static const red = Color(0xFFDE3831); // Red
  static const navyBlue = Color(0xFF002395); // Navy Blue

  static const correct = Color(0xFF4CAF50);
  static const incorrect = Color(0xFF607D8B);


}
