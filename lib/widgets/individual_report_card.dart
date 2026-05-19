import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/individual_report_item.dart';
import '../../services/disease_service.dart';

const Color mainPurple = Color(0xFF6C63FF);

class IndividualReportCard extends StatefulWidget {
  final IndividualReportItem item;

  final String? translatedDisease;

  final bool isExpertView;

  const IndividualReportCard({
    super.key,
    required this.item,
    this.translatedDisease,
    this.isExpertView = false,
  });

  @override
  State<IndividualReportCard> createState() => _IndividualReportCardState();
}

class _IndividualReportCardState extends State<IndividualReportCard> {
  bool isLoading = false;
  bool showExpertDetails = false;

  // =========================
  // TRANSLATE INHERITANCE
  // =========================

  String _translateInheritance(BuildContext context, String value) {
    final t = AppLocalizations.of(context)!;

    final lower = value.toLowerCase();

    if (lower.contains('both dominant and recessive')) {
      return t.bothDominantRecessive;
    }

    if (lower.contains('autosomal dominant')) {
      return t.autosomalDominant;
    }

    if (lower.contains('autosomal recessive')) {
      return t.autosomalRecessive;
    }

    if (lower.contains('x-linked dominant')) {
      return t.xLinkedDominant;
    }

    if (lower.contains('x-linked recessive')) {
      return t.xLinkedRecessive;
    }

    if (lower.contains('x-linked')) {
      return t.xLinked;
    }

    return value;
  }

  // =========================
  // TRANSLATE SIGNIFICANCE
  // =========================

  String _translateClinicalSignificance(BuildContext context, String value) {
    final t = AppLocalizations.of(context)!;

    final lower = value.toLowerCase();

    if (lower.contains('likely pathogenic')) {
      return t.likelyPathogenic;
    }

    if (lower.contains('pathogenic')) {
      return t.pathogenic;
    }

    if (lower.contains('uncertain')) {
      return t.uncertainSignificance;
    }

    if (lower.contains('benign')) {
      return t.benign;
    }

    return value;
  }

  // =========================
  // STATUS COLORS
  // =========================

  Color _statusColor(String value) {
    final lower = value.toLowerCase();

    if (lower.contains('pathogenic')) {
      return const Color(0xFFE83F6F);
    }

    if (lower.contains('uncertain')) {
      return const Color(0xFFFFA726);
    }

    if (lower.contains('benign') ||
        lower.contains('healthy') ||
        lower.contains('normal')) {
      return const Color(0xFF2EAF61);
    }

    return mainPurple;
  }

  Color _statusBackground(String value) {
    final lower = value.toLowerCase();

    if (lower.contains('pathogenic')) {
      return const Color(0xFFFFEEF3);
    }

    if (lower.contains('uncertain')) {
      return const Color(0xFFFFF4E0);
    }

    if (lower.contains('benign') ||
        lower.contains('healthy') ||
        lower.contains('normal')) {
      return const Color(0xFFEAF8EF);
    }

    return const Color(0xFFEDEBFF);
  }

  // =========================
  // MENU
  // =========================

  void _showMenu() async {
    final t = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),

      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 44,
              height: 5,

              margin: const EdgeInsets.only(bottom: 18),

              decoration: BoxDecoration(
                color: const Color(0xFFE2E2EA),

                borderRadius: BorderRadius.circular(50),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.psychology_outlined, color: mainPurple),

              title: Text(
                t.explain,

                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              onTap: () async {
                Navigator.pop(context);

                setState(() {
                  isLoading = true;
                });

                try {
                  final explanation = await DiseaseService.explainDisease(
                    widget.item.disease,
                    Localizations.localeOf(context).languageCode,
                  );
                  if (!mounted) return;

                  showDialog(
                    context: context,

                    builder: (_) => AlertDialog(
                      backgroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),

                      icon: Container(
                        width: 58,
                        height: 58,

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF3EEFF),
                        ),

                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFF7B61FF),
                          size: 28,
                        ),
                      ),

                      title: Text(
                        t.explain,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          color: Color(0xFF7B61FF),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      content: Text(
                        explanation,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.7,
                          color: Color(0xFF4E4B66),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                      actions: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            style: ElevatedButton.styleFrom(
                              elevation: 0,

                              backgroundColor: Colors.transparent,

                              shadowColor: Colors.transparent,

                              padding: EdgeInsets.zero,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),

                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B6BFF),
                                    Color(0xFF6C63FF),
                                  ],
                                ),
                              ),

                              child: Center(
                                child: Text(
                                  t.ok,

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to generate explanation'),
                    ),
                  );
                }

                setState(() {
                  isLoading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final item = widget.item;

    final statusColor = _statusColor(item.clinicalSignificance);

    final statusBackground = _statusBackground(item.clinicalSignificance);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),

            blurRadius: 24,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Align(
            alignment: Alignment.topRight,

            child: IconButton(
              onPressed: _showMenu,

              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF171733),
              ),

              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF3F0FF),

                minimumSize: const Size(34, 34),
              ),
            ),
          ),

          const SizedBox(height: 8),

          _InfoRow(
            icon: Icons.biotech_outlined,

            title: t.gene,

            value: item.gene,
          ),

          _InfoRow(
            icon: Icons.medical_information_outlined,

            title: t.disease,

            valueWidget: Text(
              widget.translatedDisease ?? item.disease,

              textDirection: widget.translatedDisease != null
                  ? TextDirection.rtl
                  : TextDirection.ltr,

              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF171733),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),

          _InfoRow(
            icon: Icons.health_and_safety_outlined,

            title: t.clinicalSignificance,

            valueWidget: _StatusBadge(
              text: _translateClinicalSignificance(
                context,
                item.clinicalSignificance,
              ),

              color: statusColor,

              background: statusBackground,

              compact: true,
            ),
          ),

          _InfoRow(
            icon: Icons.groups_2_outlined,

            title: t.inheritance,

            value: _translateInheritance(context, item.inheritance),
          ),

          _InfoRow(
            icon: Icons.bar_chart_rounded,

            title: t.confidenceLevel,

            valueWidget: _ConfidenceBadge(value: item.confidenceLevel),

            showDivider: false,
          ),

          if (widget.isExpertView && item.variantDetails != null) ...[
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showExpertDetails = !showExpertDetails;
                  });
                },

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      showExpertDetails ? t.hideDetails : t.showDetails,

                      style: const TextStyle(
                        color: mainPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Icon(
                      showExpertDetails
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,

                      color: mainPurple,
                    ),
                  ],
                ),
              ),
            ),

            if (showExpertDetails) ...[
              const SizedBox(height: 14),

              _expertDetailsCard(item.variantDetails!),
            ],
          ],

          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 14),

              child: Center(
                child: SizedBox(
                  width: 26,
                  height: 26,

                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _expertDetailsCard(Map<String, dynamic> details) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            t.variantDetails,

            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),

          const SizedBox(height: 12),

          Text("${t.chromosome}: ${details["chrom"]}"),

          Text("${t.position}: ${details["position"]}"),

          Text("${t.reference}: ${details["ref"]}"),

          Text("${t.alternative}: ${details["alt"]}"),

          Text("${t.zygosity}: ${details["zygosity"]}"),
        ],
      ),
    );
  }
}

// STATUS BADGE

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;
  final bool compact;

  const _StatusBadge({
    required this.text,
    required this.color,
    required this.background,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: compact ? null : const BoxConstraints(maxWidth: 150),

      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,

        vertical: compact ? 7 : 10,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Flexible(
            child: Text(
              text,

              overflow: TextOverflow.visible,

              style: TextStyle(
                color: color,

                fontSize: compact ? 12 : 11.5,

                fontWeight: FontWeight.w800,

                height: 1.25,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}

// INFO ROW

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final Widget? valueWidget;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.title,
    this.value,
    this.valueWidget,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(icon, color: mainPurple, size: 24),
              ),

              const SizedBox(width: 16),

              SizedBox(
                width: 120,

                child: Padding(
                  padding: const EdgeInsets.only(top: 12),

                  child: Text(
                    title,

                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF171733),

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),

                  child:
                      valueWidget ??
                      Text(
                        value ?? '',

                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF171733),

                          fontWeight: FontWeight.w600,

                          height: 1.45,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),

        if (showDivider) const Divider(height: 1, color: Color(0xFFEEEFF6)),
      ],
    );
  }
}

// CONFIDENCE BADGE

class _ConfidenceBadge extends StatelessWidget {
  final String value;

  const _ConfidenceBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),

      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFF),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Text(
        value,

        textAlign: TextAlign.center,

        style: const TextStyle(
          color: mainPurple,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
