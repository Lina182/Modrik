import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/consultation_service.dart';
import 'dart:async';
import '../users/individual_report_screen.dart';
import '../users/cross_report_screen.dart';
import '../../models/individual_report_item.dart';
import '../../models/cross_report_item.dart';

class ChatScreen extends StatefulWidget {
  final int consultationId;
  final String title;
  final String status;
  final Map reportData;
  final bool isCompleted;
  final String expertName;

  const ChatScreen({super.key,
  required this.title,
  required this.consultationId,
  required this.status,
  required this.reportData,
  required this.isCompleted,
  required this.expertName});

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
    (_) {
      loadMessages();
    },
  );
}

Future<void> initUser() async {

  currentUserId = await getUserId();
  currentUserRole = await getUserRole();

  print("CHAT USER ID = $currentUserId");
  print("CHAT USER ROLE = $currentUserRole");

  setState(() {});

  await loadMessages();
}


Future<void> loadMessages() async {

  if (currentUserId == null || currentUserRole == null) {
    return;
  }

  final res = await http.get(
    Uri.parse(
      "http://172.237.116.141:8003/messages/${widget.consultationId}"
      "?current_user_id=$currentUserId"
      "&current_user_role=$currentUserRole",
    ),
  );

  final data = jsonDecode(res.body);

  setState(() {
    msgs = data["messages"] ?? [];
  });
}


Future<void> send() async {

  if (c.text.trim().isEmpty) return;

  final res = await http.post(
    Uri.parse("http://172.237.116.141:8003/messages/send"),

    headers: {
      "Content-Type": "application/json"
    },

    body: jsonEncode({

      "consultation_id": widget.consultationId,

      "sender_id": currentUserId,

      "message_text": c.text.trim(),
    }),
  );

  print(res.body);

  print("SENDING AS USER ID = $currentUserId");

  c.clear();

  await loadMessages();
}

@override
void dispose() {
  refreshTimer?.cancel();
  super.dispose();
}

Widget buildTitle(){
 if(currentUserRole == "expert"){
  return Text("Case #${widget.consultationId}",
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  );
 } else {
return Text(widget.expertName,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: Column(
        children: [
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                circleBtn(Icons.arrow_back_ios_new, () {
                  Navigator.pop(context);
                }),
                const SizedBox(width: 10),
                const CircleAvatar(),
                const SizedBox(width: 12),
              
                 Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        buildTitle(),

                        if (currentUserRole != "expert" && widget.status != "completed")
                          const Text(
                            "Online",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                      ],
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

              /// CROSS REPORT
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

              }

              /// INDIVIDUAL REPORT
              else {

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

                  const Icon(
                    Icons.description,
                    color: Color(0xFF6C63FF),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.reportData["report_name"] ?? "Unknown Report",

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "Case #${widget.reportData["id"]}",

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
                print("MESSAGE SENDER = ${m["sender_id"]}");
                print("CURRENT USER = $currentUserId");
                bool isMe =m['sender_id'].toString() == currentUserId.toString();


                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF6C63FF) 
                      : Colors.grey[300],
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
                      hintText: "Type a message...",
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
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}