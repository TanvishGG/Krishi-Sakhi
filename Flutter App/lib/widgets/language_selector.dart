import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final bool showAsButton;
  final VoidCallback? onLanguageChanged;

  const LanguageSelector({
    super.key,
    this.showAsButton = false,
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        if (showAsButton) {
          return TextButton(
            onPressed: () => _showLanguageDialog(context),
            child: Text(
              languageProvider.currentLanguageName,
              style: const TextStyle(
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return ListTile(
          title: Text(AppLocalizations.of(context)!.language),
          subtitle: Text(languageProvider.currentLanguageName),
          trailing: const Icon(Icons.language),
          onTap: () => _showLanguageDialog(context),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
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
                final languageCode = AppConstants.supportedLanguages[index];
                final languageName =
                    AppConstants.languageNames[languageCode] ?? languageCode;
                return RadioListTile<String>(
                  title: Text(languageName),
                  value: languageCode,
                  groupValue: context.read<LanguageProvider>().currentLanguage,
                  onChanged: (String? value) async {
                    if (value != null) {
                      await context.read<LanguageProvider>().changeLanguage(
                        value,
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        onLanguageChanged?.call();
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
                'Cancel',
                style: const TextStyle(color: Color(0xFF2D5016)),
              ),
            ),
          ],
        );
      },
    );
  }
}
