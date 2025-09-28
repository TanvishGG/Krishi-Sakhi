import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/weather_provider.dart';
import '../l10n/app_localizations.dart';
import 'voice_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'tools_screen.dart';
import 'crop_recommendation_screen.dart';
import 'yield_prediction_screen.dart';
import 'disease_detection_screen.dart';
import 'pest_detection_screen.dart';
import 'fertilizer_recommendation_screen.dart';
import 'schemes_loans_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              localizations.appTitle,
              style: const TextStyle(
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Color(0xFF2D5016)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2D5016), Color(0xFF1A3A0F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.agriculture,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.appTitle,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    localizations.yourSmartFarmingAssistant,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildWeatherCard(context, languageProvider, localizations),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      localizations.toolCategories,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D5016),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCategorizedTools(
                    context,
                    languageProvider,
                    localizations,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorizedTools(
    BuildContext context,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        _buildToolCategory(
          context,
          title: localizations.aiAssistant,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.mic,
              title: localizations.voiceAssistant,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoiceScreen()),
              ),
            ),
            _buildCategoryTool(
              context,
              icon: Icons.chat,
              title: localizations.chatSupport,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildToolCategory(
          context,
          title: localizations.cropAnalysis,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.grass,
              title: localizations.cropRecommendation,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CropRecommendationScreen(),
                ),
              ),
            ),
            _buildCategoryTool(
              context,
              icon: Icons.trending_up,
              title: localizations.yieldPrediction,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const YieldPredictionScreen(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildToolCategory(
          context,
          title: localizations.plantHealth,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.search,
              title: localizations.diseaseDetection,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DiseaseDetectionScreen(),
                ),
              ),
            ),
            _buildCategoryTool(
              context,
              icon: Icons.bug_report,
              title: localizations.pestDetection,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PestDetectionScreen(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildToolCategory(
          context,
          title: localizations.soilAndFertilizer,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.grass_outlined,
              title: localizations.fertilizerRecommendation,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FertilizerRecommendationScreen(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildToolCategory(
          context,
          title: localizations.financialAssistance,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.account_balance,
              title: localizations.governmentSchemesAndLoans,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchemesLoansScreen(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildToolCategory(
          context,
          title: localizations.moreTools,
          tools: [
            _buildCategoryTool(
              context,
              icon: Icons.build,
              title: localizations.moreTools,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ToolsScreen()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolCategory(
    BuildContext context, {
    required String title,
    required List<Widget> tools,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF2D5016).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.category,
                  color: Color(0xFF2D5016),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D5016),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildToolsGrid(tools),
        ],
      ),
    );
  }

  Widget _buildToolsGrid(List<Widget> tools) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: tools,
    );
  }

  Widget _buildCategoryTool(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2D5016).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2D5016).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF2D5016), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D5016),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(
    BuildContext context,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        if (weatherProvider.isLoading) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D5016)),
              ),
            ),
          );
        }

        if (weatherProvider.error != null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFF2D5016),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations.weatherDataUnavailable,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D5016),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => weatherProvider.fetchWeather(),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(localizations.retry),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5016),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                    if (weatherProvider.error?.contains('Location') == true ||
                        weatherProvider.error?.contains('permission') == true ||
                        weatherProvider.error?.contains('denied') == true)
                      const SizedBox(width: 8),
                    if (weatherProvider.error?.contains('Location') == true ||
                        weatherProvider.error?.contains('permission') == true ||
                        weatherProvider.error?.contains('denied') == true)
                      ElevatedButton.icon(
                        onPressed: () =>
                            weatherProvider.requestLocationPermission(),
                        icon: const Icon(Icons.location_on, size: 16),
                        label: Text(localizations.grantPermission),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A7C2A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        }

        final weatherData = weatherProvider.weatherData;
        if (weatherData == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            weatherProvider.fetchWeather();
          });

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                localizations.loadingWeather,
                style: const TextStyle(fontSize: 16, color: Color(0xFF2D5016)),
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ExpansionTile(
              backgroundColor: weatherData.willRainToday
                  ? const Color(0xFF1E3A5F)
                  : const Color(0xFF2D5016),
              collapsedBackgroundColor: weatherData.willRainToday
                  ? const Color(0xFF1E3A5F)
                  : const Color(0xFF2D5016),
              title: Row(
                children: [
                  Image.network(
                    weatherData.iconUrl,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                        size: 40,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weatherData.temperature.round()}Â°C',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weatherData.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => weatherProvider.refreshWeather(),
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.expand_more, color: Colors.white),
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weatherData.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D5016),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWeatherDetail(
                            localizations.humidity,
                            '${weatherData.humidity.round()}%',
                            Icons.water_drop,
                          ),
                          _buildWeatherDetail(
                            localizations.wind,
                            '${weatherData.windSpeed.round()} km/h',
                            Icons.air,
                          ),
                          _buildWeatherDetail(
                            localizations.rainToday,
                            weatherData.willRainToday
                                ? localizations.yes
                                : localizations.no,
                            weatherData.willRainToday
                                ? Icons.umbrella
                                : Icons.wb_sunny,
                            color: weatherData.willRainToday
                                ? Colors.red
                                : Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 16),
                      _buildRainPrediction(
                        weatherProvider,
                        languageProvider,
                        localizations,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherDetail(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2D5016).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? const Color(0xFF2D5016), size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color ?? const Color(0xFF2D5016),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRainPrediction(
    WeatherProvider weatherProvider,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    final predictions = <Widget>[];

    for (int i = 1; i <= 7; i++) {
      final prediction = weatherProvider.getRainPredictionForDay(i);
      if (prediction != null) {
        final date = prediction['date'] as DateTime;
        final dayName = _getDayName(date.weekday, localizations);
        final willRain = prediction['will_rain'] as bool;

        predictions.add(
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
              decoration: BoxDecoration(
                color: willRain
                    ? Colors.red.withOpacity(0.15)
                    : Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: willRain
                      ? Colors.red.withOpacity(0.25)
                      : Colors.green.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 10,
                      color: willRain ? Colors.red[700] : Colors.green[700],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Icon(
                    willRain ? Icons.umbrella : Icons.wb_sunny,
                    color: willRain ? Colors.red[600] : Colors.green[600],
                    size: 14,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    willRain ? localizations.yes : localizations.no,
                    style: TextStyle(
                      fontSize: 9,
                      color: willRain ? Colors.red[700] : Colors.green[700],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        if (i < 7) {
          predictions.add(const SizedBox(width: 4));
        }
      }
    }

    if (predictions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF2D5016).withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_cloudy, color: const Color(0xFF2D5016), size: 16),
              const SizedBox(width: 6),
              Text(
                localizations.sevenDayRainForecast,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D5016),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: predictions),
        ],
      ),
    );
  }

  String _getDayName(int weekday, AppLocalizations localizations) {
    switch (weekday) {
      case 1:
        return localizations.monday;
      case 2:
        return localizations.tuesday;
      case 3:
        return localizations.wednesday;
      case 4:
        return localizations.thursday;
      case 5:
        return localizations.friday;
      case 6:
        return localizations.saturday;
      case 7:
        return localizations.sunday;
      default:
        return '';
    }
  }
}
