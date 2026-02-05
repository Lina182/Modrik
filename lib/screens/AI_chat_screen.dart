import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    /// Responsive values
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        /// رجوع للهوم
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // يرجع لصفحة الهوم
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

      /// ---------------- BODY ----------------
      body: Column(
        children: [
          SizedBox(height: height * 0.02),

          /// التاريخ
          const Text(
            "Nov 30, 2023, 9:41 AM",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          SizedBox(height: height * 0.02),

          /// ---------------- MESSAGES ----------------
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
                    constraints: BoxConstraints(
                      maxWidth: width * 0.75, // ريسبونسف
                    ),
                    decoration: BoxDecoration(
                      color: isBot ? const Color(0xFFD6D9F2) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message["text"]!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ---------------- INPUT ----------------
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
                  /// Text input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// Send button
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

  /// ---------------- SEND MESSAGE ----------------
  void sendUserMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text;
    _controller.clear();

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
    });

    /// ================= BACKEND (COMMENTED) =================
    /*
    هنا لاحقًا يتم الربط مع الباك اند:

    1️⃣ ترسلين الرسالة للسيرفر
    2️⃣ السيرفر يعالج (AI / OpenCRAVAT / VarSome)
    3️⃣ يرجع الرد
    4️⃣ تضيفينه كرسالة بوت

    مثال:

    String botReply = await sendMessageToBackend(userMessage);

    setState(() {
      messages.add({
        "sender": "bot",
        "text": botReply,
      });
    });
    */

    /// رد مؤقت (Dummy Response)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      messages.add({
        "sender": "bot",
        "text": "This is a temporary response until backend is connected 🧬",
      });
    });
  }
}
