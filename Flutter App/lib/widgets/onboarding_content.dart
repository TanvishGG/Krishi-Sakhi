import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String currentLanguage;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == 'ml';

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              border: Border.all(
                color: AppTheme.primaryLight.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.agriculture,
              size: 120,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: AppTheme.spacing32),

          Text(
            title,
            textAlign: TextAlign.center,
            style: isArabic ? AppTheme.malayalamH1 : AppTheme.h2,
          ),

          const SizedBox(height: AppTheme.spacing16),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: isArabic
                ? AppTheme.malayalamBody.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  )
                : AppTheme.body1.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
          ),
        ],
      ),
    );
  }
}
