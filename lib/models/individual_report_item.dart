class IndividualReportItem {
  final String gene;
  final String disease;
  final String clinicalSignificance;
  final String inheritance;
  final String confidenceLevel;

  IndividualReportItem({
    required this.gene,
    required this.disease,
    required this.clinicalSignificance,
    required this.inheritance,
    required this.confidenceLevel,
  });

  static String cleanDiseaseName(String rawDisease) {
    if (rawDisease.isEmpty) return 'Not available';

    final parts = rawDisease.split('|');

    for (var part in parts) {
      part = part.trim().toLowerCase();

      if (part != 'not specified' && part != 'not provided') {
        return part;
      }
    }

    return 'Not available';
  }

  factory IndividualReportItem.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic>? panelInfo,
  ) {
    return IndividualReportItem(
      gene:
          json['gene']?.toString() ??
          json['base__hugo']?.toString() ??
          'Not available',

      disease:
          json['disease']?.toString() ??
          cleanDiseaseName(json['clinvar__disease_names']?.toString() ?? ''),

      clinicalSignificance:
          json['clinicalSignificance']?.toString() ??
          json['clinvar__sig']?.toString() ??
          'Not available',

      inheritance:
          json['inheritance']?.toString() ??
          panelInfo?['mode_of_inheritance']?.toString() ??
          'Not available',

      confidenceLevel:
          json['confidenceLevel']?.toString() ??
          panelInfo?['confidence_level']?.toString() ??
          'Not available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gene": gene,
      "disease": disease,
      "clinicalSignificance": clinicalSignificance,
      "inheritance": inheritance,
      "confidenceLevel": confidenceLevel,
    };
  }
}
