import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = AppConstants.defaultLanguage;
  bool _isLoading = false;

  String get currentLanguage => _currentLanguage;
  bool get isLoading => _isLoading;

  Locale get currentLocale => Locale(_currentLanguage);

  bool get isEnglish => _currentLanguage == 'en';
  bool get isTelugu => _currentLanguage == 'te';
  bool get isHindi => _currentLanguage == 'hi';
  bool get isBengali => _currentLanguage == 'bn';
  bool get isMalayalam => _currentLanguage == 'ml';
  bool get isKannada => _currentLanguage == 'kn';
  bool get isTamil => _currentLanguage == 'ta';
  bool get isPunjabi => _currentLanguage == 'pa';

  String get currentLanguageName =>
      AppConstants.languageNames[_currentLanguage] ?? 'English';

  Future<void> resetToDefault() async {
    _currentLanguage = AppConstants.defaultLanguage;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserLanguage, _currentLanguage);
    } catch (e) {
      debugPrint('Error resetting language: $e');
    }
    notifyListeners();
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage =
          prefs.getString(AppConstants.keyUserLanguage) ??
          AppConstants.defaultLanguage;
    } catch (e) {
      debugPrint('Error initializing language: $e');
      _currentLanguage = AppConstants.defaultLanguage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!AppConstants.supportedLanguages.contains(languageCode)) {
      debugPrint('Unsupported language: $languageCode');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserLanguage, languageCode);
      _currentLanguage = languageCode;
    } catch (e) {
      debugPrint('Error changing language: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getSpeechLocale() {
    switch (_currentLanguage) {
      case 'te':
        return AppConstants.localeTelugu;
      case 'hi':
        return AppConstants.localeHindi;
      case 'bn':
        return AppConstants.localeBengali;
      case 'ml':
        return AppConstants.localeMalayalam;
      case 'kn':
        return AppConstants.localeKannada;
      case 'ta':
        return AppConstants.localeTamil;
      case 'pa':
        return AppConstants.localePunjabi;
      case 'en':
      default:
        return AppConstants.localeEnglish;
    }
  }

  TextStyle getTextStyle(TextStyle baseStyle) {
    return baseStyle;
  }
}
