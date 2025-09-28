import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fertilizer_recommendation_provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/weather_provider.dart';

class FertilizerRecommendationScreen extends StatefulWidget {
  const FertilizerRecommendationScreen({super.key});

  @override
  State<FertilizerRecommendationScreen> createState() =>
      _FertilizerRecommendationScreenState();
}

class _FertilizerRecommendationScreenState
    extends State<FertilizerRecommendationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _moistureController = TextEditingController();
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();

  String? _selectedSoilType;
  String? _selectedCropType;

  final List<String> _soilTypes = ['Sandy', 'Loamy', 'Black', 'Red', 'Clayey'];

  final List<String> _cropTypes = [
    'Maize',
    'Sugarcane',
    'Cotton',
    'Tobacco',
    'Paddy',
    'Barley',
    'Wheat',
    'Millets',
    'Oil seeds',
    'Pulses',
    'Ground Nuts',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWeatherData();
    });
  }

  @override
  void dispose() {
    _moistureController.dispose();
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.fetchWeather();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedSoilType != null &&
        _selectedCropType != null) {
      final weatherProvider = context.read<WeatherProvider>();
      final fertilizerProvider = context
          .read<FertilizerRecommendationProvider>();

      if (weatherProvider.weatherData == null) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.weatherDataRequiredFertilizer),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final monthlyAverages = weatherProvider.getMonthlyWeatherAverages();

      if (monthlyAverages == null) {
        fertilizerProvider.recommendFertilizer(
          soilType: _selectedSoilType!,
          cropType: _selectedCropType!,
          temperature: weatherProvider.weatherData!.temperature,
          humidity: weatherProvider.weatherData!.humidity,
          moisture: double.parse(_moistureController.text),
          nitrogen: double.parse(_nController.text),
          potassium: double.parse(_kController.text),
          phosphorous: double.parse(_pController.text),
        );
        return;
      }

      fertilizerProvider.recommendFertilizer(
        soilType: _selectedSoilType!,
        cropType: _selectedCropType!,
        temperature: monthlyAverages['average_temperature'],
        humidity: monthlyAverages['average_humidity'],
        moisture: double.parse(_moistureController.text),
        nitrogen: double.parse(_nController.text),
        potassium: double.parse(_kController.text),
        phosphorous: double.parse(_pController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3F0),
        elevation: 0,
        title: Text(
          localizations.fertilizerRecommendation,
          style: const TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<FertilizerRecommendationProvider>(
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
                            localizations.soilAndCropInformation,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    localizations.soilHealthCardInfo,
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _selectedSoilType,
                            decoration: InputDecoration(
                              labelText: localizations.soilType,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _soilTypes.map((soilType) {
                              return DropdownMenuItem(
                                value: soilType,
                                child: Text(soilType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSoilType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.pleaseSelectSoilType;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _selectedCropType,
                            decoration: InputDecoration(
                              labelText: localizations.cropType,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: _cropTypes.map((cropType) {
                              return DropdownMenuItem(
                                value: cropType,
                                child: Text(cropType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCropType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.pleaseSelectCropType;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _moistureController,
                            decoration: InputDecoration(
                              labelText: localizations.moisture,
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
                            localizations.soilNutrientLevels,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _nController,
                                  decoration: InputDecoration(
                                    labelText: 'N',
                                    hintText: localizations.nitrogen,
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
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _pController,
                                  decoration: InputDecoration(
                                    labelText: 'P',
                                    hintText: localizations.phosphorous,
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
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _kController,
                                  decoration: InputDecoration(
                                    labelText: 'K',
                                    hintText: localizations.potassium,
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
                              ),
                            ],
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
                                            padding: const EdgeInsets.symmetric(
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

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        margin: const EdgeInsets.only(left: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        margin: const EdgeInsets.only(left: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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

                  if (provider.recommendedFertilizer != null)
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
                            localizations.recommendedFertilizer,
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
                              color: const Color(0xFF2D5016).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF2D5016).withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.science,
                                      color: Color(0xFF2D5016),
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        provider.recommendedFertilizer!,
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
                                      borderRadius: BorderRadius.circular(6),
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
