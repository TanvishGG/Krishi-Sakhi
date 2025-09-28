import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/language_provider.dart';
import 'providers/voice_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/crop_recommendation_provider.dart';
import 'providers/yield_prediction_provider.dart';
import 'providers/disease_detection_provider.dart';
import 'providers/pest_detection_provider.dart';
import 'providers/fertilizer_recommendation_provider.dart';
import 'providers/schemes_loans_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const KrishiSakhiApp());
}

class KrishiSakhiApp extends StatelessWidget {
  const KrishiSakhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CropRecommendationProvider()),
        ChangeNotifierProvider(create: (_) => YieldPredictionProvider()),
        ChangeNotifierProvider(create: (_) => DiseaseDetectionProvider()),
        ChangeNotifierProvider(create: (_) => PestDetectionProvider()),
        ChangeNotifierProvider(
          create: (_) => FertilizerRecommendationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => SchemesLoansProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Krishi Sakhi',
            theme: AppTheme.lightTheme,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppConstants.supportedLanguages
                .map((languageCode) => Locale(languageCode))
                .toList(),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
