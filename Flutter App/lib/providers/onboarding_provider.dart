import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../services/onboarding_storage_service.dart';

class OnboardingProvider with ChangeNotifier {
  bool _isCompleted = false;
  int _currentStep = 0;
  bool _isLoading = false;

  bool get isCompleted => _isCompleted;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isCompleted =
          prefs.getBool(AppConstants.keyIsOnboardingCompleted) ?? false;
    } catch (e) {
      debugPrint('Error initializing onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkOnboardingStatus() async {
    await initialize();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding([Map<String, dynamic>? formData]) async {
    _isLoading = true;
    notifyListeners();

    try {
      final storageService = OnboardingStorageService();

      await storageService.setOnboardingCompleted(true);

      if (formData != null) {
        await storageService.saveOnboardingData(formData);

        final prefs = await SharedPreferences.getInstance();
        if (formData['name'] != null) {
          await prefs.setString(AppConstants.keyUserName, formData['name']);
        }
        if (formData['email'] != null) {
          await prefs.setString(AppConstants.keyUserEmail, formData['email']);
        }
        if (formData['phone'] != null) {
          await prefs.setString(AppConstants.keyUserPhone, formData['phone']);
        }
      }

      _isCompleted = true;
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final storageService = OnboardingStorageService();
      await storageService.clearOnboardingData();
      _isCompleted = false;
      _currentStep = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting onboarding: $e');
    }
  }
}
