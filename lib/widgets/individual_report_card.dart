import 'package:flutter/material.dart';
import '../models/individual_report_item.dart';
import '../services/disease_service.dart';

const Color mainPurple = Color(0xFF6C63FF);

class IndividualReportCard extends StatefulWidget {
  final IndividualReportItem item;
  final bool isExpertView;

  const IndividualReportCard({
    super.key,
    required this.item,
    this.isExpertView = false,
  });

  @override
  State<IndividualReportCard> createState() =>
      _IndividualReportCardState();
}

class _IndividualReportCardState
    extends State<IndividualReportCard> {

  bool showArabic = false;
  bool isLoading = false;
  bool showExpertDetails = false;

  String? translatedText;

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
    final value = await showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),

      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          28,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Container(
              width: 44,
              height: 5,

              margin: const EdgeInsets.only(
                bottom: 18,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFFE2E2EA),

                borderRadius:
                    BorderRadius.circular(50),
              ),
            ),

            // TRANSLATE
            ListTile(
              leading: const Icon(
                Icons.translate,
                color: mainPurple,
              ),

              title: const Text(
                'Translate to Arabic',

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () =>
                  Navigator.pop(context, 'translate'),
            ),

            // EXPLAIN
            ListTile(
              leading: const Icon(
                Icons.psychology_outlined,
                color: mainPurple,
              ),

              title: const Text(
                'Explain',

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              onTap: () =>
                  Navigator.pop(context, 'explain'),
            ),
          ],
        ),
      ),
    );

    final item = widget.item;

    // =========================
    // TRANSLATE
    // =========================

    if (value == 'translate') {

      setState(() => isLoading = true);

      try {

        final result =
            await DiseaseService.translateDisease(
          item.disease,
        );

        setState(() {
          translatedText = result;
          showArabic = true;
          isLoading = false;
        });

      } catch (e) {

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Translation failed: $e"),
          ),
        );
      }
    }

    // =========================
    // EXPLAIN
    // =========================

    if (value == 'explain') {

      setState(() => isLoading = true);

      try {

        final result =
            await DiseaseService.explainDisease(
          item.disease,
        );

        setState(() => isLoading = false);

        showModalBottomSheet(
          context: context,

          backgroundColor: Colors.white,

          isScrollControlled: true,

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),

          builder: (_) => Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              32,
            ),

            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context)
                          .size
                          .height *
                      0.65,
            ),

            child: SingleChildScrollView(
              child: Text(
                result,

                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF171733),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );

      } catch (e) {

        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Explanation failed: $e"),
          ),
        );
      }
    }
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {

    final item = widget.item;

    final statusColor =
        _statusColor(item.clinicalSignificance);

    final statusBackground =
        _statusBackground(
      item.clinicalSignificance,
    );

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.045),

            blurRadius: 24,

            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // MENU
          Align(
            alignment: Alignment.topRight,

            child: IconButton(
              onPressed: _showMenu,

              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF171733),
              ),

              style: IconButton.styleFrom(
                backgroundColor:
                    const Color(0xFFF3F0FF),

                minimumSize:
                    const Size(34, 34),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // GENE
          _InfoRow(
            icon: Icons.biotech_outlined,
            title: 'Gene',
            value: item.gene,
          ),

          // DISEASE
          _InfoRow(
            icon:
                Icons.medical_information_outlined,

            title: 'Disease',

            valueWidget: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  item.disease,

                  style: const TextStyle(
                    fontSize: 13.5,
                    color:
                        Color(0xFF171733),
                    fontWeight:
                        FontWeight.w600,
                    height: 1.35,
                  ),
                ),

                // TRANSLATION
                if (showArabic &&
                    translatedText != null) ...[

                  const SizedBox(height: 8),

                  Text(
                    translatedText!,

                    textDirection:
                        TextDirection.rtl,

                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: mainPurple,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // CLINICAL SIGNIFICANCE
          _InfoRow(
            icon:
                Icons.health_and_safety_outlined,

            title:
                'Clinical significance',

            valueWidget: _StatusBadge(
              text:
                  item.clinicalSignificance,

              color: statusColor,

              background:
                  statusBackground,

              compact: true,
            ),
          ),

          // INHERITANCE
          _InfoRow(
            icon: Icons.groups_2_outlined,
            title: 'Inheritance',
            value: item.inheritance,
          ),

          // CONFIDENCE
          _InfoRow(
            icon:
                Icons.bar_chart_rounded,

            title:
                'Confidence level',

            valueWidget:
                _ConfidenceBadge(
              value:
                  item.confidenceLevel,
            ),

            showDivider: false,
          ),

          // =========================
          // EXPERT DETAILS
          // =========================

          if (widget.isExpertView &&
              item.variantDetails != null) ...[

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,

              child: GestureDetector(
                onTap: () {

                  setState(() {
                    showExpertDetails =
                        !showExpertDetails;
                  });
                },

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    Text(
                      showExpertDetails
                          ? "Hide Details"
                          : "Show Details",

                      style:
                          const TextStyle(
                        color: mainPurple,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 6),

                    Icon(
                      showExpertDetails
                          ? Icons
                              .keyboard_arrow_up
                          : Icons
                              .keyboard_arrow_down,

                      color: mainPurple,
                    ),
                  ],
                ),
              ),
            ),

            if (showExpertDetails) ...[

              const SizedBox(height: 14),

              _expertDetailsCard(
                item.variantDetails!,
              ),
            ],
          ],

          // LOADING
          if (isLoading)
            const Padding(
              padding:
                  EdgeInsets.only(top: 14),

              child: Center(
                child: SizedBox(
                  width: 26,
                  height: 26,

                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  // EXPERT DETAILS CARD
  Widget _expertDetailsCard(
    Map<String, dynamic> details,
  ) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            "Variant Details",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Chromosome: ${details["chrom"]}",
          ),

          Text(
            "Position: ${details["position"]}",
          ),

          Text(
            "Reference: ${details["ref"]}",
          ),

          Text(
            "Alternative: ${details["alt"]}",
          ),

          Text(
            "Zygosity: ${details["zygosity"]}",
          ),
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
      constraints: compact
          ? null
          : const BoxConstraints(
              maxWidth: 150,
            ),

      padding: EdgeInsets.symmetric(
        horizontal:
            compact ? 10 : 12,

        vertical:
            compact ? 7 : 10,
      ),

      decoration: BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(14),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          Flexible(
            child: Text(
              text,

              overflow:
                  TextOverflow.visible,

              style: TextStyle(
                color: color,

                fontSize:
                    compact ? 12 : 11.5,

                fontWeight:
                    FontWeight.w800,

                height: 1.25,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
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
          padding:
              const EdgeInsets.symmetric(
            vertical: 11,
          ),

          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFF3F0FF),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: Icon(
                  icon,
                  color: mainPurple,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              SizedBox(
                width: 120,

                child: Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 12,
                  ),

                  child: Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 14,
                      color:
                          Color(0xFF171733),

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 10,
                  ),

                  child:
                      valueWidget ??
                      Text(
                        value ?? '',

                        style:
                            const TextStyle(
                          fontSize: 14,
                          color:
                              Color(0xFF171733),

                          fontWeight:
                              FontWeight.w600,

                          height: 1.45,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFEEEFF6),
          ),
      ],
    );
  }
}
// CONFIDENCE BADGE

class _ConfidenceBadge
    extends StatelessWidget {

  final String value;

  const _ConfidenceBadge({
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 120,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFEDEBFF),

        borderRadius:
            BorderRadius.circular(12),
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