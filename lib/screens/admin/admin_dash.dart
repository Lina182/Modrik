import 'package:flutter/material.dart';
import 'admin_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

const Color mainPurple = Color(0xFFC4C8EA);
const Color bgPurple = Color(0xFF9DA3D9);
const Color moviePurple = Color(0xFF7A5CC1);

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

@override
void initState() {
  super.initState();
  loadHealth();
  fetchAnalysisCounts();
}

  // 🔥 API CALL
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

  // 🎨 تحديد اللون حسب الحالة
  Color _getColor(String status) {
    if (status == "stable") return Colors.green;
    if (status == "unstable") return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: moviePurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileAdminScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardCard('Individual analyses', individualCount.toString(), Icons.analytics),
                _buildDashboardCard('All Users',
                  loading ? '...' : (healthData?['total_users']?.toString() ?? '0'),
                  Icons.people,
                ),
                _buildDashboardCard('Cross Analyses', crossCount.toString(), Icons.compare),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Analysis outcomes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCircularChart(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnalysisStatus('Success analyses', '75%', Colors.green),
                _buildAnalysisStatus('Failed analyses', '25%', Colors.red),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'API Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // 🔥 هنا الربط الحقيقي بالباك
            _buildAPIStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Flexible(
      child: Card(
        color: const Color(0xFFC4C8EA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: SizedBox(
          height: 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: moviePurple),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularChart() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: moviePurple, width: 8),
        ),
        child: CustomPaint(
          painter: _ProgressPainter(),
        ),
      ),
    );
  }

  Widget _buildAnalysisStatus(String title, String value, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        const SizedBox(width: 10),
        Text(
          '$title: $value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // 🔥 دي اللي اتعدلت
  Widget _buildAPIStatus() {
    return FutureBuilder(
      future: fetchSystemHealth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final data = snapshot.data as Map<String, dynamic>;

        return Column(
          children: [
            _buildAPIStatusItem(
              'OpenCRAVAT API',
              data['opencravat'],
              _getColor(data['opencravat']),
            ),
            _buildAPIStatusItem(
              'PanelApp API',
              data['panelapp'],
              _getColor(data['panelapp']),
            ),
            _buildAPIStatusItem(
              'Gemini API',
              data['gemini'],
              _getColor(data['gemini']),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAPIStatusItem(String apiName, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(apiName),
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Text(status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    paint.color = Colors.red;
    canvas.drawArc(Offset.zero & size, -1.5708, 3.1416 * 0.25, false, paint);

    paint.color = Colors.green;
    canvas.drawArc(
      Offset.zero & size,
      -1.5708 + 3.1416 * 0.25,
      3.1416 * 0.75,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}