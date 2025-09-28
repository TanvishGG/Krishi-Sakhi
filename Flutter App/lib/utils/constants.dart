class AppConstants {
  // API URLs
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String appName = 'Krishi Sakhi';
  static const String appVersion = '1.0.0';

  static const String keyIsOnboardingCompleted = 'isOnboardingCompleted';
  static const String keyOnboardingData = 'onboardingData';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUserLanguage = 'userLanguage';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserPhone = 'userPhone';
  static const String keyUserName = 'userName';

  static const String baseUrl = 'https://tunnel-8000.tanvish.co.in/';
  static const String chatEndpoint = '/chat';
  static const String authEndpoint = '/auth';

  static const String localeEnglish = 'en_US';
  static const String localeTelugu = 'te_IN';
  static const String localeHindi = 'hi_IN';
  static const String localeBengali = 'bn_IN';
  static const String localeMalayalam = 'ml_IN';
  static const String localeKannada = 'kn_IN';
  static const String localeTamil = 'ta_IN';
  static const String localePunjabi = 'pa_IN';

  static const List<String> supportedLanguages = [
    'en',
    'te',
    'hi',
    'bn',
    'ml',
    'kn',
    'ta',
    'pa',
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'te': 'తెలుగు',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
    'ml': 'മലയാളം',
    'kn': 'ಕನ್ನಡ',
    'ta': 'தமிழ்',
    'pa': 'ਪੰਜਾਬੀ',
  };

  static const String defaultLanguage = 'en';
  static const int maxMessageLength = 500;
  static const int speechTimeoutDuration = 30;

  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  static const double maxMobileWidth = 480;
  static const double maxTabletWidth = 768;

  static const double minConfidenceThreshold = 0.3;
  static const int maxRecordingDuration = 60;
}
