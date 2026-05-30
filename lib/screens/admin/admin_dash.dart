import 'package:flutter/material.dart';
import 'admin_profile.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;
import '../../l10n/app_localizations.dart';

class AdminDashScreen extends StatefulWidget {
  const AdminDashScreen({super.key});

  @override
  State<AdminDashScreen> createState() => _AdminDashScreenState();
}

class _AdminDashScreenState extends State<AdminDashScreen> {
  Map<String, dynamic>? healthData;
  bool loading = true;

  int individualCount = 0;
  int crossCount = 0;
  int successCount = 0;
  int failedCount = 0;

  double successRate = 0.0;
  double failedRate = 0.0;

  @override
  void initState() {
    super.initState();
    loadHealth();
    fetchAnalysisCounts();
    fetchAnalysisStats();
  }

  Future<Map<String, dynamic>> fetchSystemHealth() async {
    // نجيب المستخدم الحالي من Firebase
    final user = FirebaseAuth.instance.currentUser;

    // إذا المستخدم سجل خروج لا نحاول نجيب Token
    if (user == null) {
      return {
        "opencravat": "offline",
        "panelapp": "offline",
        "gemini": "offline",
        "total_users": 0,
      };
    }

    // نجيب التوكن بعد التأكد أن المستخدم موجود
    final token = await user.getIdToken();

    final response = await http.get(
      Uri.parse("http://172.237.116.141:8003/system/health?token=$token"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load system health");
    }
  }

  Future<void> fetchAnalysisCounts() async {
    final response = await http.get(
      Uri.parse("http://172.237.116.141:8003/analysis-count"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        individualCount = data['individual'];
        crossCount = data['cross'];
      });
    }
  }

  Future<void> fetchAnalysisStats() async {
    final response = await http.get(
      Uri.parse("http://172.237.116.141:8003/analysis-stats"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      int success = data['success'];
      int failed = data['failed'];
      int total = success + failed;

      setState(() {
        successCount = success;
        failedCount = failed;
        successRate = total == 0 ? 0 : success / total;
        failedRate = total == 0 ? 0 : failed / total;
      });
    }
  }

  Future<void> loadHealth() async {
    try {
      final data = await fetchSystemHealth();
      setState(() {
        healthData = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Color _getColor(String status) {
    if (status.toLowerCase() == "stable") return Colors.green;
    if (status.toLowerCase() == "unstable") return Colors.orange;
    return Colors.red;
  }

  String _getTranslatedStatus(String status, AppLocalizations t) {
    switch (status.toLowerCase()) {
      case 'stable':
        return t.stable;
      case 'unstable':
        return t.unstable;
      default:
        return t.offline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.adminDashboard,
                            style: AppTextStyles.title.copyWith(fontSize: 26),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(t.overview, style: AppTextStyles.subtitle),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileAdminScreen(),
                          ),
                        );
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.card,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // CARDS
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                  children: [
                    _buildDashboardCard(
                      t.individualAnalyses,
                      individualCount.toString(),
                      Icons.bar_chart_rounded,
                      const Color(0xFFE8E9F9),
                      AppColors.primary,
                    ),
                    _buildDashboardCard(
                      t.allUsers,
                      loading
                          ? t.loading
                          : (healthData?['total_users']?.toString() ?? '0'),
                      Icons.people_alt_rounded,
                      AppColors.gradientStart,
                      AppColors.softPurple,
                    ),
                    _buildDashboardCard(
                      t.crossAnalyses,
                      crossCount.toString(),
                      Icons.flip_to_front_rounded,
                      const Color(0xFFEBF3FE),
                      Colors.blue,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ANALYSIS
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.analysisOutcomes, style: AppTextStyles.title),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _buildCircularPainterContainer(t),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAnalysisStatusRow(
                                  t.successAnalyses,
                                  '${(successRate * 100).toStringAsFixed(0)}%',
                                  '($successCount)',
                                  Colors.green,
                                ),
                                const SizedBox(height: 20),
                                _buildAnalysisStatusRow(
                                  t.failedAnalyses,
                                  '${(failedRate * 100).toStringAsFixed(0)}%',
                                  '($failedCount)',
                                  Colors.red,
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

                // API STATUS
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.apiStatus, style: AppTextStyles.title),
                      const SizedBox(height: 12),
                      _buildAPIStatus(t),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // CONSULTANTS
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.consultants, style: AppTextStyles.title),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8E9F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.doctorAhmad,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.consultations,
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "2",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String value,
    IconData icon,
    Color iconBg,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.title.copyWith(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPainterContainer(AppLocalizations t) {
    int total = successCount + failedCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        double diameter = constraints.maxWidth < 120
            ? constraints.maxWidth
            : 120;
        return SizedBox(
          width: diameter,
          height: diameter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(diameter, diameter),
                painter: _ProgressPainter(successRate, failedRate),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    t.total,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    "$total",
                    style: AppTextStyles.title.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalysisStatusRow(
    String title,
    String percent,
    String count,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, top: 2),
          child: Text("$percent $count", style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildAPIStatus(AppLocalizations t) {
    return FutureBuilder(
      future: fetchSystemHealth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text(t.loading));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Column(
            children: [
              _buildAPIStatusItem("OpenCRAVAT API", "offline", Colors.red, t),
              _buildAPIStatusItem("PanelApp API", "offline", Colors.red, t),
              _buildAPIStatusItem("Gemini API", "offline", Colors.red, t),
            ],
          );
        }

        final data = snapshot.data as Map<String, dynamic>;

        return Column(
          children: [
            _buildAPIStatusItem(
              "OpenCRAVAT API",
              data['opencravat'] ?? 'offline',
              _getColor(data['opencravat'] ?? 'offline'),
              t,
            ),
            _buildAPIStatusItem(
              "PanelApp API",
              data['panelapp'] ?? 'offline',
              _getColor(data['panelapp'] ?? 'offline'),
              t,
            ),
            _buildAPIStatusItem(
              "Gemini API",
              data['gemini'] ?? 'offline',
              _getColor(data['gemini'] ?? 'offline'),
              t,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAPIStatusItem(
    String name,
    String status,
    Color color,
    AppLocalizations t,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          Row(
            children: [
              Container(width: 8, height: 8, color: color),
              const SizedBox(width: 6),
              Text(_getTranslatedStatus(status, t)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double success;
  final double failed;

  _ProgressPainter(this.success, this.failed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    paint.color = Colors.grey.withOpacity(0.2);
    canvas.drawArc(Offset.zero & size, 0, 2 * math.pi, false, paint);

    double total = success + failed;
    if (total == 0) return;

    double start = -math.pi / 2;

    if (success > 0) {
      paint.color = Colors.green;
      canvas.drawArc(
        Offset.zero & size,
        start,
        2 * math.pi * success,
        false,
        paint,
      );
      start += 2 * math.pi * success;
    }

    if (failed > 0) {
      paint.color = Colors.red;
      canvas.drawArc(
        Offset.zero & size,
        start,
        2 * math.pi * failed,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
