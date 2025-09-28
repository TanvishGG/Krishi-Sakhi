import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/onboarding_storage_service.dart';
import '../widgets/language_selector.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, dynamic> _formData = {};
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _landAreaController = TextEditingController();
  final TextEditingController _typesOfCropsController = TextEditingController();
  final TextEditingController _fertilizersController = TextEditingController();
  final TextEditingController _irrigationController = TextEditingController();
  final TextEditingController _numberOfCropsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();

    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        debugPrint('Fallback timeout triggered for settings loading');
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _localityController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _landAreaController.dispose();
    _typesOfCropsController.dispose();
    _fertilizersController.dispose();
    _irrigationController.dispose();
    _numberOfCropsController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    try {
      final storageService = OnboardingStorageService();
      final existingData = await storageService.getOnboardingData().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('Timeout loading onboarding data');
          return {};
        },
      );
      if (mounted) {
        setState(() {
          _formData.addAll(existingData);
          final languageProvider = context.read<LanguageProvider>();
          _formData['language'] = languageProvider.currentLanguage;
          _isLoading = false;
        });

        _updateControllers();
      }
    } catch (e) {
      debugPrint('Error loading onboarding data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateControllers() {
    _nameController.text = _formData['name']?.toString() ?? '';
    _localityController.text = _formData['locality']?.toString() ?? '';
    _emailController.text = _formData['email']?.toString() ?? '';
    _phoneController.text = _formData['phone']?.toString() ?? '';
    _landAreaController.text = _formData['landArea']?.toString() ?? '';
    _typesOfCropsController.text = _formData['typesOfCrops']?.toString() ?? '';
    _fertilizersController.text =
        _formData['fertilizersAndChemicals']?.toString() ?? '';
    _irrigationController.text =
        _formData['sourceOfIrrigation']?.toString() ?? '';
    _numberOfCropsController.text =
        _formData['numberOfCrops']?.toString() ?? '';
  }

  void _handleInputChange(String field, dynamic value) async {
    setState(() {
      _formData[field] = value;
    });

    if (field == 'language' && value != null) {
      try {
        final languageProvider = context.read<LanguageProvider>();
        await languageProvider.changeLanguage(value);
      } catch (e) {
        debugPrint('Error changing language in settings: $e');
      }
    }
  }

  Future<void> _saveChanges() async {
    final storageService = OnboardingStorageService();
    await storageService.saveOnboardingData(_formData);
    if (mounted) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.profileUpdatedSuccessfully)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      body: Consumer2<AuthProvider, LanguageProvider>(
        builder: (context, authProvider, languageProvider, child) {
          final user = authProvider.user;
          final localizations = AppLocalizations.of(context)!;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          localizations.settings,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8DB87A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user?.phone != null
                        ? localizations.loggedInAs(user!.phone!)
                        : localizations.loggedIn,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.profileInformation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          localizations.fullName,
                          'name',
                          localizations.enterYourName,
                          languageProvider,
                        ),
                        _buildTextField(
                          localizations.locality,
                          'locality',
                          localizations.enterYourLocality,
                          languageProvider,
                        ),
                        _buildTextField(
                          localizations.email,
                          'email',
                          localizations.enterYourEmail,
                          languageProvider,
                        ),
                        _buildTextField(
                          localizations.phone,
                          'phone',
                          localizations.enterYourPhone,
                          languageProvider,
                        ),

                        const SizedBox(height: 24),

                        Text(
                          localizations.farmInformation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildTextField(
                          localizations.landArea,
                          'landArea',
                          localizations.enterLandArea,
                          languageProvider,
                        ),
                        _buildTextField(
                          localizations.typesOfCrops,
                          'typesOfCrops',
                          localizations.enterTypesOfCrops,
                          languageProvider,
                          multiline: true,
                        ),
                        _buildTextField(
                          localizations.fertilizersAndChemicals,
                          'fertilizersAndChemicals',
                          localizations.enterFertilizersAndChemicals,
                          languageProvider,
                          multiline: true,
                        ),
                        _buildTextField(
                          localizations.sourceOfIrrigation,
                          'sourceOfIrrigation',
                          localizations.enterSourceOfIrrigation,
                          languageProvider,
                        ),
                        _buildTextField(
                          localizations.numberOfCrops,
                          'numberOfCrops',
                          localizations.enterNumberOfCrops,
                          languageProvider,
                        ),

                        const SizedBox(height: 24),

                        Text(
                          localizations.preferences,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildPickerField(
                          localizations.communicationPreference,
                          'preference',
                          [
                            {'label': localizations.textChat, 'value': 'text'},
                            {'label': localizations.voice, 'value': 'voice'},
                          ],
                          languageProvider,
                        ),

                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 1,
                              ),
                            ),
                            child: LanguageSelector(
                              onLanguageChanged: () {
                                setState(() {
                                  _formData['language'] = context
                                      .read<LanguageProvider>()
                                      .currentLanguage;
                                });
                              },
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: _saveChanges,
                                icon: const Icon(Icons.save),
                                label: Text(localizations.saveChanges),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D5016),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _showLogoutDialog(context, authProvider),
                                icon: const Icon(Icons.logout),
                                label: Text(localizations.logout),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC85A54),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String field,
    String placeholder,
    LanguageProvider languageProvider, {
    bool multiline = false,
  }) {
    TextEditingController? controller;
    switch (field) {
      case 'name':
        controller = _nameController;
        break;
      case 'locality':
        controller = _localityController;
        break;
      case 'email':
        controller = _emailController;
        break;
      case 'phone':
        controller = _phoneController;
        break;
      case 'landArea':
        controller = _landAreaController;
        break;
      case 'typesOfCrops':
        controller = _typesOfCropsController;
        break;
      case 'fertilizersAndChemicals':
        controller = _fertilizersController;
        break;
      case 'sourceOfIrrigation':
        controller = _irrigationController;
        break;
      case 'numberOfCrops':
        controller = _numberOfCropsController;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            onChanged: (value) => _handleInputChange(field, value),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(color: Color(0xFF999999)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF8DB87A)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            maxLines: multiline ? 3 : 1,
            keyboardType: field == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerField(
    String label,
    String field,
    List<Map<String, dynamic>> options,
    LanguageProvider languageProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: options.map((option) {
              final isSelected = _formData[field] == option['value'];
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _handleInputChange(field, option['value']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? const Color(0xFF8DB87A)
                          : Colors.white,
                      foregroundColor: isSelected
                          ? Colors.white
                          : const Color(0xFF333333),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      option['label'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.logout, style: AppTheme.h3),
          content: Text(
            localizations.areYouSureYouWantToLogout,
            style: AppTheme.body1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                localizations.cancel,
                style: AppTheme.body1.copyWith(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
              ),
              child: Text(
                localizations.logout,
                style: AppTheme.body1.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
