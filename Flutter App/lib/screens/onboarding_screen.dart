import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/onboarding_provider.dart';
import '../services/onboarding_storage_service.dart';
import '../widgets/language_selector.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  final Map<String, dynamic> _formData = {};
  final TextEditingController _textController = TextEditingController();
  bool _isInitializing = true;

  final List<Map<String, dynamic>> _questions = [
    {'id': 'language', 'titleKey': 'language', 'type': 'language_picker'},
    {
      'id': 'name',
      'titleKey': 'questionName',
      'placeholderKey': 'questionName',
      'type': 'text',
    },
    {
      'id': 'locality',
      'titleKey': 'questionLocality',
      'placeholderKey': 'questionLocality',
      'type': 'text',
    },
    {
      'id': 'landArea',
      'titleKey': 'questionLandArea',
      'placeholderKey': 'questionLandArea',
      'type': 'text',
    },
    {
      'id': 'typesOfCrops',
      'titleKey': 'questionTypesOfCrops',
      'placeholderKey': 'questionTypesOfCrops',
      'type': 'text',
    },
    {
      'id': 'fertilizersAndChemicals',
      'titleKey': 'questionFertilizersAndChemicals',
      'placeholderKey': 'questionFertilizersAndChemicals',
      'type': 'text',
    },
    {
      'id': 'sourceOfIrrigation',
      'titleKey': 'questionSourceOfIrrigation',
      'placeholderKey': 'questionSourceOfIrrigation',
      'type': 'text',
    },
    {
      'id': 'numberOfCrops',
      'titleKey': 'questionNumberOfCrops',
      'placeholderKey': 'questionNumberOfCrops',
      'type': 'text',
    },
    {
      'id': 'preference',
      'titleKey': 'communicationPreference',
      'type': 'picker',
      'options': [
        {'labelKey': 'textChat', 'value': 'text'},
        {'labelKey': 'voice', 'value': 'voice'},
      ],
    },
  ];

  void _handleInputChange(String field, dynamic value) async {
    setState(() {
      _formData[field] = value;
    });

    if (_isInitializing) {
      debugPrint(
        'Skipping input change during initialization: $field = $value',
      );
      return;
    }

    final storageService = OnboardingStorageService();
    await storageService.updateOnboardingAnswer(field, value);

    if (field == 'language' &&
        value != null &&
        AppConstants.supportedLanguages.contains(value)) {
      try {
        final languageProvider = context.read<LanguageProvider>();
        await languageProvider.changeLanguage(value);
        debugPrint('User changed language to: $value');
      } catch (e) {
        debugPrint('Error changing language during onboarding: $e');
      }
    }
  }

  void _updateControllerForCurrentStep() {
    final question = _questions[_currentStep];
    final currentValue = _formData[question['id']] ?? '';
    _textController.text = currentValue.toString();
  }

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    final storageService = OnboardingStorageService();
    final existingData = await storageService.getOnboardingData();

    final currentAppLanguage = context.read<LanguageProvider>().currentLanguage;

    setState(() {
      _formData.addAll(existingData);

      if (currentAppLanguage != 'en' &&
          AppConstants.supportedLanguages.contains(currentAppLanguage)) {
        _formData['language'] = currentAppLanguage;
        debugPrint(
          'Using current app language for onboarding: $currentAppLanguage',
        );
      } else if (_formData['language'] != null &&
          AppConstants.supportedLanguages.contains(_formData['language'])) {
        debugPrint(
          'Loaded existing onboarding language: ${_formData['language']}',
        );
      } else {
        _formData['language'] = 'en';
        debugPrint('Set default language to English for onboarding');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final finalLanguage = _formData['language'] ?? 'en';

      if (currentAppLanguage != finalLanguage) {
        await _syncLanguageWithProvider(finalLanguage);
      }

      await storageService.updateOnboardingAnswer('language', finalLanguage);

      setState(() {
        _isInitializing = false;
      });
      debugPrint(
        'Onboarding initialization complete with language: $finalLanguage',
      );
    });

    _updateControllerForCurrentStep();
  }

  Future<void> _syncLanguageWithProvider(String languageCode) async {
    try {
      final languageProvider = context.read<LanguageProvider>();
      if (languageProvider.currentLanguage != languageCode) {
        await languageProvider.changeLanguage(languageCode);
        debugPrint('Synced app language to: $languageCode');
      }
    } catch (e) {
      debugPrint('Error syncing language with provider: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final question = _questions[_currentStep];
    String value = '';

    if (question['type'] == 'picker' || question['type'] == 'language_picker') {
      value = _formData[question['id']] ?? '';
    } else {
      value = _textController.text.trim();
    }

    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pleaseFillField ??
                'Please fill this field.',
          ),
        ),
      );
      return;
    }

    if (question['type'] != 'picker' && question['type'] != 'language_picker') {
      _handleInputChange(question['id'], value);
    }

    if (_currentStep < _questions.length - 1) {
      setState(() {
        _currentStep++;
      });
      _updateControllerForCurrentStep();
    } else {
      _handleSubmit();
    }
  }

  void _handlePrevious() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _updateControllerForCurrentStep();
    }
  }

  Future<void> _handleSubmit() async {
    final storageService = OnboardingStorageService();
    await storageService.saveOnboardingData(_formData);
    await storageService.setOnboardingCompleted(true);

    final onboardingProvider = context.read<OnboardingProvider>();
    await onboardingProvider.completeOnboarding(_formData);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Widget _renderQuestion(Map<String, dynamic> question) {
    final value = _formData[question['id']] ?? '';

    if (question['type'] == 'language_picker') {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFe0e0e0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return ListTile(
              title: Text(
                languageProvider.currentLanguageName,
                style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              ),
              trailing: const Icon(Icons.language, color: Color(0xFF2D5016)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.language),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: AppConstants.supportedLanguages.length,
                          itemBuilder: (context, index) {
                            final languageCode =
                                AppConstants.supportedLanguages[index];
                            final languageName =
                                AppConstants.languageNames[languageCode] ??
                                languageCode;

                            return RadioListTile<String>(
                              title: Text(languageName),
                              value: languageCode,
                              groupValue:
                                  _formData['language'] ??
                                  languageProvider.currentLanguage,
                              onChanged: (String? selectedValue) async {
                                if (selectedValue != null &&
                                    selectedValue != _formData['language']) {
                                  debugPrint(
                                    'User selected language: $selectedValue',
                                  );
                                  await languageProvider.changeLanguage(
                                    selectedValue,
                                  );
                                  _handleInputChange(
                                    question['id'],
                                    selectedValue,
                                  );
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              activeColor: const Color(0xFF2D5016),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)?.cancel ?? 'Cancel',
                            style: const TextStyle(color: Color(0xFF2D5016)),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      );
    }

    if (question['type'] == 'picker') {
      return Column(
        children: [
          for (final option in question['options'])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: () =>
                    _handleInputChange(question['id'], option['value']),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: value == option['value']
                        ? const Color(0xFF8db87a)
                        : const Color(0xFFfafafa),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: value == option['value']
                          ? const Color(0xFF8db87a)
                          : const Color(0xFFe0e0e0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getOptionLabel(option, context),
                      style: TextStyle(
                        color: value == option['value']
                            ? Colors.white
                            : const Color(0xFF333333),
                        fontWeight: value == option['value']
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return TextFormField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: _getQuestionTitle(question, context),
        hintStyle: const TextStyle(color: Color(0xFF999999)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFe0e0e0)),
        ),
        filled: true,
        fillColor: const Color(0xFFfafafa),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
      keyboardType: TextInputType.text,
      minLines: 1,
      maxLines:
          (question['id'] == 'fertilizersAndChemicals' ||
              question['id'] == 'typesOfCrops')
          ? 3
          : 1,
      autocorrect: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentStep];
    final totalSteps = _questions.length;
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) => Scaffold(
        backgroundColor: const Color(0xFFF5F3F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F3F0),
          elevation: 0,
          leading: Container(),
          title: Text(
            AppLocalizations.of(context)?.setupProfile ?? 'Setup Profile',
            style: const TextStyle(
              color: Color(0xFF2D5016),
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return LanguageSelector(showAsButton: true);
              },
            ),
            const SizedBox(width: 16),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: const Color(0xFFE0E0E0), height: 1.0),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 40) *
                              ((_currentStep + 1) / totalSteps),
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8db87a),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_currentStep + 1} ${AppLocalizations.of(context)?.progressOf ?? 'of'} $totalSteps',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getQuestionTitle(question, context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _renderQuestion(question),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 8),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handlePrevious,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE0E0E0),
                              foregroundColor: const Color(0xFF666666),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              AppLocalizations.of(context)?.previous ??
                                  'Previous',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8db87a),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            _currentStep == totalSteps - 1
                                ? (AppLocalizations.of(context)?.complete ??
                                      'Complete')
                                : (AppLocalizations.of(context)?.next ??
                                      'Next'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
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
      ),
    );
  }

  String _getQuestionTitle(
    Map<String, dynamic> question,
    BuildContext context,
  ) {
    if (question['titleKey'] != null) {
      final localizations = AppLocalizations.of(context)!;
      switch (question['titleKey']) {
        case 'language':
          return localizations.language;
        case 'questionName':
          return localizations.questionName;
        case 'questionLocality':
          return localizations.questionLocality;
        case 'questionLandArea':
          return localizations.questionLandArea;
        case 'questionTypesOfCrops':
          return localizations.questionTypesOfCrops;
        case 'questionFertilizersAndChemicals':
          return localizations.questionFertilizersAndChemicals;
        case 'questionSourceOfIrrigation':
          return localizations.questionSourceOfIrrigation;
        case 'questionNumberOfCrops':
          return localizations.questionNumberOfCrops;
        case 'communicationPreference':
          return localizations.communicationPreference;
        default:
          return question['titleKey'];
      }
    }
    return question['id'];
  }

  String _getOptionLabel(Map<String, dynamic> option, BuildContext context) {
    if (option['labelKey'] != null) {
      final localizations = AppLocalizations.of(context)!;
      switch (option['labelKey']) {
        case 'textChat':
          return localizations.textChat;
        case 'voice':
          return localizations.voice;
        default:
          return option['labelKey'];
      }
    }
    return option['value'];
  }
}
