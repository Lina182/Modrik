import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../l10n/app_localizations.dart';

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

  /// 🔥 ذاكرة الشات
  List<Map<String, String>> chatHistory = [];

  /// 🔥 التقرير
  late Map<String, dynamic>? reportData;

  @override
  void initState() {
    super.initState();

    reportData = widget.reportData;

    /// رسالة البداية
    messages.add({
      "sender": "bot",
      "text": "welcome",
    });

    /// لو دخل مع تقرير
    if (reportData != null) {
      chatHistory.add({
        "role": "user",
        "content": "This is my genetic report: ${jsonEncode(reportData)}",
      });

      messages.add({
        "sender": "bot",
        "text": "report_received",
      });
    }
  }

  /// ================= BACKEND =================
  Future<String> sendMessageToBackend() async {
    final t = AppLocalizations.of(context)!;

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
    final t = AppLocalizations.of(context)!;

    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          reportData != null
              ? t.chatTitleReport
              : t.chatTitleGeneral,
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

                String text = message["text"] ?? "";

                /// ترجمة الرسائل الثابتة
                if (text == "welcome") {
                  text = t.welcomeBot;
                } else if (text == "report_received") {
                  text = t.reportReceived;
                } else if (text == "typing") {
                  text = t.typing;
                }

                return Align(
                  alignment: isBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    padding: EdgeInsets.all(width * 0.04),

                    constraints: BoxConstraints(
                      maxWidth: width * 0.75,
                    ),

                    decoration: BoxDecoration(
                      color: isBot? const Color(0xFFD6D9F2)
                          : Colors.white,

                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Text(text),
                  ),
                );
              },
            ),
          ),

          /// الإدخال
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
                  onPressed: sendUserMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SEND =================
  void sendUserMessage() async {
    final t = AppLocalizations.of(context)!;

    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();

    _controller.clear();

    /// UI
    setState(() {
      messages.add({
        "sender": "user",
        "text": userMessage,
      });

      messages.add({
        "sender": "bot",
        "text": "typing",
      });
    });

    /// 🔥 نضيف للذاكرة
    chatHistory.add({
      "role": "user",
      "content": userMessage,
    });

    /// 🔥 نرسل كامل الهيستوري
    String botReply = await sendMessageToBackend();

    /// 🔥 نحفظ رد البوت
    chatHistory.add({
      "role": "assistant",
      "content": botReply,
    });

    /// UI
    setState(() {
      messages.removeLast();

      messages.add({
        "sender": "bot",
        "text": botReply.isEmpty
            ? t.somethingWentWrong
            : botReply,
      });
    });
  }
}