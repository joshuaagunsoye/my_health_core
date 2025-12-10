// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:my_health_core/pages/landing_page.dart';
import 'package:my_health_core/providers/theme_provider.dart';
import 'firebase_options.dart';
import 'package:my_health_core/pages/forget_password_page.dart';
import 'package:my_health_core/pages/home_page.dart';
import 'package:my_health_core/pages/login_page.dart';
import 'package:my_health_core/pages/signup_page.dart';
import 'package:my_health_core/pages/multistep_signup_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';

// Main Featured Pages
import 'package:my_health_core/pages/my_health_education_page.dart';
import 'package:my_health_core/pages/my_health_connect_page.dart';
import 'package:my_health_core/pages/my_health_locator_page.dart';
import 'package:my_health_core/pages/my_health_tracker_page.dart';

// MyHealthConnect
import 'package:my_health_core/pages/MyHealthConnect/chat_page.dart';
import 'package:my_health_core/pages/MyHealthConnect/select_provider_page.dart';
import 'package:my_health_core/pages/MyHealthConnect/main_chat_with_service_provider_page.dart';
import 'package:my_health_core/pages/MyHealthConnect/main_chat_with_peer_page.dart';
import 'package:my_health_core/pages/MyHealthConnect/main_community_stories_page.dart';

// MyHealthLocator
import 'package:my_health_core/pages/MyHealthLocator/locate_aso_page.dart';
import 'package:my_health_core/pages/MyHealthLocator/locate_community_based_organisation_page.dart';
import 'package:my_health_core/pages/MyHealthLocator/locate_hiv_test_page.dart';
import 'package:my_health_core/pages/MyHealthLocator/locate_prep_clinic_page.dart';

// MyHealthTracker
import 'package:my_health_core/pages/MyHealthTracker/test_tracker_page.dart';
import 'package:my_health_core/pages/MyHealthTracker/appointment_tracker_page.dart';
import 'package:my_health_core/pages/MyHealthTracker/medication_tracker_page.dart';
import 'package:my_health_core/pages/MyHealthTracker/symptom_tracker_page.dart';
import 'package:my_health_core/pages/MyHealthTracker/mentalhealth_tracker_page.dart';
import 'package:my_health_core/pages/MyHealthTracker/mentalhealth_journal_page.dart';

// MyHealthEducation
import 'package:my_health_core/pages/MyHealthEducation/hiv_101_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/testing_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/prevention_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/prep_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/treatment_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/how_tos_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/open_core_quiz_page.dart';
// Less priority
import 'package:my_health_core/pages/MyHealthEducation/hiv_and_ageing_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/hiv_and_disability_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/hiv_and_pregnancy_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/hiv_care_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/hiv_disclosure_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/hiv_stigma_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/sdoh_and_hiv_page.dart';
import 'package:my_health_core/pages/MyHealthEducation/sexual_health_page.dart';
import 'package:my_health_core/pages/profile_page.dart';
import 'package:my_health_core/pages/saved_page.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the onboarding page
import 'package:my_health_core/pages/onboarding_page.dart'; // Make sure this path is correct
import 'package:my_health_core/pages/welcome_page.dart';
import 'package:my_health_core/pages/auth_wrapper.dart';
import 'package:my_health_core/pages/terms_and_conditions_page.dart';
import 'package:my_health_core/widgets/notification_service.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone data
  tz_data.initializeTimeZones();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    ),
  );
  await notificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Schedule daily reminders (2 notifications per day)
  await NotificationService.scheduleDailyReminders();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/welcome': (context) => WelcomePage(),
        '/home': (context) => HomePage(),
        '/saved': (context) => SavedPage(),
        '/profile': (context) => ProfilePage(),
        '/signup': (context) => MultiStepSignUpPage(),
        '/signin': (context) => LoginPage(),
        '/forget_password': (context) => ForgetPasswordPage(),
        '/terms_and_conditions': (context) => TermsAndConditionsPage(),
        '/onboarding': (context) => OnboardingPage(), // Add onboarding route

        '/my_health_education': (context) => MyHealthEducationPage(),
        '/my_health_connect': (context) => MyHealthConnectPage(),
        '/my_health_locator': (context) => MyHealthLocatorPage(),
        '/my_health_tracker': (context) => MyHealthTrackerPage(),

        // ... all your other routes remain the same ...
        // MyHealthEducation
        '/hiv_101': (context) => HIV101Page(),
        '/testing': (context) => TestingPage(),
        '/prevention': (context) => PreventionPage(),
        '/prep': (context) => PrePPage(),
        '/treatment': (context) => TreatmentPage(),
        '/how_tos': (context) => HowTosPage(),
        '/open_core_quiz': (context) => OpenCoreQuizPage(),
        '/hiv_disclosure': (context) => HIVDisclosurePage(),
        '/hiv_and_ageing': (context) => HIVAndAgeingPage(),
        '/hiv_and_disability': (context) => HIVAndDisabilityPage(),
        '/hiv_and_pregnancy': (context) => HIVAndPregnancyPage(),
        '/hiv_stigma': (context) => HIVStigmaPage(),
        '/sexual_health': (context) => SexualHealthPage(),
        '/sdoh_and_hiv': (context) => SDOHAndHIVPage(),
        '/hiv_care': (context) => HIVCarePage(),

        // MyHealthConnect
        '/main_community_stories': (context) => MainCommunityStoriesPage(),
        '/main_chat_with_service_provider': (context) =>
            MainChatWithServiceProviderPage(),
        '/main_chat_with_peer': (context) => MainChatWithPeerPage(),
        '/chat_with_service_provider': (context) => ChatPage(),
        '/select_a_service_provider': (context) => SelectProviderPage(),

        // MyHealthLocator
        '/locate_aso': (context) => LocateASOPage(),
        '/locate_hiv_test': (context) => LocateHIVTestPage(),
        '/locate_prep_clinic': (context) => LocatePrepClinicPage(),
        '/locate_community_based_organisation': (context) =>
            LocateCommunityBasedOrganisationPage(),

        // MyHealthTracker
        '/test_tracker': (context) => TestTrackerPage(),
        '/medication_tracker': (context) => MedicationTrackerPage(),
        '/appointment_tracker': (context) => AppointmentTrackerPage(),
        '/symptom_tracker': (context) => SymptomTrackerPage(),
        '/mentalhealth_tracker': (context) => MentalHealthTrackerPage(),
        '/mentalhealth_journal': (context) => MentalHealthJournalPage(),
      },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightModeBackground,
      colorScheme: ColorScheme.light(
        primary: AppColors.lightModeButton,
        secondary: AppColors.lightModeAccent,
        surface: AppColors.lightModeSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightModeButton,
        foregroundColor: AppColors.lightModeText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightModeButton,
          foregroundColor: AppColors.lightModeText,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkModeBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkModeButton,
        secondary: AppColors.darkModeAccent,
        surface: AppColors.darkModeSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkModeSurface,
        foregroundColor: AppColors.darkModeText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkModeButton,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkModeText),
        bodyMedium: TextStyle(color: AppColors.darkModeText),
        bodySmall: TextStyle(color: AppColors.darkModeText),
      ),
    );
  }
}
