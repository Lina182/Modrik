import 'package:flutter/material.dart';
import 'admin_profile.dart';  // استيراد صفحة الـ Profile الجديدة

const Color mainPurple = Color(0xFFC4C8EA);  // اللون الأساسي
const Color bgPurple = Color(0xFF9DA3D9);  // خلفية اللون البنفسجي
const Color moviePurple = Color(0xFF7A5CC1);  // اللون الموف الجديد

class AdminDashScreen extends StatelessWidget {
  const AdminDashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: moviePurple,
        actions: [
          // إضافة أيقونة بروفايل في الجهة اليمنى
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // عند النقر على الأيقونة، الانتقال إلى صفحة admin_profile.dart
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
            // عرض عدد التحليلات الفردية و جميع المستخدمين و التحليلات المجمعة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDashboardCard('Individual analyses', '742', Icons.analytics),
                _buildDashboardCard('All Users', '3478', Icons.people),
                _buildDashboardCard('Cross Analyses', '1356', Icons.compare),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Analysis outcomes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCircularChart(),  // هنا نعرض الدائرة
            const SizedBox(height: 30),
            // عرض النسب المئوية للفشل والنجاح
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
                Icon(
                  icon,
                  size: 30,
                  color: moviePurple, // تغيير اللون إلى الموف
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
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
        width: 200, // زيادنا الحجم ليكون أكثر وضوحًا
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: moviePurple, width: 8),
        ),
        child: CustomPaint(
          painter: _ProgressPainter(),  // استخدام الرسام المخصص هنا
        ),
      ),
    );
  }// إضافة الـ Widget الجديد لعرض النسب المئوية
  Widget _buildAnalysisStatus(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // الدائرة على اليسار
        CircleAvatar(
          radius: 10,
          backgroundColor: color, 
        ),
        const SizedBox(width: 10),
        // النص يكون باللون الأسود
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

  Widget _buildAPIStatus() {
    return Column(
      children: [
        _buildAPIStatusItem('OpenCARVAT API', 'Stable', Colors.green),
        _buildAPIStatusItem('PanelApp API', 'Stable', Colors.green),
        _buildAPIStatusItem('Gemini API', 'Unstable', Colors.red),
      ],
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
              Icon(
                Icons.circle,
                color: color,
                size: 12,
              ),
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
      ..strokeWidth = 12;  // زيادة سمك الخط لجعل الدائرة واضحة

    // رسم الجزء الفاشل باللون الأحمر
    paint.color = Colors.red;
    canvas.drawArc(
      Offset.zero & size,
      -1.5708,  // الزاوية الأولية (نصف الدائرة)
      3.1416 * 0.25,  // 25% من الدائرة (الفشل)
      false,
      paint,
    );

    // رسم الجزء الناجح باللون الأخضر
    paint.color = Colors.green;
    canvas.drawArc(
      Offset.zero & size,
      -1.5708 + 3.1416 * 0.25,  // بدء من حيث انتهى الجزء الأحمر
      3.1416 * 0.75,  // 75% من الدائرة (النجاح)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}