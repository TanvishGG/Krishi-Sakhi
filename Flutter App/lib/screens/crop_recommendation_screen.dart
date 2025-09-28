import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/crop_recommendation_provider.dart';
import '../providers/language_provider.dart';
import '../providers/weather_provider.dart';
import '../l10n/app_localizations.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _phController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _phController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.fetchWeather();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final weatherProvider = context.read<WeatherProvider>();
      final cropProvider = context.read<CropRecommendationProvider>();

      if (weatherProvider.weatherData == null) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.weatherDataRequired),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final monthlyAverages = weatherProvider.getMonthlyWeatherAverages();

      if (monthlyAverages == null) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.usingCurrentWeatherData),
            backgroundColor: Colors.orange,
          ),
        );

        cropProvider.recommendCrop(
          n: int.parse(_nController.text),
          p: int.parse(_pController.text),
          k: int.parse(_kController.text),
          temperature: weatherProvider.weatherData!.temperature,
          humidity: weatherProvider.weatherData!.humidity,
          ph: double.parse(_phController.text),
          rainfall: 0.0,
        );
        return;
      }

      cropProvider.recommendCrop(
        n: int.parse(_nController.text),
        p: int.parse(_pController.text),
        k: int.parse(_kController.text),
        temperature: monthlyAverages['average_temperature'],
        humidity: monthlyAverages['average_humidity'],
        ph: double.parse(_phController.text),
        rainfall: monthlyAverages['monthly_rainfall'],
      );
    }
  }

  Widget _buildJustificationCard(
    String title,
    String content,
    IconData icon,
    bool isEnglish,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2D5016), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D5016),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

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
              localizations.cropRecommendation,
              style: const TextStyle(
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Consumer<CropRecommendationProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.soilParameters,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D5016),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nController,
                                      decoration: InputDecoration(
                                        labelText: 'N',
                                        hintText: localizations.nitrogen,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localizations.required;
                                        }
                                        if (int.tryParse(value) == null) {
                                          return localizations.invalidNumber;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _pController,
                                      decoration: InputDecoration(
                                        labelText: 'P',
                                        hintText: localizations.phosphorus,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localizations.required;
                                        }
                                        if (int.tryParse(value) == null) {
                                          return localizations.invalidNumber;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _kController,
                                      decoration: InputDecoration(
                                        labelText: 'K',
                                        hintText: localizations.potassium,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localizations.required;
                                        }
                                        if (int.tryParse(value) == null) {
                                          return localizations.invalidNumber;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _phController,
                                decoration: InputDecoration(
                                  labelText: 'pH',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localizations.required;
                                  }
                                  if (double.tryParse(value) == null) {
                                    return localizations.invalidNumber;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Text(
                                localizations.environmentalParameters,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D5016),
                                ),
                              ),
                              const SizedBox(height: 12),

                              Consumer<WeatherProvider>(
                                builder: (context, weatherProvider, child) {
                                  if (weatherProvider.isLoading) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            localizations.fetchingWeatherData,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  if (weatherProvider.error != null) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.red.shade200,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                localizations.weatherDataError,
                                                style: TextStyle(
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            weatherProvider.error!,
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: _fetchWeatherData,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade700,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              child: Text(
                                                localizations.retry,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  if (weatherProvider.weatherData == null) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Text(
                                        localizations.weatherDataNotAvailable,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }

                                  final monthlyAverages = weatherProvider
                                      .getMonthlyWeatherAverages();

                                  if (monthlyAverages != null) {
                                    final avgTemp =
                                        monthlyAverages['average_temperature']
                                            as double;
                                    final avgHumidity =
                                        monthlyAverages['average_humidity']
                                            as double;
                                    final monthlyRainfall =
                                        monthlyAverages['monthly_rainfall']
                                            as double;

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.orange.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.thermostat,
                                                  color: Colors.orange.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${avgTemp.toStringAsFixed(1)}°C',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.blue.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.water_drop,
                                                  color: Colors.blue.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${avgHumidity.toStringAsFixed(1)}%',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.only(
                                              left: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.cyan.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.cyan.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.cloud,
                                                  color: Colors.cyan.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${monthlyRainfall.toStringAsFixed(1)} mm',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.orange.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.thermostat,
                                                  color: Colors.orange.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${weatherProvider.weatherData!.temperature.toStringAsFixed(1)}°C',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.blue.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.water_drop,
                                                  color: Colors.blue.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${weatherProvider.weatherData!.humidity.toStringAsFixed(1)}%',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            margin: const EdgeInsets.only(
                                              left: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.cyan.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.cyan.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.cloud,
                                                  color: Colors.cyan.shade700,
                                                  size: 20,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "N/A",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF2D5016),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: provider.isLoading
                                      ? null
                                      : _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D5016),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: provider.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          localizations.getRecommendation,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (provider.recommendedCrop != null)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.recommendedCrop,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D5016),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2D5016,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF2D5016,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.agriculture,
                                          color: Color(0xFF2D5016),
                                          size: 28,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            provider.recommendedCrop!,
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2D5016),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (provider.isUsingFallback) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: Colors.orange.shade200,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.orange.shade700,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                localizations
                                                    .usingLocalRecommendation,
                                                style: TextStyle(
                                                  color: Colors.orange.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              if (provider.cropJustification != null) ...[
                                const SizedBox(height: 24),
                                Text(
                                  localizations.aiAnalysisAndJustification,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D5016),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                if (provider
                                        .cropJustification!['suitability_analysis'] !=
                                    null)
                                  _buildJustificationCard(
                                    localizations.soilSuitability,
                                    provider
                                        .cropJustification!['suitability_analysis'],
                                    Icons.science,
                                    languageProvider.isEnglish,
                                  ),

                                if (provider
                                        .cropJustification!['environmental_factors'] !=
                                    null)
                                  _buildJustificationCard(
                                    localizations.environmentalFactors,
                                    provider
                                        .cropJustification!['environmental_factors'],
                                    Icons.wb_sunny,
                                    languageProvider.isEnglish,
                                  ),

                                if (provider.cropJustification!['benefits'] !=
                                    null)
                                  _buildJustificationCard(
                                    localizations.keyBenefits,
                                    provider.cropJustification!['benefits'],
                                    Icons.thumb_up,
                                    languageProvider.isEnglish,
                                  ),

                                if (provider.cropJustification!['risks'] !=
                                    null)
                                  _buildJustificationCard(
                                    localizations.riskConsiderations,
                                    provider.cropJustification!['risks'],
                                    Icons.warning,
                                    languageProvider.isEnglish,
                                  ),

                                if (provider
                                        .cropJustification!['recommendations'] !=
                                    null)
                                  _buildJustificationCard(
                                    localizations.farmingRecommendations,
                                    provider
                                        .cropJustification!['recommendations'],
                                    Icons.lightbulb,
                                    languageProvider.isEnglish,
                                  ),
                              ] else if (provider.isLoading) ...[
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          localizations.generatingAiAnalysis,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                      if (provider.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
