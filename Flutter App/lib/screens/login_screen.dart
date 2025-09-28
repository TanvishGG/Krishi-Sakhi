import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_selector.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_theme.dart';
import 'onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _mobileNumber = '';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _validateMobileNumber(String number) {
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    return mobileRegex.hasMatch(number);
  }

  void _formatMobileNumber(String text) {
    final cleaned = text.replaceAll(RegExp(r'\D'), '');
    final limited = cleaned.length > 10 ? cleaned.substring(0, 10) : cleaned;
    setState(() {
      _mobileNumber = limited;
    });
    _phoneController.value = TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }

  Future<void> _handleLogin(
    AuthProvider authProvider,
    LanguageProvider languageProvider,
  ) async {
    if (_mobileNumber.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterMobileNumber),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (!_validateMobileNumber(_mobileNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidMobileNumber),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      await authProvider.login(_mobileNumber);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.loginSuccessful ??
                  'Login successful!',
            ),
            backgroundColor: AppTheme.primaryColor,
          ),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.loginFailed ??
                  'Login failed. Please try again.',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3F0),
        elevation: 0,
        actions: [
          LanguageSelector(showAsButton: true),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer2<AuthProvider, LanguageProvider>(
        builder: (context, authProvider, languageProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D5016),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 60),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF8DB87A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.enterMobileNumber,
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF999999),
                                  ),
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                ),
                                onChanged: _formatMobileNumber,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              (_mobileNumber.trim().isEmpty ||
                                  !_validateMobileNumber(_mobileNumber) ||
                                  authProvider.isLoading)
                              ? null
                              : () => _handleLogin(
                                  authProvider,
                                  languageProvider,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8DB87A),
                            disabledBackgroundColor: const Color(
                              0xFF8DB87A,
                            ).withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.login,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.login,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    AppLocalizations.of(context)?.termsAndPrivacy ??
                        'By continuing, you agree to our terms and privacy policy',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                      height: 1.4,
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
}
