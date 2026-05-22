import 'package:flutter/material.dart';
import 'admin_profile.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

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

List<dynamic> expertsStats = [];
bool expertsLoading = true;

  @override
  void initState() {
    super.initState();
    loadHealth();
    fetchAnalysisCounts();
    fetchAnalysisStats();
    fetchExpertStatistics();
  }

  // 🔥 API CALL (متروكة كما هي بدون أي تعديل لضمان استمرار الربط)
  Future<Map<String, dynamic>> fetchSystemHealth() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();

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

  Future<void> fetchExpertStatistics() async {
  final response = await http.get(
    Uri.parse("http://172.237.116.141:8003/expert-statistics"),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    setState(() {
      expertsStats = data['experts'];
      expertsLoading = false;
    });
  } else {
    setState(() {
      expertsLoading = false;
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

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الهيدر العلوي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: AppTextStyles.title.copyWith(fontSize: 26),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Overview of the platform',
                          style: AppTextStyles.subtitle,
                        ),
                      ],
                    ),
                    GestureDetector(onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileAdminScreen(),
                          ),
                        );
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
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // قسم الكروت الثلاثية العلوية بعد تنظيفها وحذف النسب المئوية تماماً
                Row(
                  children: [
                    _buildDashboardCard(
                      'Individual analyses',
                      individualCount.toString(),
                      Icons.bar_chart_rounded,
                      const Color(0xFFE8E9F9),
                      AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildDashboardCard(
                      'All Users',
                      loading ? '...' : (healthData?['total_users']?.toString() ?? '0'),
                      Icons.people_alt_rounded,
                      AppColors.gradientStart,
                      AppColors.softPurple,
                    ),
                    const SizedBox(width: 12),
                    _buildDashboardCard(
                      'Cross Analyses',
                      crossCount.toString(),
                      Icons.flip_to_front_rounded,
                      const Color(0xFFEBF3FE),
                      Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // كارت الـ Analysis Outcomes
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analysis outcomes',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: _buildCircularChart()),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAnalysisStatusRow(
                                  'Success analyses',
                                  '${(successRate * 100).toStringAsFixed(0)}%',
                                  '($successCount)',
                                  Colors.green,
                                ),
                                const SizedBox(height: 20),
                                _buildAnalysisStatusRow(
                                  'Failed analyses',
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
                ),const SizedBox(height: 24),

                // كارت حالة الـ APIs
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'API Status',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: 12),
                      _buildAPIStatus(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

// Consultants Section
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Consultants',
        style: AppTextStyles.title,
      ),

      const SizedBox(height: 18),

      if (expertsLoading)
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        )
      else if (expertsStats.isEmpty)
        const Text(
          "No consultants found",
        )
      else
        Column(
          children: expertsStats.map((expert) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.gradientStart,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      expert['expert_name'],
                      style: AppTextStyles.title.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Text(
                    '${expert['completed_consultations_count']} consultations',
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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

  // الدالة المحدثة التي تعرض المسمى والرقم الحالي فقط بداخل الكروت بدون قيم مقارنة زائدة
  Widget _buildDashboardCard(String title, String value, IconData icon, Color iconBg, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        height: 125, // طول الكارت أصبح متناسقاً جداً ومناسباً لحجم المحتوى الجديد
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // لتوزيع المحتوى الداخلي بالتساوي عمودياً
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(height: 1.1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.title.copyWith(fontSize: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularChart() {
    int totalCount = successCount + failedCount;
    return Center(
      child: SizedBox(
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 130,
              height: 130,
              child: CustomPaint(
                painter: _ProgressPainter(
                  successRate: successRate,
                  failedRate: failedRate,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total",
                  style: AppTextStyles.subtitle,
                ),
                Text(
                  "$totalCount",
                  style: AppTextStyles.title.copyWith(fontSize: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisStatusRow(String title, String percent, String count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w500, color: AppColors.textGrey),
              ),
            ),
          ],),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 2),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$percent ',
                  style: AppTextStyles.title.copyWith(fontSize: 18, color: Colors.black),
                ),
                TextSpan(
                  text: count,
                  style: AppTextStyles.subtitle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAPIStatus() {
    return FutureBuilder(
      future: fetchSystemHealth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Error loading API status", style: TextStyle(color: Colors.red)),
          );
        }

        final data = snapshot.data as Map<String, dynamic>;

        return Column(
          children: [
            _buildAPIStatusItem(
              'OpenCRAVAT API',
              data['opencravat'] ?? 'Down',
              _getColor(data['opencravat'] ?? 'Down'),
            ),
            const Divider(color: AppColors.gradientStart, height: 1),
            _buildAPIStatusItem(
              'PanelApp API',
              data['panelapp'] ?? 'Down',
              _getColor(data['panelapp'] ?? 'Down'),
            ),
            const Divider(color: AppColors.gradientStart, height: 1),
            _buildAPIStatusItem(
              'Gemini API',
              data['gemini'] ?? 'Down',
              _getColor(data['gemini'] ?? 'Down'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAPIStatusItem(String apiName, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            apiName,
            style: AppTextStyles.title.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                status[0].toUpperCase() + status.substring(1).toLowerCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double successRate;
  final double failedRate;
  _ProgressPainter({required this.successRate, required this.failedRate});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.butt;

    double total = successRate + failedRate;
    
    if (total == 0) {
      paint.color = Colors.grey.shade200;
      canvas.drawArc(Offset.zero & size, 0, math.pi * 2, false, paint);
      return;
    }

    double successAngle = (math.pi * 2) * (successRate / total);
    double failedAngle = (math.pi * 2) * (failedRate / total);
    double pendingAngle = (math.pi * 2) - successAngle - failedAngle;

    double startAngle = -math.pi / 2;

    // 1. Success
    paint.color = Colors.green;
    canvas.drawArc(Offset.zero & size, startAngle, successAngle, false, paint);
    startAngle += successAngle;

    // 2. Failed
    paint.color = Colors.red;
    canvas.drawArc(Offset.zero & size, startAngle, failedAngle, false, paint);
    startAngle += failedAngle;

    if (pendingAngle > 0) {
      paint.color = AppColors.primary;
      canvas.drawArc(Offset.zero & size, startAngle, pendingAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}