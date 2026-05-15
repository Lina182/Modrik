class CrossReportItem {
  final String sectionTitle;
  final String disease;
  final String gene;
  final String inheritance;
  final String clinicalSignificance;

  final String affectedRisk;
  final String carrierRisk;
  final String healthyRisk;

  final String explainRisk;

  CrossReportItem({
    required this.sectionTitle,
    required this.disease,
    required this.gene,
    required this.inheritance,
    required this.clinicalSignificance,
    required this.affectedRisk,
    required this.carrierRisk,
    required this.healthyRisk,
    required this.explainRisk,
  });

  factory CrossReportItem.fromJson(Map<String, dynamic> json, String section) {
    return CrossReportItem(
      sectionTitle: json['sectionTitle']?.toString() ?? section,

      disease: json['disease']?.toString() ?? 'Unknown',

      gene: json['gene']?.toString() ?? 'Unknown',

      inheritance:
          json['inheritance']?.toString() ??
          json['inheritance_label']?.toString() ??
          json['inheritance_mode']?.toString() ??
          'Unknown',

      clinicalSignificance:
          json['clinicalSignificance']?.toString() ??
          json['clinical_significance']?.toString() ??
          'Unknown',

      affectedRisk:
          json['affectedRisk']?.toString() ??
          json['risk_affected_child']?.toString() ??
          json['sons_affected']?.toString() ??
          '0%',

      carrierRisk:
          json['carrierRisk']?.toString() ??
          json['risk_carrier_child']?.toString() ??
          json['daughters_carrier']?.toString() ??
          '0%',

      healthyRisk:
          json['healthyRisk']?.toString() ??
          json['risk_unaffected_child']?.toString() ??
          json['sons_healthy']?.toString() ??
          json['daughters_healthy']?.toString() ??
          '0%',

      explainRisk:
          json['explainRisk']?.toString() ??
          json['risk_explanation']?.toString() ??
          'No explanation available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sectionTitle": sectionTitle,
      "disease": disease,
      "gene": gene,
      "inheritance": inheritance,
      "clinicalSignificance": clinicalSignificance,
      "affectedRisk": affectedRisk,
      "carrierRisk": carrierRisk,
      "healthyRisk": healthyRisk,
      "explainRisk": explainRisk,
    };
  }
}
