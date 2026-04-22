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
      sectionTitle: section,
      disease: json['disease'] ?? 'Unknown',
      gene: json['gene'] ?? 'Unknown',
      inheritance:
          json['inheritance_label'] ?? json['inheritance_mode'] ?? 'Unknown',
      clinicalSignificance: json['clinical_significance'] ?? 'Unknown',

      // autosomal dominant / recessive
      affectedRisk:
          json['risk_affected_child'] ?? json['sons_affected'] ?? '0%',

      carrierRisk:
          json['risk_carrier_child'] ?? json['daughters_carrier'] ?? '0%',

      healthyRisk:
          json['risk_unaffected_child'] ??
          json['sons_healthy'] ??
          json['daughters_healthy'] ??
          '0%',

      explainRisk: json['risk_explanation'] ?? 'No explanation available',
    );
  }
}
