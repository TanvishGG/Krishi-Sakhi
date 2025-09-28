import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'crop_recommendation_screen.dart';
import 'yield_prediction_screen.dart';
import 'disease_detection_screen.dart';
import 'pest_detection_screen.dart';
import 'fertilizer_recommendation_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F3F0),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F3F0),
            elevation: 0,
            title: Text(
              localizations.aiTools,
              style: const TextStyle(
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      localizations.aiToolsSubtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    _buildToolCard(
                      context,
                      icon: Icons.grass,
                      title: localizations.cropRecommendation,
                      description: localizations.cropRecommendationDesc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CropRecommendationScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildToolCard(
                      context,
                      icon: Icons.trending_up,
                      title: localizations.yieldPrediction,
                      description: localizations.yieldPredictionDesc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YieldPredictionScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildToolCard(
                      context,
                      icon: Icons.search,
                      title: localizations.diseaseDetection,
                      description: localizations.diseaseDetectionDesc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiseaseDetectionScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildToolCard(
                      context,
                      icon: Icons.bug_report,
                      title: localizations.pestDetection,
                      description: localizations.pestDetectionDesc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PestDetectionScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildToolCard(
                      context,
                      icon: Icons.science,
                      title: localizations.fertilizerRecommendation,
                      description: localizations.fertilizerRecommendationDesc,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FertilizerRecommendationScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF2D5016), size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D5016),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF2D5016),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
