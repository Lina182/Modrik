import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();

  /// قائمة الرسائل (user / bot)
  final List<Map<String, String>> messages = [
    {
      "sender": "bot",
      "text":
          "Hi! How can I help you today?\nYou can ask about your genetic file or any genetics question you're curious about.",
    },
  ];

  ///  دالة الاتصال بالسيرفر
  Future<String> sendMessageToBackend(String message) async {
    final url = Uri.parse("http://172.237.116.141:8003/chat/");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"];
      } else {
        return "Server error: ${response.statusCode}";
      }
    } catch (e) {
      return "Connection error";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Your smart assistant",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.smart_toy_outlined, color: Colors.black),
          ),
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: height * 0.02),

          const Text(
            "AI Chat",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          SizedBox(height: height * 0.02),

          /// ================= MESSAGES =================
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
                    child: Text(
                      message["text"] ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ================= INPUT =================
          Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      sendUserMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SEND MESSAGE =================
  void sendUserMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();
    _controller.clear();

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
    });

    /// عرض مؤشر تحميل مؤقت
    setState(() {
      messages.add({"sender": "bot", "text": "Typing..."});
    });

    String botReply = await sendMessageToBackend(userMessage);

    setState(() {
      messages.removeLast(); // إزالة "Typing..."
      messages.add({"sender": "bot", "text": botReply});
    });
  }
}
