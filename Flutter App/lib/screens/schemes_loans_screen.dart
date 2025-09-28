import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schemes_loans_provider.dart';
import '../l10n/app_localizations.dart';

class SchemesLoansScreen extends StatefulWidget {
  const SchemesLoansScreen({super.key});

  @override
  State<SchemesLoansScreen> createState() => _SchemesLoansScreenState();
}

class _SchemesLoansScreenState extends State<SchemesLoansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchemesLoansProvider>().checkEligibility();
    });
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
          localizations.governmentSchemesAndLoans,
          style: const TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<SchemesLoansProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                Icons.account_balance,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personalized Recommendations',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'AI-powered eligibility check based on your profile',
                                    style: TextStyle(
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

                  if (provider.isLoading)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Analyzing your profile...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Finding the best schemes and loans for you',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (provider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Unable to fetch recommendations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.checkEligibility(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (provider.eligibilityResult != null) ...[
                    _buildSchemeCard(provider.eligibilityResult!),

                    const SizedBox(height: 20),

                    _buildLoanCard(provider.eligibilityResult!),

                    const SizedBox(height: 20),

                    _buildNextStepsCard(provider.eligibilityResult!),

                    const SizedBox(height: 20),

                    _buildDisclaimerCard(provider.eligibilityResult!),
                  ],

                  if (!provider.isLoading)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => provider.checkEligibility(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Recommendations'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2D5016),
                          side: const BorderSide(color: Color(0xFF2D5016)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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

  Widget _buildSchemeCard(eligibilityResult) {
    final provider = context.read<SchemesLoansProvider>();
    final statusColor = provider.getEligibilityStatusColor(
      eligibilityResult.schemeEligibilityStatus,
    );
    final statusIcon = provider.getEligibilityStatusIcon(
      eligibilityResult.schemeEligibilityStatus,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(left: BorderSide(width: 5, color: statusColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Government Scheme',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D5016),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            eligibilityResult.schemeSuggestion,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'Eligibility: ${eligibilityResult.schemeEligibilityStatus}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            eligibilityResult.schemeDescription,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Required Documents:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5016),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            eligibilityResult.schemeDocuments,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(eligibilityResult) {
    final provider = context.read<SchemesLoansProvider>();
    final statusColor = provider.getEligibilityStatusColor(
      eligibilityResult.loanEligibilityStatus,
    );
    final statusIcon = provider.getEligibilityStatusIcon(
      eligibilityResult.loanEligibilityStatus,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(left: BorderSide(width: 5, color: statusColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.green,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Agricultural Loan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D5016),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            eligibilityResult.loanSuggestion,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 18),
              const SizedBox(width: 6),
              Text(
                'Eligibility: ${eligibilityResult.loanEligibilityStatus}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            eligibilityResult.loanDescription,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444444),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Required Documents:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5016),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            eligibilityResult.loanDocuments,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard(eligibilityResult) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: const Border(left: BorderSide(width: 5, color: Colors.purple)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.list_alt,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Next Steps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D5016),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...eligibilityResult.nextSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF444444),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard(eligibilityResult) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.amber.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Important Disclaimer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            eligibilityResult.officialDisclaimer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.amber.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
