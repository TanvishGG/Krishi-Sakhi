import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

      if (_isLoggedIn) {
        final email = prefs.getString(AppConstants.keyUserEmail);
        final phone = prefs.getString(AppConstants.keyUserPhone);
        final name = prefs.getString(AppConstants.keyUserName);

        if (email != null || phone != null) {
          _user = User(email: email, phone: phone, name: name);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize auth: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (email.isNotEmpty &&
          password.length >= AppConstants.minPasswordLength) {
        _user = User(
          id: '1',
          email: email,
          name: email.split('@').first,
          createdAt: DateTime.now(),
        );

        _isLoggedIn = true;
        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String mobile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (mobile.isNotEmpty && mobile.length == 10) {
        _user = User(
          id: '1',
          phone: mobile,
          name: 'User',
          createdAt: DateTime.now(),
        );

        _isLoggedIn = true;
        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid mobile number';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithPhone(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (phone.isNotEmpty && otp == '123456') {
        _user = User(
          id: '1',
          phone: phone,
          name: 'User',
          createdAt: DateTime.now(),
        );

        _isLoggedIn = true;
        await _saveUserData();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyIsLoggedIn);
      await prefs.remove(AppConstants.keyUserEmail);
      await prefs.remove(AppConstants.keyUserPhone);
      await prefs.remove(AppConstants.keyUserName);

      _user = null;
      _isLoggedIn = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserData() async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);

      if (_user!.email != null) {
        await prefs.setString(AppConstants.keyUserEmail, _user!.email!);
      }
      if (_user!.phone != null) {
        await prefs.setString(AppConstants.keyUserPhone, _user!.phone!);
      }
      if (_user!.name != null) {
        await prefs.setString(AppConstants.keyUserName, _user!.name!);
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
