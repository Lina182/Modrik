class IndividualReportItem {
  final String gene;
  final String disease;
  final String arabicDisease;
  final String clinicalSignificance;
  final String inheritance;
  final String confidenceLevel;

  IndividualReportItem({
    required this.gene,
    required this.disease,
    required this.arabicDisease,
    required this.clinicalSignificance,
    required this.inheritance,
    required this.confidenceLevel,
  });

  /// 🔥 تنظيف اسم المرض لو جاء فيه | أو not specified
  static String cleanDiseaseName(String rawDisease) {
    if (rawDisease.trim().isEmpty) return 'Not available';

    final parts = rawDisease
        .split('|')
        .map((e) => e.trim())
        .where(
          (e) =>
              e.isNotEmpty &&
              e.toLowerCase() != 'not specified' &&
              e.toLowerCase() != 'not provided',
        )
        .toList();

    if (parts.isEmpty) return 'Not available';

    return parts.first;
  }

  /// 🔥 هذا يقرأ من شكل JSON الحقيقي اللي جاي من الباك
  factory IndividualReportItem.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic>? panelInfo,
  ) {
    return IndividualReportItem(
      gene: json['base__hugo']?.toString() ?? 'Not available',

      disease: cleanDiseaseName(
        json['clinvar__disease_names']?.toString() ?? '',
      ),

      arabicDisease: '',

      clinicalSignificance: json['clinvar__sig']?.toString() ?? 'Not available',

      inheritance:
          panelInfo?['mode_of_inheritance']?.toString() ?? 'Not available',

      confidenceLevel:
          panelInfo?['confidence_level']?.toString() ?? 'Not available',
    );
  }
}
