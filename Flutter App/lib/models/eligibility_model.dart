class EligibilityResult {
  final String schemeSuggestion;
  final String schemeEligibilityStatus;
  final String schemeDescription;
  final String schemeDocuments;
  final String loanSuggestion;
  final String loanEligibilityStatus;
  final String loanDescription;
  final String loanDocuments;
  final String officialDisclaimer;
  final List<String> nextSteps;

  EligibilityResult({
    required this.schemeSuggestion,
    required this.schemeEligibilityStatus,
    required this.schemeDescription,
    required this.schemeDocuments,
    required this.loanSuggestion,
    required this.loanEligibilityStatus,
    required this.loanDescription,
    required this.loanDocuments,
    required this.officialDisclaimer,
    required this.nextSteps,
  });

  factory EligibilityResult.fromJson(Map<String, dynamic> json) {
    return EligibilityResult(
      schemeSuggestion: _extractString(json['schemeSuggestion']),
      schemeEligibilityStatus: _extractString(json['schemeEligibilityStatus']),
      schemeDescription: _extractString(json['schemeDescription']),
      schemeDocuments: _extractString(json['schemeDocuments']),
      loanSuggestion: _extractString(json['loanSuggestion']),
      loanEligibilityStatus: _extractString(json['loanEligibilityStatus']),
      loanDescription: _extractString(json['loanDescription']),
      loanDocuments: _extractString(json['loanDocuments']),
      officialDisclaimer: _extractString(json['officialDisclaimer']),
      nextSteps: _extractStringList(json['nextSteps']),
    );
  }

  static String _extractString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is List) {
      return value.map((e) => 'â€¢ ${e.toString()}').join('\n');
    }
    return value.toString();
  }

  static List<String> _extractStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      return [value];
    }
    return [value.toString()];
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeSuggestion': schemeSuggestion,
      'schemeEligibilityStatus': schemeEligibilityStatus,
      'schemeDescription': schemeDescription,
      'schemeDocuments': schemeDocuments,
      'loanSuggestion': loanSuggestion,
      'loanEligibilityStatus': loanEligibilityStatus,
      'loanDescription': loanDescription,
      'loanDocuments': loanDocuments,
      'officialDisclaimer': officialDisclaimer,
      'nextSteps': nextSteps,
    };
  }
}

class EligibilityErrorResult {
  final String error;
  final String message;

  EligibilityErrorResult({required this.error, required this.message});
}

class EligibilitySchema {
  static final Map<String, dynamic> schema = {
    'type': 'object',
    'properties': {
      'schemeSuggestion': {
        'type': 'string',
        'description':
            'Name of the most relevant government scheme for this farmer.',
      },
      'schemeEligibilityStatus': {
        'type': 'string',
        'description':
            'One of "Likely Eligible", "Potentially Eligible", or "Need More Information".',
      },
      'schemeDescription': {
        'type': 'string',
        'description': 'Brief description of the scheme benefits and purpose.',
      },
      'schemeDocuments': {
        'type': 'string',
        'description': 'List of required documents for scheme application.',
      },
      'loanSuggestion': {
        'type': 'string',
        'description': 'Most suitable agricultural loan or financial product.',
      },
      'loanEligibilityStatus': {
        'type': 'string',
        'description':
            'One of "Likely Eligible", "Potentially Eligible", or "Need More Information".',
      },
      'loanDescription': {
        'type': 'string',
        'description': 'Brief description of the loan terms and benefits.',
      },
      'loanDocuments': {
        'type': 'string',
        'description': 'List of required documents for loan application.',
      },
      'officialDisclaimer': {
        'type': 'string',
        'description':
            'Strong disclaimer about verifying eligibility with official sources.',
      },
      'nextSteps': {
        'type': 'array',
        'items': {'type': 'string'},
        'description': 'List of concrete next steps the farmer should take.',
      },
    },
    'required': [
      'schemeSuggestion',
      'schemeEligibilityStatus',
      'schemeDescription',
      'schemeDocuments',
      'loanSuggestion',
      'loanEligibilityStatus',
      'loanDescription',
      'loanDocuments',
      'officialDisclaimer',
      'nextSteps',
    ],
  };
}
