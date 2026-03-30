import 'package:flutter/material.dart';
import '../models/cross_report_item.dart';

class CrossReportCard extends StatelessWidget {
  final CrossReportItem item;
  final VoidCallback onExplainPressed;

  const CrossReportCard({
    super.key,
    required this.item,
    required this.onExplainPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7DDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genetic Condition',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            'Disease: ${item.disease}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text('Gene: ${item.gene}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            'Inheritance: ${item.inheritance}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 14),
          const Text(
            'Child Risk',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _riskRow('Affected', item.affectedRisk, const Color(0xFFF75F78)),
          const SizedBox(height: 8),
          _riskRow('Carrier', item.carrierRisk, const Color(0xFFF2C84B)),
          const SizedBox(height: 8),
          _riskRow('Healthy', item.healthyRisk, const Color(0xFF73D3AE)),
          const SizedBox(height: 14),
          Text(
            'Clinical significance: ${item.clinicalSignificance}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onExplainPressed,
              child: const Text('Explain this risk'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskRow(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
