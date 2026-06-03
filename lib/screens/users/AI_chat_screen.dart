import 'dart:convert';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/ai_chat_service.dart';

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

  List<Map<String, String>> chatHistory = [];

  late Map<String, dynamic>? reportData;

  @override
  void initState() {
    super.initState();
    reportData = widget.reportData;

    /// ما نحط نص ثابت هنا (نضيفه في build بعد الترجمة)
  }

  /// ================= BACKEND =================

  bool _initialized = false;

  void _initMessages(AppLocalizations t) {
    if (_initialized) return;
    _initialized = true;

    messages.add({"sender": "bot", "text": t.welcomeBot});

    if (reportData != null) {
      chatHistory.add({
        "role": "user",
        "content": "This is my genetic report: ${jsonEncode(reportData)}",
      });

      messages.add({"sender": "bot", "text": t.reportReceived});
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    _initMessages(t);

    final size = MediaQuery.of(context).size;
    final width = size.width;

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
              child: Text(t.reportModeBanner, textAlign: TextAlign.center),
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
                  alignment: isBot
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(width * 0.04),
                    constraints: BoxConstraints(maxWidth: width * 0.75),
                    decoration: BoxDecoration(
                      color: isBot ? const Color(0xFFD6D9F2) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message["text"] ?? ""),
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
                    decoration: InputDecoration(hintText: t.messageHint),
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

  void sendUserMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final t = AppLocalizations.of(context)!;

    String userMessage = _controller.text.trim();
    _controller.clear();

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      messages.add({"sender": "bot", "text": t.typing});
    });

    chatHistory.add({"role": "user", "content": userMessage});

    String botReply = await AIChatService.sendMessage(
      messages: chatHistory,
      reportData: reportData,
    );

    chatHistory.add({"role": "assistant", "content": botReply});

    setState(() {
      messages.removeLast();
      messages.add({"sender": "bot", "text": botReply});
    });
  }
}
