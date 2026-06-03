import 'package:flutter/material.dart';
import '../../services/consultation_service.dart';
import 'dart:async';
import '../users/individual_report_screen.dart';
import '../users/cross_report_screen.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';
import '../../l10n/app_localizations.dart';
import '../../services/message_service.dart';

class ChatScreen extends StatefulWidget {
  final int consultationId;
  final String title;
  final String status;
  final Map reportData;
  final bool isCompleted;
  final String expertName;

  const ChatScreen({
    super.key,
    required this.title,
    required this.consultationId,
    required this.status,
    required this.reportData,
    required this.isCompleted,
    required this.expertName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int? currentUserId;
  String? currentUserRole;
  Timer? refreshTimer;
  List msgs = [];
  final TextEditingController c = TextEditingController();

  @override
  void initState() {
    super.initState();

    msgs = [];
    initUser();

    refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => loadMessages(),
    );
  }

  Future<void> initUser() async {
    currentUserId = await getUserId();
    currentUserRole = await getUserRole();

    setState(() {});
    await loadMessages();
  }

  Future<void> loadMessages() async {
    if (currentUserId == null || currentUserRole == null) return;

    final data = await MessageService.loadMessages(
      consultationId: widget.consultationId,
      currentUserId: currentUserId!,
      currentUserRole: currentUserRole!,
    );

    setState(() {
      msgs = data["messages"] ?? [];
    });
  }

  Future<void> send() async {
    if (c.text.trim().isEmpty) return;

    await MessageService.sendMessage(
      consultationId: widget.consultationId,
      senderId: currentUserId!,
      message: c.text.trim(),
    );

    c.clear();
    await loadMessages();
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Widget buildTitle(AppLocalizations t) {
    if (currentUserRole == "expert") {
      return Text(
        "${t.caseNumber} #${widget.consultationId}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );
    } else {
      return Text(
        widget.expertName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );
    }
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
        child: Icon(icon, size: 18, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Column(
        children: [
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                circleBtn(
                  Icons.arrow_back_ios_new,
                  () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [buildTitle(t)],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 30, color: Colors.black12),

          if (!widget.isCompleted)
            GestureDetector(
              onTap: () {
                final data = widget.reportData["report_data"];
                if (data == null) return;

                if (widget.reportData["report_type"] == "cross") {
                  final reports = (data as List)
                      .map(
                        (e) => CrossReportItem.fromJson(
                          Map<String, dynamic>.from(e),
                          widget.reportData["report_name"] ?? "",
                        ),
                      )
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CrossReportScreen(
                        reports: reports,
                        fileName: widget.reportData["report_name"] ?? "",
                        showDownload: false,
                        isExpertView: currentUserRole == "expert",
                      ),
                    ),
                  );
                } else {
                  final reports = (data as List)
                      .map(
                        (e) => IndividualReportItem.fromJson(
                          Map<String, dynamic>.from(e),
                          null,
                        ),
                      )
                      .toList();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => IndividualReportScreen(
                        reportItems: reports,
                        fileName: widget.reportData["report_name"] ?? "",
                        showDownload: false,
                        isExpertView: currentUserRole == "expert",
                      ),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFE0E2FF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.reportData["report_name"] ?? t.notAvailable,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${t.caseNumber} #${widget.reportData["id"]}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                var m = msgs[i];

                bool isMe =
                    m['sender_id'].toString() == currentUserId.toString();

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF6C63FF) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m["message_text"],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (widget.status != "completed")
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: c,
                      decoration: InputDecoration(
                        hintText: t.typeMessage,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF6C63FF),
                    child: IconButton(
                      onPressed: send,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
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
}
