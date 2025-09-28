import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/yield_prediction_provider.dart';
import '../l10n/app_localizations.dart';

class YieldPredictionScreen extends StatefulWidget {
  const YieldPredictionScreen({super.key});

  @override
  State<YieldPredictionScreen> createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _cropController = TextEditingController();
  final _seasonController = TextEditingController();
  final _areaController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _stateController.dispose();
    _districtController.dispose();
    _cropController.dispose();
    _seasonController.dispose();
    _areaController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<YieldPredictionProvider>();
      provider.predictYield(
        state: _stateController.text,
        district: _districtController.text,
        crop: _cropController.text,
        season: _seasonController.text,
        area: double.parse(_areaController.text),
        year: int.parse(_yearController.text),
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
          localizations.yieldPrediction,
          style: const TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<YieldPredictionProvider>(
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
                            localizations.cropDetails,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: localizations.state,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _districtController,
                            decoration: InputDecoration(
                              labelText: localizations.district,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _cropController,
                            decoration: InputDecoration(
                              labelText: localizations.cropName,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _seasonController,
                            decoration: InputDecoration(
                              labelText: localizations.season,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.required;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          Text(
                            localizations.areaAndYear,
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
                                  controller: _areaController,
                                  decoration: InputDecoration(
                                    labelText: localizations.areaHectares,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _yearController,
                                  decoration: InputDecoration(
                                    labelText: localizations.year,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Invalid year';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
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
                                      localizations.predictYield,
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

                  if (provider.predictedYield != null)
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
                            localizations.predictedYield,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${provider.predictedYield!.toStringAsFixed(2)} ${localizations.tonsPerHectare}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  if (provider.marketAnalysis != null) ...[
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
                            localizations.marketPriceAndProfitAnalysis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                color: const Color(0xFF2D5016),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localizations.currentMarketPrice,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${provider.marketAnalysis!['current_market_price'].toStringAsFixed(2)} ${localizations.perKg}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D5016),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.orange.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localizations.priceRange,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${provider.marketAnalysis!['price_range']['min'].toStringAsFixed(2)} - ₹${provider.marketAnalysis!['price_range']['max'].toStringAsFixed(2)} ${localizations.perKg}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: Colors.green.shade700,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                localizations.profitAnalysis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              children: [
                                _buildProfitRow(
                                  localizations.totalRevenue,
                                  '₹${provider.marketAnalysis!['profit_analysis']['total_revenue'].toStringAsFixed(0)}',
                                  Colors.green.shade700,
                                ),
                                const SizedBox(height: 8),
                                _buildProfitRow(
                                  localizations.estimatedCosts,
                                  '₹${provider.marketAnalysis!['profit_analysis']['estimated_costs'].toStringAsFixed(0)}',
                                  Colors.red.shade700,
                                ),
                                const SizedBox(height: 8),
                                _buildProfitRow(
                                  localizations.netProfit,
                                  '₹${provider.marketAnalysis!['profit_analysis']['net_profit'].toStringAsFixed(0)}',
                                  provider.marketAnalysis!['profit_analysis']['net_profit'] >=
                                          0
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  isBold: true,
                                ),
                                const SizedBox(height: 8),
                                _buildProfitRow(
                                  localizations.profitPerHectare,
                                  '₹${provider.marketAnalysis!['profit_analysis']['profit_per_hectare'].toStringAsFixed(0)}',
                                  provider.marketAnalysis!['profit_analysis']['profit_per_hectare'] >=
                                          0
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildAnalysisCard(
                            localizations.marketTrends,
                            provider.marketAnalysis!['market_trends'],
                            Icons.trending_up,
                            Colors.blue,
                          ),

                          const SizedBox(height: 12),

                          _buildAnalysisCard(
                            localizations.sellingStrategies,
                            provider.marketAnalysis!['selling_strategies'],
                            Icons.shopping_cart,
                            Colors.purple,
                          ),

                          const SizedBox(height: 12),

                          _buildAnalysisCard(
                            localizations.riskFactors,
                            provider.marketAnalysis!['risk_factors'],
                            Icons.warning,
                            Colors.orange,
                          ),

                          const SizedBox(height: 12),

                          _buildAnalysisCard(
                            localizations.governmentSupport,
                            provider.marketAnalysis!['government_support'],
                            Icons.gavel,
                            Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ],
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
  }

  Widget _buildProfitRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
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
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
