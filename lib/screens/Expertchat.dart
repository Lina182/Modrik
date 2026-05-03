import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat/chat_screen.dart';

class Expertchat extends StatefulWidget {
  const Expertchat({super.key});

  @override
  State<Expertchat> createState() => _ExpertchatState();
}

class _ExpertchatState extends State<Expertchat> {
  int tab = 0;

  List reports = [
    {"t": "Report #102", "d": "2026-04-21", "r": false, "s": "Waiting for expert"},
    {"t": "Report #103", "d": "2026-04-20", "r": false, "s": "In Progress"},
    {"t": "Report #104", "d": "2026-04-19", "r": false, "s": "In Progress"},
    {"t": "Report #100", "d": "2026-04-18", "r": true, "s": "Completed"},
  ];

  @override
  Widget build(BuildContext context) {
    var list = reports.where((e) => tab == 1 ? e["r"] : !e["r"]).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Column(
        children: [

          /// 🔥 HEADER مع DNA فقط
          Stack(
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE0E2FF), Color(0xFFF3F4FF)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),

              /// DNA
              Positioned(
                right: -40,
                top: -30,
                child: Transform.rotate(
                  angle: 0.6,
                  child: FaIcon(
                    FontAwesomeIcons.dna,
                    size: 220,
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                  ),
                ),
              ),

              /// BACK
              Positioned(
                top: 50,
                left: 20,
                child: circleBtn(Icons.arrow_back_ios_new, () {
                  Navigator.pop(context);
                }),
              ),

              /// NOTIFICATION
              Positioned(
                top: 50,
                right: 20,
                child: circleBtn(Icons.notifications_none, () {}),
              ),

              /// TEXT
              const Positioned(
                left: 20,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Consultations",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Track your consultations and\nchat with our experts.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// TABS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                tabBtn("Active", 0, Icons.access_time),
                tabBtn("Completed", 1, Icons.check_circle_outline),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: list.length,
              itemBuilder: (_, i) {
                var item = list[i];

                return GestureDetector(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(title: item["t"]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: item["r"]
                                ? Colors.green.withOpacity(0.1)
                                : (item["s"] == "Waiting for expert"
                                    ? Colors.orange.withOpacity(0.1)
                                    : const Color(0xFFEDEBFF)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item["r"]
                                ? Icons.check_circle_outline
                                : (item["s"] == "Waiting for expert"
                                    ? Icons.access_time
                                    : Icons.chat_bubble_outline),
                            color: item["r"]
                                ? Colors.green
                                : (item["s"] == "Waiting for expert"
                                    ? Colors.orange
                                    : const Color(0xFF6C63FF)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item["t"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Text(
                                item["s"],
                                style: TextStyle(
                                  color: item["r"]
                                      ? Colors.green
                                      : (item["s"] == "Waiting for expert"
                                          ? Colors.orange
                                          : const Color(0xFF6C63FF)),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 16, color: Color(0xFF6C63FF)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// BOX
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF6C63FF)),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Open a consultation to start or continue chatting with the expert.",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBtn(String t, int i, IconData ic) {
    bool a = tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: a ? const Color(0xFF6C63FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(ic, size: 18, color: a ? Colors.white : Colors.grey),
              const SizedBox(width: 8),
              Text(
                t,
                style: TextStyle(
                  color: a ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circleBtn(IconData icon, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}