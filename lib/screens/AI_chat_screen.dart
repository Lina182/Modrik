import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';

class AIChatScreen extends StatefulWidget {
  final Map<String, dynamic>? reportData;
  const AIChatScreen({super.key, this.reportData});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();

  /// UI messages
  final List<Map<String, String>> messages = [];

  /// 🔥 ذاكرة الشات (الأهم)
  List<Map<String, String>> chatHistory = [];

  /// 🔥 التقرير (لو موجود)
  late Map<String, dynamic>? reportData;

  @override
  void initState() {
    super.initState();

    reportData = widget.reportData;

    /// أول رسالة من البوت (مؤقتة هنا - تتحول لاحقًا من الترجمة داخل build)
    messages.add({
      "sender": "bot",
      "text": "..."
    });

    /// لو دخل مع تقرير
    if (reportData != null) {
      chatHistory.add({
        "role": "user",
        "content": "This is my genetic report: ${jsonEncode(reportData)}",
      });

      messages.add({
        "sender": "bot",
        "text": "..."
      });
    }
  }

  /// ================= BACKEND =================
  Future<String> sendMessageToBackend(AppLocalizations t) async {
    final url = Uri.parse("http://172.237.116.141:8003/chat/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "messages": chatHistory,
          "analysis_data": reportData,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"];
      } else {
        return t.serverError;
      }
    } catch (e) {
      return t.connectionError;
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final t = AppLocalizations.of(context)!;

    // تحديث أول رسالة بوت حسب اللغة
    if (messages.isNotEmpty && messages.first["sender"] == "bot") {
      messages[0]["text"] = t.welcomeBot;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          reportData != null ? t.chatTitleReport : t.chatTitleGeneral,
          style: const TextStyle(color: Colors.black),
        ),
      ),

      body: Column(
        children: [
          /// 🔵 حالة الشات
          if (reportData != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.green.withOpacity(0.1),
              child: Text(
                t.reportModeBanner,
                textAlign: TextAlign.center,
              ),
            ),

          /// الرسائل
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isBot = message["sender"] == "bot";

                return Align(
                  alignment:
                      isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(width * 0.04),
                    constraints: BoxConstraints(maxWidth: width * 0.75),
                    decoration: BoxDecoration(
                      color: isBot
                          ? const Color(0xFFD6D9F2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message["text"] ?? ""),
                  ),
                );
              },
            ),
          ),/// الإدخال
          Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: t.messageHint,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendUserMessage(t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SEND =================
  void sendUserMessage(AppLocalizations t) async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();
    _controller.clear();

    /// UI
    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      messages.add({"sender": "bot", "text": t.typing});
    });

    chatHistory.add({"role": "user", "content": userMessage});

    String botReply = await sendMessageToBackend(t);

    chatHistory.add({"role": "assistant", "content": botReply});

    setState(() {
      messages.removeLast();
      messages.add({"sender": "bot", "text": botReply});
    });
  }
}