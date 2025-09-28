import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

class OnboardingStorageService {
  static const String _onboardingCompletedKey =
      AppConstants.keyIsOnboardingCompleted;
  static const String _onboardingDataKey = AppConstants.keyOnboardingData;

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  Future<void> saveOnboardingData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(data);
    await prefs.setString(_onboardingDataKey, jsonData);
  }

  Future<Map<String, dynamic>> getOnboardingData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_onboardingDataKey);
      if (jsonData != null && jsonData.isNotEmpty) {
        return jsonDecode(jsonData);
      }
      return {};
    } catch (e) {
      debugPrint('Error decoding onboarding data: $e');
      return {};
    }
  }

  Future<void> updateOnboardingAnswer(String key, dynamic value) async {
    final currentData = await getOnboardingData();
    currentData[key] = value;
    await saveOnboardingData(currentData);
  }

  Future<void> clearOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingDataKey);
    await prefs.remove(_onboardingCompletedKey);
  }

  Future<dynamic> getOnboardingAnswer(String key) async {
    final data = await getOnboardingData();
    return data[key];
  }
}
