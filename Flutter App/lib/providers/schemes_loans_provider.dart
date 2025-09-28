import 'package:flutter/material.dart';
import '../models/eligibility_model.dart';
import '../services/schemes_loans_service.dart';

class SchemesLoansProvider with ChangeNotifier {
  final SchemesLoansService _service = SchemesLoansService();

  bool _isLoading = false;
  EligibilityResult? _eligibilityResult;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  EligibilityResult? get eligibilityResult => _eligibilityResult;
  String? get errorMessage => _errorMessage;

  Future<void> checkEligibility() async {
    _isLoading = true;
    _errorMessage = null;
    _eligibilityResult = null;
    notifyListeners();

    try {
      _eligibilityResult = await _service.checkEligibility();
    } catch (e) {
      _errorMessage = e.toString();
      print('Provider Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _eligibilityResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  Color getEligibilityStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'likely eligible':
        return Colors.green;
      case 'potentially eligible':
        return Colors.orange;
      case 'need more information':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getEligibilityStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'likely eligible':
        return Icons.check_circle;
      case 'potentially eligible':
        return Icons.info;
      case 'need more information':
        return Icons.help_outline;
      default:
        return Icons.help;
    }
  }
}
