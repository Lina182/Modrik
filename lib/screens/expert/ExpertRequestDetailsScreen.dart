import 'package:flutter/material.dart';

class ExpertRequestDetailsScreen extends StatelessWidget {
  final Map consultation;

  const ExpertRequestDetailsScreen({super.key, required this.consultation});

  @override
  Widget build(BuildContext context) {
    bool isWaiting = consultation["status"] == "waiting";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// ===== TOP BAR =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),

                  const Text(
                    "Request Details",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: consultation["status"] == "waiting"
                          ? Colors.orange.withOpacity(0.12)
                          : consultation["status"] == "active"
                          ? const Color(0xFFEDEBFF)
                          : Colors.green.withOpacity(0.12),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      consultation["status"],

                      style: TextStyle(
                        color: consultation["status"] == "waiting"
                            ? Colors.orange
                            : consultation["status"] == "active"
                            ? const Color(0xFF6C63FF)
                            : Colors.green,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ===== REPORT TITLE =====
              const Text(
                "Report",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              const SizedBox(height: 14),

              /// ===== REPORT CARD =====
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),

                      blurRadius: 16,

                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    /// ICON
                    Container(
                      width: 55,
                      height: 55,

                      decoration: BoxDecoration(
                        color: const Color(0xFFEDEBFF),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.description_outlined,

                        color: Color(0xFF6C63FF),

                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// TEXTS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          /// REPORT NAME
                          Text(
                            consultation["report_name"] ?? "Unknown Report",

                            style: const TextStyle(
                              fontWeight: FontWeight.w700,

                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// CASE ID
                          Text(
                            "Case #${consultation["id"]}",

                            style: TextStyle(
                              color: Colors.grey.shade600,

                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// VIEW REPORT
                    OutlinedButton(
                      onPressed: () {
                        /// 🔥 بعدين بنفتح التقرير الحقيقي هنا
                      },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6C63FF),

                        side: const BorderSide(color: Color(0xFF6C63FF)),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text("View Report"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ===== USER MESSAGE =====
              const Text(
                "User Question",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              const SizedBox(height: 14),

              /// ===== MESSAGE BOX =====
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFF1EEFF),

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.format_quote_rounded,

                      color: Color(0xFF6C63FF),

                      size: 34,
                    ),
                    const SizedBox(height: 10),

                    /// USER QUESTION
                    Text(
                      consultation["user_question"] ?? "No question provided",

                      style: const TextStyle(fontSize: 14, height: 1.7),
                    ),

                    const SizedBox(height: 14),

                    /// DATE
                    Text(
                      consultation["created_at"].toString(),

                      style: TextStyle(
                        color: Colors.grey.shade600,

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// ===== NOTES =====
              const Text(
                "Notes",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),

              const SizedBox(height: 14),

              /// ===== NOTES BOX =====
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FC),

                  borderRadius: BorderRadius.circular(22),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.info_outline_rounded,

                      color: Color(0xFF6C63FF),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        isWaiting
                            ? "You can accept this request to start chatting with the user."
                            : "This consultation is already active or completed.",

                        style: TextStyle(
                          color: Colors.grey.shade700,

                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              /// ===== ACCEPT BUTTON =====
              if (isWaiting)
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: () {
                      /// 🔥 الخطوة الجاية:
                      /// accept consultation
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.check_circle, color: Colors.white),

                        SizedBox(width: 10),

                        Text(
                          "Accept Request",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
