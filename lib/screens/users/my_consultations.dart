import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../services/consultation_service.dart';
import '../shared/chat_screen.dart';
import 'UserConsultationDetailsScreen.dart';

class Expertchat extends StatefulWidget {
  const Expertchat({super.key});

  @override
  State<Expertchat> createState() => _ExpertchatState();
}

class _ExpertchatState extends State<Expertchat> {
  int tab = 0;

  List consultations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadConsultations();
  }

  Future<void> loadConsultations() async {
    final userId = await getUserId();

    final data =
        await ConsultationService.getUserConsultations(
          userId: userId,
        );

    setState(() {
      consultations = data;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    var list = consultations.where((e) {
    if (tab == 0) {
          return e["status"] == "waiting";
        }

        if (tab == 1) {
          return e["status"] == "active";
        }

        return e["status"] == "completed";
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),

      body: Column(
        children: [
          /// 🔥 HEADER
          Stack(
            children: [
              Container(
                height: 220,

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE0E2FF),
                      Color(0xFFF3F4FF),
                    ],
                  ),

                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),

              /// DNA ICON
              Positioned(
                right: -40,
                top: -30,

                child: Transform.rotate(
                  angle: 0.6,

                  child: FaIcon(
                    FontAwesomeIcons.dna,

                    size: 220,

                    color: const Color(
                      0xFF6C63FF,
                    ).withOpacity(0.15),
                  ),
                ),
              ),

              /// BACK BUTTON
              Positioned(
                top: 50,
                left: 20,

                child: circleBtn(
                  Icons.arrow_back_ios_new,
                  () {
                    Navigator.pop(context);
                  },
                ),
              ),


              /// TEXT
              Positioned(
                left: 20,
                bottom: 30,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      t.myConsultations,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      t.consultationDesc,

                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// TABS
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            padding: const EdgeInsets.all(5),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(15),boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),

            child: Row(
              children: [
                tabBtn("Waiting", 0, Icons.access_time),
                tabBtn("Active", 1, Icons.chat_bubble_outline),
                tabBtn("Completed", 2, Icons.check_circle_outline),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 LOADING
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),

                itemCount: list.length,

                itemBuilder: (_, i) {
                  var item = list[i];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserConsultationDetailsScreen(
                            consultation: item,
                          ),
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
                          ),
                        ],
                      ),

                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item["status"] == "waiting"
                                    ? Colors.orange.withOpacity(0.12)
                                    : item["status"] == "completed"
                                        ? Colors.green.withOpacity(0.12)
                                        : const Color(0xFF6C63FF).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Icon(
                                item["status"] == "waiting"
                                    ? Icons.access_time
                                    : item["status"] == "completed"
                                        ? Icons.check_circle
                                        : Icons.chat_bubble_outline,
                                color: item["status"] == "waiting"
                                    ? Colors.orange
                                    : item["status"] == "completed"
                                        ? Colors.green
                                        : const Color(0xFF6C63FF),
                              ),
                            ),

                          const SizedBox(width: 15),

                          Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["report_name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      item["type"] ?? "Individual",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      item["created_at"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      item["status"],
                                      style: TextStyle(
                                        color: item["status"] == "completed"
                                            ? Colors.green
                                            : item["status"] == "waiting"
                                                ? Colors.orange
                                                : const Color(0xFF6C63FF),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF6C63FF),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),

          /// INFO BOX
          Container(
            margin: const EdgeInsets.all(20),

            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),

              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF6C63FF),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    t.consultationInfo,

                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBtn(
    String t,
    int i,
    IconData ic,
  ) {
    bool a = tab == i;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = i),

        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: a
                ? const Color(0xFF6C63FF)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(12),
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Icon(
                ic,
                size: 18,
                color:
                    a ? Colors.white : Colors.grey,
              ),

              const SizedBox(width: 8),

              Text(
                t,

                style: TextStyle(
                  color:
                      a ? Colors.white : Colors.grey,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circleBtn(
    IconData icon,
    VoidCallback tap,
  ) {
    return GestureDetector(
      onTap: tap,child: Container(
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